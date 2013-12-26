Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LZDDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 22:03:20 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10071
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab3LZDDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 22:03:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Thu, 26 Dec 2013 10:32:07 +0800
From: Huang Shijie <b32955@freescale.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: Re: [PATCH] mtd: nand: remove unused function input parameter
Message-ID: <20131226023206.GB6752@shlinux2.ap.freescale.net>
References: <C3050A4DBA34F345975765E43127F10F25E47D50@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E47D50@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 25, 2013 at 12:40:50PM +0000, Caizhiyong wrote:
> From: Cai Zhiyong <caizhiyong@huawei.com>
> Date: Wed, 25 Dec 2013 20:11:15 +0800
> Subject: [PATCH] mtd: nand: remove unused function input parameter
> 
> The nand_get_flash_type parameter "busw" input value is not used by any
> branch, and it is updated before use it in the function, so remove it, 
> define the "busw" as an internal variable.
> 
> Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> ---
>  drivers/mtd/nand/nand_base.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 9b3bb3c..a123afa 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -3337,10 +3337,10 @@ static bool find_full_id_nand(struct mtd_info *mtd, struct nand_chip *chip,
>   */
>  static struct nand_flash_dev *nand_get_flash_type(struct mtd_info *mtd,
>  						  struct nand_chip *chip,
> -						  int busw,
>  						  int *maf_id, int *dev_id,
>  						  struct nand_flash_dev *type)
>  {
> +	int busw;
>  	int i, maf_idx;
>  	u8 id_data[8];
>  
> @@ -3497,18 +3497,16 @@ ident_done:
>  int nand_scan_ident(struct mtd_info *mtd, int maxchips,
>  		    struct nand_flash_dev *table)
>  {
> -	int i, busw, nand_maf_id, nand_dev_id;
> +	int i, nand_maf_id, nand_dev_id;
>  	struct nand_chip *chip = mtd->priv;
>  	struct nand_flash_dev *type;
>  
> -	/* Get buswidth to select the correct functions */
> -	busw = chip->options & NAND_BUSWIDTH_16;
>  	/* Set the default functions */
> -	nand_set_defaults(chip, busw);
> +	nand_set_defaults(chip, chip->options & NAND_BUSWIDTH_16);
>  
>  	/* Read the flash type */
> -	type = nand_get_flash_type(mtd, chip, busw,
> -				&nand_maf_id, &nand_dev_id, table);
> +	type = nand_get_flash_type(mtd, chip, &nand_maf_id,
> +				   &nand_dev_id, table);
I think the "busw" is to make the code more readable, since the nand_set_defaults
also needs a busw.

Let Brian judge it.

thanks
Huang Shijie


