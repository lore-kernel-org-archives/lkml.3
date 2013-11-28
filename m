Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3K1HRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 02:17:08 -0500
Received: from mga02.intel.com ([134.134.136.20]:16290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263Ab3K1HRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 02:17:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,789,1378882800"; 
   d="scan'208";a="443540988"
Date: Thu, 28 Nov 2013 11:49:43 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        ckeepax@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/1] ASoC: soc_compress: Add set_metadata
Message-ID: <20131128061943.GS8834@intel.com>
References: <20131125101648.GA1818@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131125101648.GA1818@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:16:48AM +0000, Richard Fitzgerald wrote:
> 
> Pass the set_metadata() calls through to the codec driver.
> 
> Signed-off-by: Zhao Weijia <weijia.zhao@capelabs.com>
> Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> ---
>  sound/soc/soc-compress.c |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
> index 53c9ecd..186802b 100644
> --- a/sound/soc/soc-compress.c
> +++ b/sound/soc/soc-compress.c
> @@ -318,6 +318,21 @@ static int soc_compr_pointer(struct snd_compr_stream *cstream,
>  	mutex_unlock(&rtd->pcm_mutex);
>  	return 0;
>  }
> +static int soc_compr_set_metadata(struct snd_compr_stream *cstream,
> +			struct snd_compr_metadata *metadata)
> +{
> +	struct snd_soc_pcm_runtime *rtd = cstream->private_data;
> +	struct snd_soc_platform *platform = rtd->platform;
> +
> +	mutex_lock_nested(&rtd->pcm_mutex, rtd->pcm_subclass);
> +
> +	if (platform->driver->compr_ops && platform->driver->compr_ops->set_metadata)
> +		 platform->driver->compr_ops->set_metadata(cstream, metadata);
> +
> +	mutex_unlock(&rtd->pcm_mutex);
> +	return 0;
> +}
> +
>  
>  static int soc_compr_copy(struct snd_compr_stream *cstream,
>  			  char __user *buf, size_t count)
> @@ -372,7 +387,8 @@ static struct snd_compr_ops soc_compr_ops = {
>  	.pointer	= soc_compr_pointer,
>  	.ack		= soc_compr_ack,
>  	.get_caps	= soc_compr_get_caps,
> -	.get_codec_caps = soc_compr_get_codec_caps
> +	.get_codec_caps = soc_compr_get_codec_caps,
> +	.set_metadata = soc_compr_set_metadata,
Sorry am confused by this and the patch description? The set_metadata call
exists so how is this propogating to codec? Also which tree has this been
generated against?

--
~Vinod
-- 
