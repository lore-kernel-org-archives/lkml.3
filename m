Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab3LSAKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:10:47 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51838 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab3LSAKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:10:45 -0500
Message-ID: <1387411904.5567.9.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 2/4] drivers: target: Mark function as static in
 target_core_iblock.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, josh@joshtriplett.org
Date: Wed, 18 Dec 2013 16:11:44 -0800
In-Reply-To: <bf4be9c01bc63fc3092132de26196a5a0ed8857d.1387390091.git.rashika.kheria@gmail.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
	 <bf4be9c01bc63fc3092132de26196a5a0ed8857d.1387390091.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 23:56 +0530, Rashika Kheria wrote:
> Mark function iblock_get_write_cache() as static in target_core_iblock.c
> because it is not used outside this file.
> 
> This eliminates the following warning in target_core_iblock.c:
> drivers/target/target_core_iblock.c:766:6: warning: no previous prototype for ‘iblock_get_write_cache’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/target/target_core_iblock.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied to target-pending/for-next.

--nab

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


