Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaJ1PPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 11:15:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:49263 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaJ1PPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 11:15:53 -0400
Date: Tue, 28 Oct 2014 16:15:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ley Foon Tan <lftan@altera.com>
cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
In-Reply-To: <1414492984.2295.8.camel@leyfoon-vm>
Message-ID: <alpine.DEB.2.11.1410281614390.5308@nanos>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>  <alpine.DEB.2.11.1410252258570.5308@nanos>  <CAFiDJ5_zsyQ92W4iYG2Ria12TKpkFa8Au5noos1=gtq6_aPyjg@mail.gmail.com>  <1806277.3CF96bVORX@wuerfel> <1414492984.2295.8.camel@leyfoon-vm>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, Ley Foon Tan wrote:
> On Sel, 2014-10-28 at 10:23 +0100, Arnd Bergmann wrote:
> > On Tuesday 28 October 2014 10:46:29 Ley Foon Tan wrote:
> > > On Sun, Oct 26, 2014 at 5:10 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > > On Fri, 24 Oct 2014, Ley Foon Tan wrote:
> > > >> +#ifndef _ASM_NIOS2_TIMEX_H
> > > >> +#define _ASM_NIOS2_TIMEX_H
> > > >> +
> > > >> +typedef unsigned long cycles_t;
> > > >> +
> > > >> +extern cycles_t get_cycles(void);
> > > >> +
> > > >> +#define ARCH_HAS_READ_CURRENT_TIMER
> > > >
> > > > Why does NIOS need that? Does it have a hardware implementation
> > > > dependent clock frequency which needs to be calibrated at boot time?
> > > This is suggestion from Arnd to use read_current_timer instead of using
> > > expensive delay loop calibration during boot.
> > 
> > My mistake, sorry. I think the right way is to define
> > calibrate_delay_is_known() rather than read_current_timer(), I was
> > getting confused by the ARM implementation that does both.
> Hi Arnd,
> No problem, I can change that. But, seem that we don't need to have
> calibrate_delay_is_known() as well. We can just set "lpj_fine" variable,
> arm64 uses this.

Please do so and resend the result so I can have another look and add
my reviewed tag then.

Thanks,

	tglx
