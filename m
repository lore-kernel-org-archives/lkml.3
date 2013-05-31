Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3EaC63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 22:58:29 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35224 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3EaC6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 22:58:22 -0400
Message-ID: <51A811C8.9090509@linaro.org>
Date: Fri, 31 May 2013 08:28:16 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Patch Tracking <patches@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] ARM: EXYNOS: Consolidate multiple low-level UART port
 definitions
References: <1369888827-9427-1-git-send-email-tushar.behera@linaro.org> <CAOesGMgt=zvPM7WoHn4VcUkw28j7+HDUvU2n3hNojx7Nr5PqJQ@mail.gmail.com>
In-Reply-To: <CAOesGMgt=zvPM7WoHn4VcUkw28j7+HDUvU2n3hNojx7Nr5PqJQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 02:41 AM, Olof Johansson wrote:
> Hi,
> 
> On Wed, May 29, 2013 at 9:40 PM, Tushar Behera <tushar.behera@linaro.org> wrote:
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
>>
>> Since CONFIG_S3C_LOWLEVEL_UART_PORT is still used by other Samsung
>> boards, the consolidation applies only for ARCH_EXYNOS.
>>
>> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> 
> This looks reasonable, but you have to convert the other samsung
> platforms too -- it's not ok to ignore them.
> 

Sure thing. I will update those platforms in a subsequent patchset.

> 
> -Olof
> 


-- 
Tushar Behera
