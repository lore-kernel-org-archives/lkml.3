Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaHRSS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 14:18:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:25617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbaHRSSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 14:18:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,887,1400050800"; 
   d="scan'208";a="560151056"
Date: Mon, 18 Aug 2014 11:18:12 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: rui.zhang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/thermal: fix calloc argument ordering
Message-ID: <20140818111812.0807809e@ultegra>
In-Reply-To: <1408354400-1656-1-git-send-email-arjun024@gmail.com>
References: <1408354400-1656-1-git-send-email-arjun024@gmail.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2014 15:03:20 +0530
Arjun Sreedharan <arjun024@gmail.com> wrote:

> @number first, @size second argument
> 
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
> ---
Acked-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

Thanks for the fix.

>  tools/thermal/tmon/sysfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
> index dfe4548..1c12536 100644
> --- a/tools/thermal/tmon/sysfs.c
> +++ b/tools/thermal/tmon/sysfs.c
> @@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
>  		return -1;
>  	}
>  
> -	ptdata.tzi = calloc(sizeof(struct tz_info),
> ptdata.max_tz_instance+1);
> +	ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct
> tz_info)); if (!ptdata.tzi) {
>  		fprintf(stderr, "Err: allocate tz_info\n");
>  		return -1;
> @@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
>  
>  	/* we still show thermal zone information if there is no
> cdev */ if (ptdata.nr_cooling_dev) {
> -		ptdata.cdi = calloc(sizeof(struct cdev_info),
> -				ptdata.max_cdev_instance + 1);
> +		ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
> +				sizeof(struct cdev_info));
>  		if (!ptdata.cdi) {
>  			free(ptdata.tzi);
>  			fprintf(stderr, "Err: allocate cdev_info\n");

[Jacob Pan]
