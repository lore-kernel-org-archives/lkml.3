Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaIKOLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:11:01 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51020 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaIKOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:11:00 -0400
Date: Thu, 11 Sep 2014 16:10:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140911141051.GK22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
 <2362560.tfnxFWQpxu@vostro.rjw.lan>
 <20140911140448.GJ22042@dhcp22.suse.cz>
 <1943936.s0DGHUisGb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1943936.s0DGHUisGb@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 11-09-14 16:26:56, Rafael J. Wysocki wrote:
> On Thursday, September 11, 2014 04:04:48 PM Michal Hocko wrote:
> > On Thu 11-09-14 16:17:56, Rafael J. Wysocki wrote:
> > [...]
> > > And I'm still wondering if the OOM killer may be made avoid killing frozen
> > > tasks.
> > 
> > This is really tricky. OOM killer aims at the biggest memory hog. We
> > shouldn't ignore it just because it hides into the fridge... So even
> > if we "fix" oom killer to ignore frozen tasks (which is inherently
> > racy btw.) then we have a potential problem of freezer abuse (e.g. in
> > container environments). So I strongly believe that the OOM killer has
> > to be able to kill a frozen tasks.
> 
> OK
> 
> Is the OOM killer the only place where TIF_MEMDIE is set?

Yes. To be precise, lowmemorykiller (staging android thingy), global OOM
killer and memcg OOM killer. Any other users would be an abuse.

-- 
Michal Hocko
SUSE Labs
