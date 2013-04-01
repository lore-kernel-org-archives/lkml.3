Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3DAGNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:13:19 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:50780 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833Ab3DAGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:13:18 -0400
Message-ID: <51592560.3030609@atmel.com>
Date: Mon, 1 Apr 2013 14:12:48 +0800
From: Josh Wu <josh.wu@atmel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>
CC: <linux-kernel@vger.kernel.org>, <hskinnemoen@gmail.com>,
        <egtvedt@samfundet.no>, <linux-mtd@lists.infradead.org>,
        <dedekind1@gmail.com>, <fengguang.wu@intel.com>
Subject: Re: avr32: fix build error in atstk1006_defconfig
References: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, please drop this email. I will send out another one to include 
akpm@linux-foundation.org

Best Regards,
Josh Wu

On 4/1/2013 1:58 PM, Josh Wu wrote:
> fixed the following compile error when use avr32 atstk1006_defconfig:
>    drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
>    drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'
>
> which was introduced by commit 1c7b874d33b463 ("mtd: at91: atmel_nand: add Programmable Multibit ECC controller support").
> The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no macro "writel_relaxed" defined. This patch add writex_relaxed macro definitions.
>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Acked-by: Havard Skinnemoen <havard@skinnemoen.net>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
>
> ---
> arch/avr32/include/asm/io.h |    4 ++++
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

