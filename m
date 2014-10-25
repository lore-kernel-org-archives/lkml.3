Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbaJYDzq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 23:55:46 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61078 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaJYDzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 23:55:45 -0400
Date: Sat, 25 Oct 2014 11:55:27 +0800
From: Huang Shijie <shijie8@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mike Voytovich <mvoytovich@paypal.com>, Roy Lee <roylee@paypal.com>
Subject: Re: [PATCH v4 1/4] mtd: nand: provide detailed description for raw
 read/write page methods
Message-ID: <20141025035524.GA3579@localhost.localdomain>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413794777-32220-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413794777-32220-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:46:14AM +0200, Boris Brezillon wrote:
> read_page_raw and write_page_raw method description is not clear enough.
> It clearly specifies that ECC correction should not be involved but does
> not talk about specific layout (by layout I mean where in-band and
> out-of-band data are stored on the NAND media) used by NAND/ECC
> controllers.
> 
> Those specific layouts might impact MTD users and thus should be hidden (as
> already done in the standard NAND_ECC_HW_SYNDROME implementation).
> 
> Clearly state this constraint in the nand_ecc_ctrl struct documentation.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  include/linux/mtd/nand.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index e4d451e..b14d190 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -455,8 +455,21 @@ struct nand_hw_control {
>   *		be provided if an hardware ECC is available
>   * @calculate:	function for ECC calculation or readback from ECC hardware
>   * @correct:	function for ECC correction, matching to ECC generator (sw/hw)
> - * @read_page_raw:	function to read a raw page without ECC
> - * @write_page_raw:	function to write a raw page without ECC
> + * @read_page_raw:	function to read a raw page without ECC. This function
> + *			should hide the specific layout used by the ECC
> + *			controller and always return contiguous in-band and
> + *			out-of-band data even if they're not stored
> + *			contiguously on the NAND chip (e.g.
> + *			NAND_ECC_HW_SYNDROME interleaves in-band and
> + *			out-of-band data).
> + * @write_page_raw:	function to write a raw page without ECC. This function
> + *			should hide the specific layout used by the ECC
> + *			controller and consider the passed data as contiguous
> + *			in-band and out-of-band data. ECC controller is
> + *			responsible for doing the appropriate transformations
> + *			to adapt to its specific layout (e.g.
> + *			NAND_ECC_HW_SYNDROME interleaves in-band and
> + *			out-of-band data).
>   * @read_page:	function to read a page according to the ECC generator
>   *		requirements; returns maximum number of bitflips corrected in
>   *		any single ECC step, 0 if bitflips uncorrectable, -EIO hw error
> -- 
> 1.9.1
> 
thanks for this patch. 

hi Brian, what's your opinion about this patch?

thanks
Huang Shijie
