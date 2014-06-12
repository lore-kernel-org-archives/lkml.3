Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139AbaFLJo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:44:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:63165 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbaFLJo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:44:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,464,1400050800"; 
   d="scan'208";a="546758593"
Date: Thu, 12 Jun 2014 14:55:13 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: "Wang, Xiaoming" <xiaoming.wang@intel.com>
Cc: tiwai@suse.de, jeeja.kp@intel.com, dhowells@redhat.com, arnd@arndb.de,
        tglx@linutronix.de, mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org,
        dongxing.zhang@intel.com
Subject: Re: [PATCH] ALSA: compress: Cancel the optimization of compiler
 and fix the size of struct for all platform.
Message-ID: <20140612092513.GA22053@intel.com>
References: <1402613227.8326.13.camel@wxm-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402613227.8326.13.camel@wxm-ubuntu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 06:47:07PM -0400, Wang, Xiaoming wrote:
> Cancel the optimization of compiler for struct snd_compr_avail
> which size will be 0x1c in 32bit kernel while 0x20 in 64bit
> kernel under the optimizer. That will make compaction between
> 32bit and 64bit. So add packed to fix the size of struct
> snd_compr_avail to 0x1c for all platform.
> 
> Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>

Acked-by: Vinod Koul <vinod.koul@intel.com>

Takashi, can we cc stable on this, would help fixing in older kernels too

Thanks
-- 
~Vinod
> ---
>  include/uapi/sound/compress_offload.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
> index 5759810..21eed48 100644
> --- a/include/uapi/sound/compress_offload.h
> +++ b/include/uapi/sound/compress_offload.h
> @@ -80,7 +80,7 @@ struct snd_compr_tstamp {
>  struct snd_compr_avail {
>  	__u64 avail;
>  	struct snd_compr_tstamp tstamp;
> -};
> +} __attribute__((packed));
>  
>  enum snd_compr_direction {
>  	SND_COMPRESS_PLAYBACK = 0,
> -- 
> 1.7.1
> 

-- 
