Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3E3VLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 17:11:41 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:58047 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3E3VLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 17:11:32 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org>
References: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org>
Date: Thu, 30 May 2013 14:11:31 -0700
Message-ID: <CAOesGMgt=zvPM7WoHn4VcUkw28j7+HDUvU2n3hNojx7Nr5PqJQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Consolidate multiple low-level UART port definitions
From: Olof Johansson <olof@lixom.net>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Patch Tracking <patches@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 29, 2013 at 9:40 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
> There are two definitions for low-level UART ports for Exynos platform.
> CONFIG_S3C_LOWLEVEL_UART_PORT is used for printing "Uncompressing
> Linux... done, booting the kernel." and CONFIG_S3C_UART for other
> low-level messages.
>
> The assumption for both the uart ports is that they are pre-configured
> in the bootloader. Since they are essentially the same always, it
> would be good to consolidate them to use only one macro, in this case
> 'DEBUG_S3C_UART' would be a better option.
>
> 'DEBUG_S3C_UART' is defined only if DEBUG_LL is enabled. We can safely
> disable this option when DEBUG_LL is not defined and we can boot various
> boards with different UART port settings. Only drawback of this
> approach is that when DEBUG_LL is not defined, we would be missing the
> print "Uncompressing Linux... done, booting the kernel."
>
> Since CONFIG_S3C_LOWLEVEL_UART_PORT is still used by other Samsung
> boards, the consolidation applies only for ARCH_EXYNOS.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

This looks reasonable, but you have to convert the other samsung
platforms too -- it's not ok to ignore them.


-Olof
