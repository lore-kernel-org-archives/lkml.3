Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3FFJHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:07:12 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62737 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3FFJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:07:08 -0400
Message-ID: <51B05135.3020006@linaro.org>
Date: Thu, 06 Jun 2013 14:37:01 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
CC: arnd@arndb.de, kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org
Subject: Re: [PATCH v2 1/3] ARM: EXYNOS: uncompress - print debug messages
 if DEBUG_LL is defined
References: <1370319552-17694-1-git-send-email-tushar.behera@linaro.org> <1370319552-17694-2-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1370319552-17694-2-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2013 09:49 AM, Tushar Behera wrote:
> Printing low-level debug messages make an assumption that the specified
> UART port has been preconfigured by the bootloader. Incorrectly
> specified UART port results in system getting stalled while printing the
> message "Uncompressing Linux... done, booting the kernel"
> This UART port number is specified through S3C_LOWLEVEL_UART_PORT. Since
> the UART port might different for different board, it is not possible to
> specify it correctly for every board that use a common defconfig file.
> 
> Calling this print subroutine only when DEBUG_LL fixes the problem. By
> disabling DEBUG_LL in default config file, we would be able to boot
> multiple boards with different default UART ports.
> 
> With this current approach, we miss the print "Uncompressing Linux...
> done, booting the kernel." when DEBUG_LL is not defined.
> 
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
> Change for v2:
> * Instead of checking value of uart_base, now check if DEBUG_LL
> is enabled. This removes the ifdef's from mach/uncompress.h
> 
> 
>  arch/arm/plat-samsung/include/plat/uncompress.h |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 

If there are no concerns, would it be possible to queue this patch [1/3]
for 3.10?

The other two patches can wait for 3.11.

-- 
Tushar Behera
