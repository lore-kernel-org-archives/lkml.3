Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbaIKOHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:07:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58089 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752090AbaIKOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:07:26 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Date: Thu, 11 Sep 2014 16:26:56 +0200
Message-ID: <1943936.s0DGHUisGb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140911140448.GJ22042@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com> <2362560.tfnxFWQpxu@vostro.rjw.lan> <20140911140448.GJ22042@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 11, 2014 04:04:48 PM Michal Hocko wrote:
> On Thu 11-09-14 16:17:56, Rafael J. Wysocki wrote:
> [...]
> > And I'm still wondering if the OOM killer may be made avoid killing frozen
> > tasks.
> 
> This is really tricky. OOM killer aims at the biggest memory hog. We
> shouldn't ignore it just because it hides into the fridge... So even
> if we "fix" oom killer to ignore frozen tasks (which is inherently
> racy btw.) then we have a potential problem of freezer abuse (e.g. in
> container environments). So I strongly believe that the OOM killer has
> to be able to kill a frozen tasks.

OK

Is the OOM killer the only place where TIF_MEMDIE is set?

Rafael

