Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaA3Nv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 08:51:57 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15137 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbaA3Nvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 08:51:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 30 Jan 2014 05:50:28 -0800
Message-ID: <52EA58F4.8070601@nvidia.com>
Date: Thu, 30 Jan 2014 15:51:48 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Erik Faye-Lund <kusmabite@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu: host1x: do not check previously handled gathers
References: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
In-Reply-To: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2014 22:03, Erik Faye-Lund wrote:
> When patching gathers, we don't need to check against
> gathers with lower indices than the current one, as
> they are guaranteed to already have been handled.
> 
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
> 
> Here's a trivial optimization I have been running with for a while.
> 
>  drivers/gpu/host1x/job.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> index de5ec33..e965805 100644
> --- a/drivers/gpu/host1x/job.c
> +++ b/drivers/gpu/host1x/job.c
> @@ -534,7 +534,7 @@ int host1x_job_pin(struct host1x_job *job, struct device *dev)
>  
>  		g->base = job->gather_addr_phys[i];
>  
> -		for (j = 0; j < job->num_gathers; j++)
> +		for (j = i + 1; j < job->num_gathers; j++)
>  			if (job->gathers[j].bo == g->bo)
>  				job->gathers[j].handled = true;
>  

Hi,

Thanks. This looks good logically, and I ran some tests that agree.

Acked-By: Terje Bergstrom <tbergstrom@nvidia.com>

Terje
