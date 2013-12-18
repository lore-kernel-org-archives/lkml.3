Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab3LRSiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:38:51 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:50485 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348Ab3LRSit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:38:49 -0500
Date: Wed, 18 Dec 2013 10:38:46 -0800
From: josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 2/4] drivers: target: Mark function as static in
 target_core_iblock.c
Message-ID: <20131218183846.GB24229@cloud>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
 <bf4be9c01bc63fc3092132de26196a5a0ed8857d.1387390091.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bf4be9c01bc63fc3092132de26196a5a0ed8857d.1387390091.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:56:44PM +0530, Rashika Kheria wrote:
> Mark function iblock_get_write_cache() as static in target_core_iblock.c
> because it is not used outside this file.
> 
> This eliminates the following warning in target_core_iblock.c:
> drivers/target/target_core_iblock.c:766:6: warning: no previous prototype for ‘iblock_get_write_cache’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/target/target_core_iblock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index c87959f..15d9121 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -763,7 +763,7 @@ iblock_parse_cdb(struct se_cmd *cmd)
>  	return sbc_parse_cdb(cmd, &iblock_sbc_ops);
>  }
>  
> -bool iblock_get_write_cache(struct se_device *dev)
> +static bool iblock_get_write_cache(struct se_device *dev)
>  {
>  	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
>  	struct block_device *bd = ib_dev->ibd_bd;
> -- 
> 1.7.9.5
> 
