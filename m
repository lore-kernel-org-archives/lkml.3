Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaEWHOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:14:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:64044 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbaEWHOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:14:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,892,1392192000"; 
   d="scan'208";a="536463264"
Message-ID: <537EF534.5060908@linux.intel.com>
Date: Fri, 23 May 2014 10:13:56 +0300
From: Jarkko Nikula <jarkko.nikula@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Wenkai Du <wenkai.du@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Christian Engelmayer <cengelma@gmx.at>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Intel: avoid format string leak to thread name
References: <20140522184355.GA8301@www.outflux.net>
In-Reply-To: <20140522184355.GA8301@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 09:43 PM, Kees Cook wrote:
> This makes sure a format string can never get processed into the worker
> thread name from the device name.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>   sound/soc/intel/sst-baytrail-ipc.c |    2 +-
>   sound/soc/intel/sst-haswell-ipc.c  |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/sound/soc/intel/sst-baytrail-ipc.c b/sound/soc/intel/sst-baytrail-ipc.c
> index 0d31dbbf4806..1b25bf168beb 100644
> --- a/sound/soc/intel/sst-baytrail-ipc.c
> +++ b/sound/soc/intel/sst-baytrail-ipc.c
> @@ -809,7 +809,7 @@ int sst_byt_dsp_init(struct device *dev, struct sst_pdata *pdata)
>   	/* start the IPC message thread */
>   	init_kthread_worker(&byt->kworker);
>   	byt->tx_thread = kthread_run(kthread_worker_fn,
> -				     &byt->kworker,
> +				     &byt->kworker, "%s",
>   				     dev_name(byt->dev));
>   	if (IS_ERR(byt->tx_thread)) {
>   		err = PTR_ERR(byt->tx_thread);
> diff --git a/sound/soc/intel/sst-haswell-ipc.c b/sound/soc/intel/sst-haswell-ipc.c
> index e7996b39a484..a8fd60c67341 100644
> --- a/sound/soc/intel/sst-haswell-ipc.c
> +++ b/sound/soc/intel/sst-haswell-ipc.c
> @@ -1735,7 +1735,7 @@ int sst_hsw_dsp_init(struct device *dev, struct sst_pdata *pdata)
>   	/* start the IPC message thread */
>   	init_kthread_worker(&hsw->kworker);
>   	hsw->tx_thread = kthread_run(kthread_worker_fn,
> -					   &hsw->kworker,
> +					   &hsw->kworker, "%s",
>   					   dev_name(hsw->dev));
>   	if (IS_ERR(hsw->tx_thread)) {
>   		ret = PTR_ERR(hsw->tx_thread);
This is not very fatal as name comes from sound/soc/intel/sst-acpi.c so 
only developer can hit this but to be on safe side:

Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
