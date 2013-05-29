Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966779Ab3E2UM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:12:57 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:56850 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965519Ab3E2UMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:12:51 -0400
MIME-Version: 1.0
In-Reply-To: <20130529122707.997236928e9f87dc6ba2eaa7@linux-foundation.org>
References: <1369271045-17410-1-git-send-email-dbasehore@chromium.org>
	<20130529122707.997236928e9f87dc6ba2eaa7@linux-foundation.org>
Date: Wed, 29 May 2013 13:12:51 -0700
X-Google-Sender-Auth: Sj6MJA5nyZxGtYwtsaKh3ksQ9NE
Message-ID: <CAGAzgsrXzGHEmSo3U7Sbo9A=hDeCk2zKifszJXdmAUf5Tf66-w@mail.gmail.com>
Subject: Re: [PATCH] rtc: cmos: Fix accidentally enabling rtc channel
From: "dbasehore ." <dbasehore@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, rostedt@goodmis.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still debugging all of the issues, but allowing the cmos interrupt
handler to run before resuming caused some issues where the timer for
the alarm was not removed. This would cause other, later timers to not
be cleared, so utilities such as hwclock would time out when waiting
for the update interrupt.

There's another patch needed that I am currently testing that works
around an issue seen in coreboot (and probably other firmware) where
the RTC_CONTROL register is cleared before we get to the kernel. This
prevents the cmos interrupt handler from clearing an alarm.

On Wed, May 29, 2013 at 12:27 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 22 May 2013 18:04:05 -0700 Derek Basehore <dbasehore@chromium.org> wrote:
>
>> During resume, we call hpet_rtc_timer_init after masking an irq bit in hpet.
>> This will cause the call to hpet_disable_rtc_channel to be undone if RTC_AIE is
>> the only bit not masked.
>
> What were the user-visible runtime effects of this bug?
