Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbaJ3JEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:04:00 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:51593 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbaJ3JDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:03:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410281614390.5308@nanos>
References: <1414139071-3818-1-git-send-email-lftan@altera.com>
	<alpine.DEB.2.11.1410252258570.5308@nanos>
	<CAFiDJ5_zsyQ92W4iYG2Ria12TKpkFa8Au5noos1=gtq6_aPyjg@mail.gmail.com>
	<1806277.3CF96bVORX@wuerfel>
	<1414492984.2295.8.camel@leyfoon-vm>
	<alpine.DEB.2.11.1410281614390.5308@nanos>
Date: Thu, 30 Oct 2014 17:03:52 +0800
X-Google-Sender-Auth: o20Ehr8IoFOqT4x6mGPt5puck5Y
Message-ID: <CAFiDJ5-W9HZtzmDza_c8eh6mk-R7jFzYOncgkQF02xDCvgsx4w@mail.gmail.com>
Subject: Re: [PATCH v5 21/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:15 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 28 Oct 2014, Ley Foon Tan wrote:
>> On Sel, 2014-10-28 at 10:23 +0100, Arnd Bergmann wrote:
>> > On Tuesday 28 October 2014 10:46:29 Ley Foon Tan wrote:
>> > > On Sun, Oct 26, 2014 at 5:10 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > > > On Fri, 24 Oct 2014, Ley Foon Tan wrote:
>> > > >> +#ifndef _ASM_NIOS2_TIMEX_H
>> > > >> +#define _ASM_NIOS2_TIMEX_H
>> > > >> +
>> > > >> +typedef unsigned long cycles_t;
>> > > >> +
>> > > >> +extern cycles_t get_cycles(void);
>> > > >> +
>> > > >> +#define ARCH_HAS_READ_CURRENT_TIMER
>> > > >
>> > > > Why does NIOS need that? Does it have a hardware implementation
>> > > > dependent clock frequency which needs to be calibrated at boot time?
>> > > This is suggestion from Arnd to use read_current_timer instead of using
>> > > expensive delay loop calibration during boot.
>> >
>> > My mistake, sorry. I think the right way is to define
>> > calibrate_delay_is_known() rather than read_current_timer(), I was
>> > getting confused by the ARM implementation that does both.
>> Hi Arnd,
>> No problem, I can change that. But, seem that we don't need to have
>> calibrate_delay_is_known() as well. We can just set "lpj_fine" variable,
>> arm64 uses this.
>
> Please do so and resend the result so I can have another look and add
> my reviewed tag then.
Sure, I will send another revision.

Thanks for reviewing.

Regards
Ley Foon
