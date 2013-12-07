Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3LGTRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 14:17:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64689 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3LGTRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 14:17:22 -0500
Message-ID: <1386443836.5335.38.camel@marge.simpson.net>
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
From: Mike Galbraith <bitbucket@online.de>
To: Len Brown <lenb@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Date: Sat, 07 Dec 2013 20:17:16 +0100
In-Reply-To: <CAJvTdK=9DVxY9xWCo=SSF-Rx3dFfZtkrubhtcgxxowj-rbi8LQ@mail.gmail.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	 <1386405590.5673.96.camel@marge.simpson.net>
	 <CAJvTdKkQUKFhwswK64PDNgPOMxP4s2X1GYKzWLW0G6gWxhdWtA@mail.gmail.com>
	 <CAJvTdK=9DVxY9xWCo=SSF-Rx3dFfZtkrubhtcgxxowj-rbi8LQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:jLIIrqS/Cs41SiZfyT5Hi1HbCnYjwINSQzosYIR6py9
 gje7u/itMC/dcfrqnTCEmEHEbjlvTVHct+oIkl6d/4DZwfAWAi
 KzLKhjZBxzQQIEoTjXOeZPO9R48uU9PI2q87ebLSSneQLabo53
 JkvcdgSZXGtYZIICVbW3uAaHHAvwWyuER3Hg6Ss8nRh7HzIFv1
 vfq9WQir6hD+/lpT/itaC3OaoI34AxmxdHt7iNGEJlS+j5Pjds
 Rl+lhLAEYKJl5UGiECCmBDMK7jkF63XTDuhAgJLelB/ZZ84UnJ
 A5SIhjjPiChlMH57RLcYCjMcTRvnJinzKW0GHbSO0Nc8IvZZRo
 mgxf9bmqoRb/5v/ALYX5o6Pl9EKiLo2tBG6+tVsk1Y7codTMB9
 lroOHA+WFCYxQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-07 at 11:45 -0500, Len Brown wrote: 
> >> It fixes that, except for my Q6600 box.  Too bad mwait_idle() went away,
> >> beloved old box doesn't play hints game, so it continues to flog itself.
> 
> 
> Thanks for pointing this out, Mike!
> 
> A Q6600 is a Kentsfield.  I dug one of those up.
> Indeed, the only idle capabilities it has are  HALT
> and old style MWAIT, and the latter is much more effective.
> running 3.8 it idles at 75 watts.
> running 3.8 with idle=nomwait it idles at 100 watts,
> which is what it will do with 3.9 and later due to the patch below.
> 
> commit 69fb3676df3329a7142803bb3502fa59dc0db2e3
> Author: Len Brown <len.brown@intel.com>
> Date:   Sun Feb 10 01:38:39 2013 -0500
> 
>     x86 idle: remove mwait_idle() and "idle=mwait" cmdline param
> 
> Kentsfield proves that patch was based on a fault assumption.
> Sweet box in its day, ECC memory and everything -- probably still
> a fair number of them running...
> 
> Plus, I've found another machine that depends on having an idle=mwait
> idle loop (A Sony Vaio BIOS SMM code apparently assumes we use it in
> https://bugzilla.kernel.org/show_bug.cgi?id=60770)
> 
> So it looks like I need to (also) restore the simple idle=mwait idle loop
> to make some machines happy.

Cool, box will definitely be happier.

-Mike

