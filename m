Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3AaVbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:31:24 -0500
Received: from www.linutronix.de ([62.245.132.108]:59057 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3AaVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:31:21 -0500
Date: Thu, 31 Jan 2013 22:31:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
In-Reply-To: <CAKGA1bmpL-PyyMENmwgH9WNmdQ=+1oXrtDo+0OLffdvTChpLFQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1301312221400.11905@ionos>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org> <CAKGA1b=D5CNikijoOAk5xP6TC-nB_gEGtS05ncrPR68sQTMrxw@mail.gmail.com> <50FDC2DD.7090406@linaro.org>
 <CAKGA1bmtTH1N8nx79MGiMighdQROpNtpvAZXhHKT+mT3kcazBQ@mail.gmail.com> <50FDE2AE.8030608@linaro.org> <CAKGA1bkXx2qn+c6sKqXsty-aFe1r-W79uyem0O8p6JNeeq6zxQ@mail.gmail.com> <50FDEBF8.3090902@linaro.org>
 <CAKGA1bmpL-PyyMENmwgH9WNmdQ=+1oXrtDo+0OLffdvTChpLFQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Matt Sealey wrote:
> And if I wanted to I could register 8 more timers. That seems rather
> excessive, but the ability to use those extra 8 as clock outputs from
> the SoC or otherwise directly use comparators is useful to some
> people, does Linux in general really give a damn about having 8 timers
> of the same quality being available when most systems barely have two
> clocksources anyway (on x86, tsc and hpet - on ARM I guess twd and
> some SoC-specific timer). I dunno how many people might actually want

If you want to use that timers just for delivering arbitrary timer
events, then no. There is no point to have a gazillion of timer
interrupts happening w/o being coordinated. We have a pretty well
structured timer event infrastructure for precise and more timeout
oriented events, which are pretty happy to be served by a single per
cpu event device.

If you want to use the extra timers for other purposes (PWM, timer
triggered DMA transfers, etc...) then they are not in any way related
to the timers/timekeeping core.

Thanks,

	tglx


