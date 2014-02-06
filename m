Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbaBFQIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:08:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaBFQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:08:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] backlight: add PWM dependencies
Date: Thu, 6 Feb 2014 17:08:05 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Eric Miao'" <eric.y.miao@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pwm@vger.kernel.org
References: <1391518634-6472-1-git-send-email-linus.walleij@linaro.org> <000101cf2307$97a3c770$c6eb5650$%han@samsung.com> <000001cf230c$60ec1ca0$22c455e0$%han@samsung.com>
In-Reply-To: <000001cf230c$60ec1ca0$22c455e0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402061708.05845.arnd@arndb.de>
X-Provags-ID: V02:K0:HBbMKQwLICFSqyPN18pBjRuxQwbamgdhCZMM3VQHW8b
 h+ty0Mooaom9hlCtrZ/VTe/muVB96uMF9Z1WZkCnEl8TVig+Og
 5dUM9N8OxrqvXEd9UtGh0HDMHC90jIcoe0Hrxn3sDajN2kyujZ
 lKySKl02x8NOuwTTKVtYB11xI/JNkSYyYPB94Qzxz5VIHH6lIi
 uFHzwV52X/anAIFlxtkt2MCZGJjh2AgZ9azIAnq6PRIV5V7u/w
 PSW5fmWMh5y/uRTsdDz0t5TULcSan8+pdJd0fNWAZF5B4lSG0L
 cg5DHoTkDU+AFW92q5ZW9TfJgaOIZlPUX0zjKT5udO34aAtEVn
 YhHsGfqwMPhLSYQKitA0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 February 2014, Jingoo Han wrote:
> In the case of "CONFIG_HAVE_PWM=y && CONFIG_PWM=n", it makes
> the problem.
> 
> The HAVE_PWM symbol is only for legacy platforms that provide
> the PWM API without using the generic framework. PXA looks to
> use the generic PWM framework. Then, how about removing
> "select HAVE_PWM" from PXA as below?
> 

I think this is correct, but we may need additional patches. I notice
that INPUT_MAX8997_HAPTIC and INPUT_PWM_BEEPER have a dependency on
HAVE_PWM at the moment, so those two drivers become impossible
to select after your change.

There is also one use of HAVE_PWM outside of PXA, for ARCH_LPC32XX.
This one seems to have the same problem.

Finally, I have recently encountered a couple of drivers
(BACKLIGHT_LM3630A, BACKLIGHT_LP855X, BACKLIGHT_LP8788) that use
the PWM interfaces but are missing a 'depends on PWM'. This is
strictly speaking a different problem, but we could try to solve
it at the same time.

	Arnd
