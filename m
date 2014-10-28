Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaJ1JXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:23:45 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:58683 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaJ1JXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:23:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
Date: Tue, 28 Oct 2014 10:23:37 +0100
Message-ID: <1806277.3CF96bVORX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5_zsyQ92W4iYG2Ria12TKpkFa8Au5noos1=gtq6_aPyjg@mail.gmail.com>
References: <1414139071-3818-1-git-send-email-lftan@altera.com> <alpine.DEB.2.11.1410252258570.5308@nanos> <CAFiDJ5_zsyQ92W4iYG2Ria12TKpkFa8Au5noos1=gtq6_aPyjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:3k3yyADQhQ+iIwj+fTTQum26UyUdoyCjEDG6kX7ofMl
 SgV7GKWeCVU0pQBrYa+VMBlZ0IcVjDrz/7kOLgkJIOC4Cl6QLE
 OyVEzQXVM9pgcU+tR8g1D4C36C7mU2KdyeYMaDLRk9NWmUgUN6
 h1QC/QXL9s70+KIiKXaMHHBQx1cL/HGtnecG3CgmT1IAOnVtTw
 eWyHH5a64dM2dSg9Gr7GNipYyFEyQf//GzeqrqzPKeTtN5Y262
 a/A1l50tchpUnsnm3ccTu+YGZsLScA/2u26aXRxNZLc94XrC7B
 fV7J4vakn6weVNwUR0OL7rYLiw5XP8Jz7xmnJ16zHQGKQLoYNg
 GJLg4tJ3qwz9+8YfIhhU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 October 2014 10:46:29 Ley Foon Tan wrote:
> On Sun, Oct 26, 2014 at 5:10 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 24 Oct 2014, Ley Foon Tan wrote:
> >> +#ifndef _ASM_NIOS2_TIMEX_H
> >> +#define _ASM_NIOS2_TIMEX_H
> >> +
> >> +typedef unsigned long cycles_t;
> >> +
> >> +extern cycles_t get_cycles(void);
> >> +
> >> +#define ARCH_HAS_READ_CURRENT_TIMER
> >
> > Why does NIOS need that? Does it have a hardware implementation
> > dependent clock frequency which needs to be calibrated at boot time?
> This is suggestion from Arnd to use read_current_timer instead of using
> expensive delay loop calibration during boot.

My mistake, sorry. I think the right way is to define
calibrate_delay_is_known() rather than read_current_timer(), I was
getting confused by the ARM implementation that does both.

	Arnd
