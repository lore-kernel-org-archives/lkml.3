Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbaK3QbC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 11:31:02 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34051 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaK3Qa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 11:30:59 -0500
Message-ID: <547B463B.6060001@dev.mellanox.co.il>
Date: Sun, 30 Nov 2014 18:30:51 +0200
From: Sagi Grimberg <sagig@dev.mellanox.co.il>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>, nab@linux-iscsi.org
CC: sagig@mellanox.com, cvubrugier@yahoo.fr, joern@logfs.org,
        steven.allen@purestorage.com, arshad.hussain@calsoftinc.com,
        agrover@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iscsi-target: fix error path in iscsi_target_init_module()
References: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
In-Reply-To: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 1:00 PM, Lino Sanfilippo wrote:
> In iscsi_target_init_module() unwind transport protocol registration in case
> that iscsit_load_discovery_tpg() failed.
>
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>   drivers/target/iscsi/iscsi_target.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 73e58d2..f8ec322 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -609,6 +609,7 @@ static int __init iscsi_target_init_module(void)
>
>   	return ret;
>   r2t_out:
> +	iscsit_unregister_transport(&iscsi_target_transport);
>   	kmem_cache_destroy(lio_r2t_cache);
>   ooo_out:
>   	kmem_cache_destroy(lio_ooo_cache);
>

Yep, Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
