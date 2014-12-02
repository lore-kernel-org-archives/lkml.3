Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905AbaLBGMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 01:12:18 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56849 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaLBGMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 01:12:17 -0500
Message-ID: <1417500716.11477.1.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] iscsi-target: fix error path in
 iscsi_target_init_module()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: sagig@mellanox.com, cvubrugier@yahoo.fr, joern@logfs.org,
        steven.allen@purestorage.com, arshad.hussain@calsoftinc.com,
        agrover@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Dec 2014 22:11:56 -0800
In-Reply-To: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-11-30 at 12:00 +0100, Lino Sanfilippo wrote:
> In iscsi_target_init_module() unwind transport protocol registration in case
> that iscsit_load_discovery_tpg() failed.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  drivers/target/iscsi/iscsi_target.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 73e58d2..f8ec322 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -609,6 +609,7 @@ static int __init iscsi_target_init_module(void)
>  
>  	return ret;
>  r2t_out:
> +	iscsit_unregister_transport(&iscsi_target_transport);
>  	kmem_cache_destroy(lio_r2t_cache);
>  ooo_out:
>  	kmem_cache_destroy(lio_ooo_cache);

Nice catch.  Applied to target-pending/for-next.

Thanks Lino!

--nab

