Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaCVWBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 18:01:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:56154 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaCVWBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 18:01:49 -0400
Date: Sat, 22 Mar 2014 23:01:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        joseph.salisbury@canonical.com, JBottomley@parallels.com,
        Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com,
        rientjes@google.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, tj@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@lists.ubuntu.com,
        linux-scsi@vger.kernel.org, thenzl@redhat.com
Subject: Re: please fix FUSION (Was:
 [v3.13][v3.14][Regression]kthread:makekthread_create()killable)
In-Reply-To: <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403222242450.18573@ionos.tec.linutronix.de>
References: <20140319182910.GA14511@redhat.com> <20140319194232.GA6207@redhat.com> <532B1B67.5050104@canonical.com> <20140320192307.GA11883@redhat.com> <20140321183443.GA3891@redhat.com> <201403221525.FJC69759.MSLOtHOJOVFFQF@I-love.SAKURA.ne.jp>
 <20140322192511.GA14811@redhat.com> <alpine.DEB.2.02.1403222201300.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Thomas Gleixner wrote:
> On Sat, 22 Mar 2014, Oleg Nesterov wrote:
> > Personally I dislike this change. In fact I think it is ugly. But this
> > is only my opinion.
> 
> It's not only ugly, it's activly wrong. It's as wrong as 786235ee
> itself. And 786235ee needs to be reverted and the revert must go into
> 3.13.stable as well. I'll send a revert request in separate mail.

Sorry. I misread the combo of both patches. 786235ee is correct. We
definitely don't want to revert it. 

But I still think, that changing this to butt ugly heuristics with an
arbitrary chosen timeout is not the proper solution to "fix" a driver
problem and to work around a systemd policy which mandates that
modprobe must return in 30 seconds.

But then systemd/udev mutters:

   "You migh be able to work around the timeout with udev rules and
    OPTIONS+="event_timeout=120", but that code was maybe never used
    or tested, so it might not work correctly." [1]

AFAICT from the ubuntu bug system [2] nobody bothered even to try that.

And if the udev/systemd event_timeout option is broken it's way better
to fix that one instead of hacking random heuristics into the kernel.

Thanks,

	tglx

[1] http://lists.freedesktop.org/archives/systemd-devel/2014-March/018007.html
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1276705
