Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbaHFUS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:18:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:33679 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaHFUS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:18:26 -0400
Date: Wed, 6 Aug 2014 23:18:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Srikrishan Malik <srikrishanmalik@gmail.com>
Cc: greg@kroah.com, andreas.dilger@intel.com, oleg.drokin@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] staging: lustre: Fix misplaced opening brace
 warnings
Message-ID: <20140806201813.GE4856@mwanda>
References: <1407345182-709-1-git-send-email-srikrishanmalik@gmail.com>
 <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407345182-709-10-git-send-email-srikrishanmalik@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 10:43:00PM +0530, Srikrishan Malik wrote:
> diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> index c03d77c9c5b8..09209171b50c 100644
> --- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> +++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
> @@ -785,12 +785,12 @@ int mdc_enqueue(struct obd_export *exp, struct ldlm_enqueue_info *einfo,
>  	__u64		  flags, saved_flags = extra_lock_flags;
>  	int		    rc;
>  	struct ldlm_res_id res_id;
> -	static const ldlm_policy_data_t lookup_policy =
> -			    { .l_inodebits = { MDS_INODELOCK_LOOKUP } };
> -	static const ldlm_policy_data_t update_policy =
> -			    { .l_inodebits = { MDS_INODELOCK_UPDATE } };
> -	static const ldlm_policy_data_t layout_policy =
> -			    { .l_inodebits = { MDS_INODELOCK_LAYOUT } };
> +	static const ldlm_policy_data_t lookup_policy = {
> +				.l_inodebits = { MDS_INODELOCK_LOOKUP } };
> +	static const ldlm_policy_data_t update_policy = {
> +				.l_inodebits = { MDS_INODELOCK_UPDATE } };
> +	static const ldlm_policy_data_t layout_policy = {
> +				.l_inodebits = { MDS_INODELOCK_LAYOUT } };
>  	static const ldlm_policy_data_t getxattr_policy = {
>  			      .l_inodebits = { MDS_INODELOCK_XATTR } };
>  	ldlm_policy_data_t const *policy = &lookup_policy;

That looks silly before and after.  Everything is indented in a funny
way.

regards,
dan carpenter

