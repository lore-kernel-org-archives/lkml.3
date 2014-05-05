Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaEEOVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:21:25 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:50140 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663AbaEEOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:21:22 -0400
Subject: Re: [PATCH] misc: genwqe: Fix format string mismatch in
 card_debugfs.c
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Masanari Iida <standby24x7@gmail.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1398309949-23305-1-git-send-email-standby24x7@gmail.com>
References: <1398309949-23305-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 05 May 2014 16:21:16 +0200
Message-ID: <1399299676.14983.4.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050514-5024-0000-0000-000009B3CDB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 24.04.2014, 12:25 +0900 schrieb Masanari Iida:
> Fix two format string mismatch in genwqe_init_debugfs()
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/misc/genwqe/card_debugfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
> index 50d2096..0a33ade 100644
> --- a/drivers/misc/genwqe/card_debugfs.c
> +++ b/drivers/misc/genwqe/card_debugfs.c
> @@ -348,7 +348,7 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
>  	char name[64];
>  	unsigned int i;
> 
> -	sprintf(card_name, "%s%u_card", GENWQE_DEVNAME, cd->card_idx);
> +	sprintf(card_name, "%s%d_card", GENWQE_DEVNAME, cd->card_idx);
> 
>  	root = debugfs_create_dir(card_name, cd->debugfs_genwqe);
>  	if (!root) {
> @@ -454,7 +454,7 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
>  	}
> 
>  	for (i = 0; i <  GENWQE_MAX_VFS; i++) {
> -		sprintf(name, "vf%d_jobtimeout_msec", i);
> +		sprintf(name, "vf%u_jobtimeout_msec", i);
> 
>  		file = debugfs_create_u32(name, 0666, root,
>  					  &cd->vf_jobtimeout_msec[i]);

Thanks for contributing the fix for our driver. I do not see that this
would ever be able to cause a problem. Or do I oversee something?
Regardless of that it appears to looks nicer.

Acked-by: Frank Haverkamp <haver@linux.vnet.ibm.com>

