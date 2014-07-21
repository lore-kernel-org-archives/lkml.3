Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaGUCph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:45:37 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:60103 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaGUCpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:45:36 -0400
Date: Sun, 20 Jul 2014 22:45:35 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        linux-kernel@vger.kernel.org, Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        Alexey Skidanov <Alexey.Skidanov@amd.com>,
        dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [PATCH v2 16/25] amdkfd: Add module parameter of scheduling
 policy
Message-ID: <20140721024534.GM3068@gmail.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <1405603773-32688-17-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405603773-32688-17-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:29:23PM +0300, Oded Gabbay wrote:
> From: Ben Goz <ben.goz@amd.com>
> 
> This patch adds a new parameter to the amdkfd driver. This parameter enables the user to select the scheduling policy of the CP. The choices are:
> 
> * CP Scheduling with support for over-subscription
> * CP Scheduling without support for over-subscription
> * Without CP Scheduling

Is this property per process ? And again 80 chars line please.

> 
> Signed-off-by: Ben Goz <ben.goz@amd.com>
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/gpu/drm/radeon/amdkfd/kfd_module.c | 4 ++++
>  drivers/gpu/drm/radeon/amdkfd/kfd_priv.h   | 9 +++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
> index dc08f51..fe5e39d 100644
> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
> @@ -46,6 +46,10 @@ static const struct kgd2kfd_calls kgd2kfd = {
>  	.resume		= kgd2kfd_resume,
>  };
>  
> +int sched_policy = KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION;
> +module_param(sched_policy, int, S_IRUSR | S_IWUSR);
> +MODULE_PARM_DESC(sched_policy, "Kernel cmdline parameter define the kfd scheduling policy");
> +
>  bool kgd2kfd_init(unsigned interface_version,
>  		  const struct kfd2kgd_calls *f2g,
>  		  const struct kgd2kfd_calls **g2f)
> diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> index 25f23c5..8be07a1 100644
> --- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> +++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
> @@ -64,6 +64,15 @@
>  /* Macro for allocating structures */
>  #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
>  
> +/* Kernel module parameter to specify the scheduling policy */
> +extern int sched_policy;
> +
> +enum kfd_sched_policy {
> +	KFD_SCHED_POLICY_HWS = 0,
> +	KFD_SCHED_POLICY_HWS_NO_OVERSUBSCRIPTION,
> +	KFD_SCHED_POLICY_NO_HWS
> +};
> +
>  /*
>   * Large enough to hold the maximum usable pasid + 1.
>   * It must also be able to store the number of doorbells
> -- 
> 1.9.1
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
