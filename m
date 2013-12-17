Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3LQQhO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:37:14 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48219 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3LQQhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:37:11 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 17 Dec 2013 08:37:03 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers: ide: Include appropriate header file in
 ide-cd_verbose.c
Message-ID: <20131217163703.GB1062@leaf>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:38:16PM +0530, Rashika Kheria wrote:
> Include appropriate header file ide-cd.h in ide-cd_verbose.c because
> function ide_cd_log_error() has its prototype declaration in ide-cd.h.
> Also, include linux/ide.h because it contains certain declarations
> necessary for including ide-cd.h.
> 
> This eliminates the following warnings in ide-cd_verbose.c:
> drivers/ide/ide-cd_verbose.c:251:6: warning: no previous prototype for ‘ide_cd_log_error’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/ide/ide-cd_verbose.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/ide/ide-cd_verbose.c b/drivers/ide/ide-cd_verbose.c
> index 6490a2d..f079ca2 100644
> --- a/drivers/ide/ide-cd_verbose.c
> +++ b/drivers/ide/ide-cd_verbose.c
> @@ -9,7 +9,9 @@
>  #include <linux/kernel.h>
>  #include <linux/blkdev.h>
>  #include <linux/cdrom.h>
> +#include <linux/ide.h>
>  #include <scsi/scsi.h>
> +#include "ide-cd.h"
>  
>  #ifndef CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS
>  void ide_cd_log_error(const char *name, struct request *failed_command,
> -- 
> 1.7.9.5
> 
