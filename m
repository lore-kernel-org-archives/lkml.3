Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3EaSU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 14:20:56 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49453 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3EaSUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 14:20:49 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, patches@linaro.org,
        kgene.kim@samsung.com, olof@lixom.net
Subject: Re: [PATCH] ARM: EXYNOS: Consolidate multiple low-level UART port definitions
References: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org>
Date: Fri, 31 May 2013 11:20:45 -0700
In-Reply-To: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org>
	(Tushar Behera's message of "Thu, 30 May 2013 10:10:27 +0530")
Message-ID: <871u8n105e.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tushar Behera <tushar.behera@linaro.org> writes:

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

Perfectly acceptable to me (and already the case on OMAP.)

> Since CONFIG_S3C_LOWLEVEL_UART_PORT is still used by other Samsung
> boards, the consolidation applies only for ARCH_EXYNOS.
>
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>

Acked-by: Kevin Hilman <khilman@linaro.org>

