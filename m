Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaIKO2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:28:34 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:43395 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbaIKO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:28:32 -0400
Date: Thu, 11 Sep 2014 16:28:22 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140911142822.GL22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <1943936.s0DGHUisGb@vostro.rjw.lan>
 <20140911141051.GK22042@dhcp22.suse.cz>
 <1973496.9q6IzlQu6V@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1973496.9q6IzlQu6V@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-09-14 16:32:50, Rafael J. Wysocki wrote:
> On Thursday, September 11, 2014 04:10:51 PM Michal Hocko wrote:
> > On Thu 11-09-14 16:26:56, Rafael J. Wysocki wrote:
> > > On Thursday, September 11, 2014 04:04:48 PM Michal Hocko wrote:
> > > > On Thu 11-09-14 16:17:56, Rafael J. Wysocki wrote:
> > > > [...]
> > > > > And I'm still wondering if the OOM killer may be made avoid killing frozen
> > > > > tasks.
> > > > 
> > > > This is really tricky. OOM killer aims at the biggest memory hog. We
> > > > shouldn't ignore it just because it hides into the fridge... So even
> > > > if we "fix" oom killer to ignore frozen tasks (which is inherently
> > > > racy btw.) then we have a potential problem of freezer abuse (e.g. in
> > > > container environments). So I strongly believe that the OOM killer has
> > > > to be able to kill a frozen tasks.
> > > 
> > > OK
> > > 
> > > Is the OOM killer the only place where TIF_MEMDIE is set?
> > 
> > Yes. To be precise, lowmemorykiller (staging android thingy), global OOM
> > killer and memcg OOM killer. Any other users would be an abuse.
> 
> OK
> 
> So can we ensure that those things don't trigger during system suspend (or
> equivalent) and then simply use the TIF_MEMDIE check in __refrigerator()?

That would require that no memory allocation triggers OOM killer during
suspend. I don't think this will work out. OOM killer is the last resort
action. We cannot simply give access to memory reserves just because the
current context is in the middle of suspend.

What is the worst thing that might happen when a task is killed in the
middle of suspend? I thought that suspend would fail after several
attempts to suspend all existing tasks.

-- 
Michal Hocko
SUSE Labs
