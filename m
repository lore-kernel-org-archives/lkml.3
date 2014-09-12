Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaILXtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:49:00 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:54038 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaILXs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:48:59 -0400
Date: Sat, 13 Sep 2014 08:48:46 +0900
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140912234846.GA28183@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <20140909160625.GC4851@dhcp22.suse.cz>
 <20140909164658.GB11748@mtj.dyndns.org>
 <2008100.1EF7gjK5Z6@vostro.rjw.lan>
 <20140910132417.GF25219@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910132417.GF25219@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Wed, Sep 10, 2014 at 03:24:17PM +0200, Michal Hocko wrote:
> What do you think about this way to help distinguish kernel threads and
> user processes and keep the future maintenance of freezer saner?

I'm not sure either way.  Please note that we have quite a few
wrappers around try_to_freeze() - freezable_schedule*() and
wait_event_freezable*() - and several places where a userland can be
frozen.  Are we gonna introduce an alternate versions for all of them?
What do we actually gain?

Thanks.

-- 
tejun
