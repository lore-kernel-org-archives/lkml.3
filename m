Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3IRLau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 07:30:50 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63914 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860Ab3IRLat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 07:30:49 -0400
MIME-Version: 1.0
In-Reply-To: <1379442550-24860-1-git-send-email-john.stultz@linaro.org>
References: <1379442550-24860-1-git-send-email-john.stultz@linaro.org>
Date: Wed, 18 Sep 2013 13:30:49 +0200
Message-ID: <CACRpkdY-6eUWG6CWpBMi=yy2m158xwsF4h48yqZNzvBe_LW14Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] rtc: rtc-pl031: Set wakeup flag prior to registering rtcdev
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 8:29 PM, John Stultz <john.stultz@linaro.org> wrote:

> In some recent testing, I noticed the CLOCK_REALTIME_ALARM clockid
> wasn't functioning on my vexpress qemu environment. Looking into it
> I noticed the pl031 rtc driver doesn't set the wakeup flag on the
> device until after registering the device with the RTC subsystem.
>
> This causes the alarmtimer subsystem to not see the pl031 driver
> as a valid backing device, and that resuls in alarm clockids
> getting ENOTSUPP errors.
>
> Thus be sure to set the wakeup flag on the device prior to
> registering the rtcdev so the pl031 rtc driver can be used as
> the backing alarmtimer device.
>
> Let me know if you have any feedback or objections to this.
> If it looks ok, I'll queue it for 3.13. I suspect there
> may be other RTC drivers with the same problem.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Makes perfect sense. I have only tested the driver from regular
userspace using ioctl()s. Is these a simple way to test
an alarmtimer on a barebones system?

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Are you sure this should not be for -rc:s and stable?

Yours,
Linus Walleij
