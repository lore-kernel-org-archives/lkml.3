Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaDWDVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:21:52 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49073 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbaDWDVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:21:50 -0400
MIME-Version: 1.0
In-Reply-To: <201404221544.33399.arnd@arndb.de>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
	<1397824031-4892-17-git-send-email-lftan@altera.com>
	<201404221544.33399.arnd@arndb.de>
Date: Wed, 23 Apr 2014 11:21:49 +0800
X-Google-Sender-Auth: dRP_BXVRD7xcj3r_JmhN60MjEcY
Message-ID: <CAFiDJ5_ZRYMrk86+HPLR_FEc5F-Yi04=Jz_EF5L40rRfOLC-9A@mail.gmail.com>
Subject: Re: [PATCH 20/28] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 9:44 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 18 April 2014, Ley Foon Tan wrote:
>> +static inline unsigned long read_timersnapshot(void)
>> +{
>> +       unsigned long count;
>> +
>> +       outw(0, timer_membase + ALTERA_TIMER_SNAPL_REG);
>> +       count =
>> +               inw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
>> +               inw(timer_membase + ALTERA_TIMER_SNAPL_REG);
>> +
>> +       return count;
>> +}
>> +
>> +static inline void write_timerperiod(unsigned long period)
>> +{
>> +       outw(period, timer_membase + ALTERA_TIMER_PERIODL_REG);
>> +       outw(period >> 16, timer_membase + ALTERA_TIMER_PERIODH_REG);
>> +}
>
> It's wrong to use 'outw' if this device is not on an PC-style ISA bus,
> which I assume it is not. Since timer_membase is an __iomem pointer,
> I'm sure you want to use writew() instead.
>
>         Arnd
Sure, will change all outw() to writew() and inw() to readw().

Ley Foon
