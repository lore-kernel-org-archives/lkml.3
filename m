Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab3LSALX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 19:11:23 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51864 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab3LSALV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 19:11:21 -0500
Message-ID: <1387411939.5567.11.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 4/4] drivers: target: Mark functions and structures as
 static in tfc_conf.c
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        josh@joshtriplett.org
Date: Wed, 18 Dec 2013 16:12:19 -0800
In-Reply-To: <94a49e2b29220b2a3fb93449a7b2c96fb6ea4667.1387390091.git.rashika.kheria@gmail.com>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
	 <94a49e2b29220b2a3fb93449a7b2c96fb6ea4667.1387390091.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 00:05 +0530, Rashika Kheria wrote:
> Mark functions ft_tpg_alloc_fabric_acl(), ft_register_configfs() and
> ft_deregister_configfs() as static in tcm_fc/tfc_conf.c because they are
> not used outside this file.
> 
> This eliminates the following warnings in tcm_fc/tfc_conf.c:
> drivers/target/tcm_fc/tfc_conf.c:270:21: warning: no previous prototype for ‘ft_tpg_alloc_fabric_acl’ [-Wmissing-prototypes]
> drivers/target/tcm_fc/tfc_conf.c:555:5: warning: no previous prototype for ‘ft_register_configfs’ [-Wmissing-prototypes]
> drivers/target/tcm_fc/tfc_conf.c:602:6: warning: no previous prototype for ‘ft_deregister_configfs’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> ---
>  drivers/target/tcm_fc/tfc_conf.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Applied to target-pending/for-next.

Thanks Rashika + Josh!

--nab

> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
> index c6932fb..e879da8 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -267,7 +267,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
>  	return found;
>  }
>  
> -struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
> +static struct se_node_acl *ft_tpg_alloc_fabric_acl(struct se_portal_group *se_tpg)
>  {
>  	struct ft_node_acl *acl;
>  
> @@ -552,7 +552,7 @@ static struct target_core_fabric_ops ft_fabric_ops = {
>  	.fabric_drop_nodeacl =		&ft_del_acl,
>  };
>  
> -int ft_register_configfs(void)
> +static int ft_register_configfs(void)
>  {
>  	struct target_fabric_configfs *fabric;
>  	int ret;
> @@ -599,7 +599,7 @@ int ft_register_configfs(void)
>  	return 0;
>  }
>  
> -void ft_deregister_configfs(void)
> +static void ft_deregister_configfs(void)
>  {
>  	if (!ft_configfs)
>  		return;


