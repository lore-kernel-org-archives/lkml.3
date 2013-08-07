Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab3HGOBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:01:10 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:65428 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3HGOBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:01:07 -0400
Date: Wed, 7 Aug 2013 10:01:03 -0400
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
Message-ID: <20130807140103.GH27006@htj.dyndns.org>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
 <20130807135734.GK8184@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807135734.GK8184@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 03:57:34PM +0200, Michal Hocko wrote:
> On Wed 07-08-13 09:47:41, Tejun Heo wrote:
> > Hello,
> > 
> > On Wed, Aug 07, 2013 at 03:37:46PM +0200, Michal Hocko wrote:
> > > > It isn't different from listening from epoll, for example.
> > > 
> > > epoll limits the number of watchers, no?
> > 
> > Not that I know of.  It'll be limited by max open fds but I don't
> > think there are other limits. 
> 
> max_user_watches seems to be a limit (4% of lowmem in maximum).

That's per *user* not per event source.  The problem here is creating
a global (across securit domains) resource shared by all users.

-- 
tejun
