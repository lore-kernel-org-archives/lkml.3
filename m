Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3JHK4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:56:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13380 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3JHK4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:56:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Oct 2013 03:56:13 -0700
Message-ID: <5253E52C.5090805@nvidia.com>
Date: Tue, 8 Oct 2013 13:57:48 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Erik Faye-Lund <kusmabite@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpu: host1x: check relocs after all gathers are consumed
References: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
In-Reply-To: <1380917913-20482-1-git-send-email-kusmabite@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.10.2013 23:18, Erik Faye-Lund wrote:
> The num_relocs count are passed to the kernel per job, not per gather.
> 
> For multi-gather jobs, we would previously fail if there were relocs in
> other gathers aside from the first one.
> 
> Fix this by simply moving the check until all gathers have been
> consumed.
> 
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
>  drivers/gpu/host1x/job.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
> index c4e1050..c9ddff8 100644
> --- a/drivers/gpu/host1x/job.c
> +++ b/drivers/gpu/host1x/job.c
> @@ -436,10 +436,6 @@ static int validate(struct host1x_firewall *fw, struct host1x_job_gather *g)
>  		}
>  	}
>  
> -	/* No relocs should remain at this point */
> -	if (fw->num_relocs)
> -		err = -EINVAL;
> -
>  out:
>  	return err;
>  }
> @@ -493,6 +489,10 @@ static inline int copy_gathers(struct host1x_job *job, struct device *dev)
>  		offset += g->words * sizeof(u32);
>  	}
>  
> +	/* No relocs should remain at this point */
> +	if (fw.num_relocs)
> +		return -EINVAL;
> +
>  	return 0;
>  }

Good catch.

Acked-By: Terje Bergstrom <tbergstrom@nvidia.com>

Terje

