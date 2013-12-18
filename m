Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab3LRSht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:37:49 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39816 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3LRShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:37:47 -0500
Date: Wed, 18 Dec 2013 10:37:41 -0800
From: josh@joshtriplett.org
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers: target: Move prototype declaration of
 function to header file target_core_pr.h
Message-ID: <20131218183741.GA24229@cloud>
References: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1a63603bc5ff05147c419a301d59b135cd0c8406.1387390091.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:54:32PM +0530, Rashika Kheria wrote:
> Move prototype declaration of function
> spc_parse_naa_6h_vendor_specific() from target_core_xcopy.c to header
> file target_core_pr.h because it is used by more than one file.
> 
> This eliminates the following warning in target_core_spc.c:
> drivers/target/target_core_spc.c:138:6: warning: no previous prototype for ‘spc_parse_naa_6h_vendor_specific’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/target/target_core_pr.h    |    5 +++++
>  drivers/target/target_core_xcopy.c |    4 ----
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
> index ed75cdd..2ee2936 100644
> --- a/drivers/target/target_core_pr.h
> +++ b/drivers/target/target_core_pr.h
> @@ -43,6 +43,11 @@
>  #define PR_APTPL_MAX_IPORT_LEN			256
>  #define PR_APTPL_MAX_TPORT_LEN			256
>  
> +/*
> + *  Function defined in target_core_spc.c
> + */
> +void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned char *);
> +
>  extern struct kmem_cache *t10_pr_reg_cache;
>  
>  extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index 6b88a99..669c536 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -40,10 +40,6 @@
>  
>  static struct workqueue_struct *xcopy_wq = NULL;
>  /*
> - * From target_core_spc.c
> - */
> -extern void spc_parse_naa_6h_vendor_specific(struct se_device *, unsigned char *);
> -/*
>   * From target_core_device.c
>   */
>  extern struct mutex g_device_mutex;
> -- 
> 1.7.9.5
> 
