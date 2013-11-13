Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab3KMOCU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:02:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:53531 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KMOCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:02:18 -0500
Date: Wed, 13 Nov 2013 15:02:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Whitehead <tedheadster@gmail.com>
cc: john.stultz@linaro.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
In-Reply-To: <20131113113927.GA13875@mwhitehe.csb>
Message-ID: <alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
References: <20131113113927.GA13875@mwhitehe.csb>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Nov 2013, Matthew Whitehead wrote:

> I was testing the 3.12 kernel on some _old_ hardware and I uncovered a bug.
> It arises when nohz=on and goes away with nohz=off. On a crusty dual Pentium-1 
> system that is completely idle, the sar utility reports 0% idle time on cpu0 
> and 100% idle on cpu1. Cpu0 _should_ also be reporting 100% idle, but instead
> it reports around 75% system time and 25% user time.
> 
> The problem was diagnosed by Steve Rostedt with help from John
> Stultz. The old system declares the dual TSCs unstable, and backs
> down to a timesource of refined-jiffies. Apparently refined-jiffies
> and jiffies are not a usable timesourcefor nohz, but we don't check
> for that case because most modern systems have several reliable
> hardware timesources.

Wrong.
 
> John suggested that we turn off nohz unless a usable hardware timesource is
> present.

nohz already depends on two things:

      1) A reliable clocksource which is valid for highres/nohz

      2) A per cpu clockevent device which supports one shot mode.

and those are evaluated at runtime before we switch into NOHZ mode.

And neither jiffies nor refined-jiffies qualify as valid clocksource.

So there is something else wrong.

Thanks,

	tglx
   
