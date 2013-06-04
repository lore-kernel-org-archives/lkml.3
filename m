Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3FDJnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:43:14 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:47601 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3FDJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:43:12 -0400
Message-ID: <51ADB6A9.8030006@linaro.org>
Date: Tue, 04 Jun 2013 15:13:05 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de, patches@linaro.org,
        kgene.kim@samsung.com, olof@lixom.net
Subject: Re: [PATCH] ARM: EXYNOS: Consolidate multiple low-level UART port
 definitions
References: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org> <871u8n105e.fsf@linaro.org>
In-Reply-To: <871u8n105e.fsf@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 11:50 PM, Kevin Hilman wrote:
> Tushar Behera <tushar.behera@linaro.org> writes:
> 
>> There are two definitions for low-level UART ports for Exynos platform.
>> CONFIG_S3C_LOWLEVEL_UART_PORT is used for printing "Uncompressing
>> Linux... done, booting the kernel." and CONFIG_S3C_UART for other
>> low-level messages.
>>
>> The assumption for both the uart ports is that they are pre-configured
>> in the bootloader. Since they are essentially the same always, it
>> would be good to consolidate them to use only one macro, in this case
>> 'DEBUG_S3C_UART' would be a better option.
>>
>> 'DEBUG_S3C_UART' is defined only if DEBUG_LL is enabled. We can safely
>> disable this option when DEBUG_LL is not defined and we can boot various
>> boards with different UART port settings. Only drawback of this
>> approach is that when DEBUG_LL is not defined, we would be missing the
>> print "Uncompressing Linux... done, booting the kernel."
> 
> Perfectly acceptable to me (and already the case on OMAP.)
> 
>> Since CONFIG_S3C_LOWLEVEL_UART_PORT is still used by other Samsung
>> boards, the consolidation applies only for ARCH_EXYNOS.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>
> 

Thanks Kevin.

I have an updated version of this patch updated for all of Samsung
platforms.[1]

[1] http://www.gossamer-threads.com/lists/linux/kernel/1723429

-- 
Tushar Behera
