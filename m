Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab3HGNIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:08:42 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:47341 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932908Ab3HGNIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:08:41 -0400
Date: Wed, 7 Aug 2013 09:08:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Message-ID: <20130807130836.GB27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375874907-22013-2-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Aug 07, 2013 at 01:28:26PM +0200, Michal Hocko wrote:
> There is no limit for the maximum number of oom_control events
> registered per memcg. This might lead to an user triggered memory
> depletion if a regular user is allowed to register events.
> 
> Let's be more strict and cap the number of events that might be
> registered. MAX_OOM_NOTIFY_EVENTS value is more or less random. The
> expectation is that it should be high enough to cover reasonable
> usecases while not too high to allow excessive resources consumption.
> 1024 events consume something like 24KB which shouldn't be a big deal
> and it should be good enough (even 1024 oom notification events sounds
> crazy).

I think putting restriction on usage_event makes sense as that builds
a shared contiguous table from all events which can't be attributed
correctly and makes it easy to trigger allocation failures due to
large order allocation but is this necessary for oom and vmpressure,
both of which allocate only for the listening task?  It isn't
different from listening from epoll, for example.  If there needs to
be kernel memory limit, shouldn't that be handled by kmemcg?

Thanks.

-- 
tejun
