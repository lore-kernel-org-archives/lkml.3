Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaCYM6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:58:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47203 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472AbaCYM6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:58:17 -0400
Date: Tue, 25 Mar 2014 09:57:55 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        angus.clark@st.com, kernel@stlinux.com, linux-mtd@lists.infradead.org,
        pekon@ti.com, computersforpeace@gmail.com, dwmw2@infradead.org
Subject: Re: [RFC 01/47] mtd: nand: export useful functions from core driver
Message-ID: <20140325125755.GD665@arch.cereza>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
 <1395735604-26706-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395735604-26706-2-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 25, Lee Jones wrote:
> These functions are utilised by the STM BCH NAND Controller driver.
> 
[..]
> -static int nand_suspend(struct mtd_info *mtd)
> +int nand_suspend(struct mtd_info *mtd)
>  {
>  	return nand_get_device(mtd, FL_PM_SUSPENDED);
>  }
> +EXPORT_SYMBOL(nand_suspend);
>  
>  /**
>   * nand_resume - [MTD Interface] Resume the NAND flash
>   * @mtd: MTD device structure
>   */
> -static void nand_resume(struct mtd_info *mtd)
> +void nand_resume(struct mtd_info *mtd)
>  {
>  	struct nand_chip *chip = mtd->priv;
>  
> @@ -2776,6 +2779,7 @@ static void nand_resume(struct mtd_info *mtd)
>  		pr_err("%s called for a chip which is not in suspended state\n",
>  			__func__);
>  }
> +EXPORT_SYMBOL(nand_resume);
>  

The patch that adds the PM support for the driver makes no use of these.

Can you detail why do you need to export these?
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
