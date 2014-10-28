Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaJ1NkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:40:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:57263 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaJ1NkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:40:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
Date: Tue, 28 Oct 2014 14:39:46 +0100
Message-ID: <2258102.tG8NmIz9Bk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414492984.2295.8.camel@leyfoon-vm>
References: <1414139071-3818-1-git-send-email-lftan@altera.com> <1806277.3CF96bVORX@wuerfel> <1414492984.2295.8.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/SbMqKm6SJeNmHp68QLJv9Gr4WSVaNDyLJE1RSvXwYt
 sKjkRWgfUgfLANbwvXTlHvoW6UhKnj/zB9E+kWXpjDXmebVOq+
 biTzbWEg9Ln2U8uLs94ySDr5HAK0BTGSeEJgAGxlW4s49LHRmp
 8L76H93vjXf35yjm7nbwmH6oXe6U437hK7c5DtmZAhpgu+xAYj
 W9/srOG+PYO6rvvF6FqBDkitqN6na8mLoMEFXAguP+c4CkFPCl
 dGYm6QqrkIdIKCwTOanpX/v6aRuF1OjHpR3M+0i5YAfjqRCjAl
 CayMcm1im/eTHSQMd2/3EQcqARohWhj6jW6/xaihNjXpmqusba
 J45fD6NeS/uXWBeoDgLI=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 18:43:04 Ley Foon Tan wrote:
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

Right, that works too.

> BTW, do you have further comment for other patches in this series? Only
> few minor updates since v4 patches and would like to get it into the
> v3.18 merge window if possible. What's your opinion? 

The 3.18 merge window is closed, we already have 3.18-rc2 now.

I have taken another look over the series now, I only had
a few additional comments. Please fix those along with the comments
you got from other reviewers and then ask Stephen Rothwell to
include your tree in linux-next (if it isn't already).

When 3.18 is released, you can then send a pull request to Linus.

	Arnd
