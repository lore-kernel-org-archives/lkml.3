Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216Ab3DHHNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:13:37 -0400
Received: from nasmtp02.atmel.com ([204.2.163.16]:5191 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934055Ab3DHHNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:13:36 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2013 03:13:35 EDT
Message-ID: <51626C87.6090800@atmel.com>
Date: Mon, 8 Apr 2013 15:06:47 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>, <akpm@linux-foundation.org>
CC: <egtvedt@samfundet.no>, <linux-kernel@vger.kernel.org>,
        <hskinnemoen@gmail.com>, <linux-mtd@lists.infradead.org>,
        <dedekind1@gmail.com>, <fengguang.wu@intel.com>
Subject: Re: [PATCH v2] avr32: fix build error in atstk1006_defconfig
References: <1364797597-22005-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1364797597-22005-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew

Could you merge it for avr32? Thanks in advance.

Best Regards,
Josh Wu

On 4/1/2013 2:26 PM, Josh Wu wrote:
> fixed the following compile error when use avr32 atstk1006_defconfig:
>    drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
>    drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'
>
> which was introduced by commit:
>    1c7b874d33b463f7150b1ab4617f000af9b327fd
>    mtd: at91: atmel_nand: add Programmable Multibit ECC controller support
> The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no
> macro "writel_relaxed" defined.
>
> This patch add writex_relaxed macro definitions.
>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Acked-by: Havard Skinnemoen <havard@skinnemoen.net>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> ---
> change since v1:
>   refined the commit message and wrap it into 80 characters.
>
>   arch/avr32/include/asm/io.h |    4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/avr32/include/asm/io.h b/arch/avr32/include/asm/io.h
> index cf60d0a..fc6483f 100644
> --- a/arch/avr32/include/asm/io.h
> +++ b/arch/avr32/include/asm/io.h
> @@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
>   #define readw_be			__raw_readw
>   #define readl_be			__raw_readl
>   
> +#define writeb_relaxed			writeb
> +#define writew_relaxed			writew
> +#define writel_relaxed			writel
> +
>   #define writeb_be			__raw_writeb
>   #define writew_be			__raw_writew
>   #define writel_be			__raw_writel

