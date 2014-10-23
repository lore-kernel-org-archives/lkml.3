Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaJWPYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:24:32 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:53270 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaJWPYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:24:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        wim@iguana.be, linux-watchdog@vger.kernel.org, linux@roeck-us.net,
        David Paris <david.paris@st.com>, kernel@stlinux.com
Subject: Re: [PATCH 4/4] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
Date: Thu, 23 Oct 2014 17:23:55 +0200
Message-ID: <8501493.uUGsNVQOhe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414077524-6469-5-git-send-email-lee.jones@linaro.org>
References: <1414077524-6469-1-git-send-email-lee.jones@linaro.org> <1414077524-6469-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:of/rLA58z2djUusNrEjDUdLyFzex2nW+ILmzSkp+MCd
 E2ZLI5m7zVq1bJyKq3V9zy0ZOXTTqSpmvfhN7XYJaDX2ro9LyE
 bWeHh9PvS+uqUvggXKu4ucF5ut6SAaOsGxcfZg/tQGYu1h9Ldn
 TR2v/yfweD+HsJxedxnFpxEi9hfTeJJkIoksdvuDo3wQ+zZIHi
 mR+hhfiudhr6lpx1wFfbZxh6Z9DouBEyNdRPVzjuPmCbFo0aAV
 Zxp+igumUU3aaOXh7V8IJXYIN4ls4SvH/Sa8QKTMFWbthiQzqE
 OJu6kbCqz7fZ2JzXYLkoXVuHpM+W4SEk7asZpUIrl2bzAWDD9m
 fE1ySf9/B012vKedj1Vc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 October 2014 16:18:44 Lee Jones wrote:
> +config ST_WATCHDOG
> +       tristate "STMicroelectronics LPC Watchdog"
> +       depends on ARCH_STI && OF
> +       depends on !RTC_DRV_ST_LPC
> +       select WATCHDOG_CORE
> +       help
> +        Say Y here to include Watchdog timer support for the watchdog
> +        existing in the LPC of STMicroelectronics SOCs.
> +        !!! BE CARREFUL !!!
> +        This driver shares hardware resources with RTC Alarm part of the
> +        LPC. Both LPC Watchdog driver and LPC RTC driver cannot be
> +        used together.
> +
> +        To compile this driver as a module, choose M here: the
> +        module will be called st-wdt.
> +
> 

How is this ensured by the code? Do both drivers try to bind to the
same device node? Would it make more sense to have a single driver
that registers both to the rtc and the watchdog subsystems?

	Arnd
