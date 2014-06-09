Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbaFIPyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 11:54:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:50829 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbaFIPyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 11:54:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1003,1392192000"; 
   d="scan'208";a="525677108"
Date: Mon, 9 Jun 2014 21:05:44 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Wang, Xiaoming" <xiaoming.wang@intel.com>, jeeja.kp@intel.com,
        dhowells@redhat.com, arnd@arndb.de, tglx@linutronix.de,
        mtk.manpages@gmail.com, paulmck@linux.vnet.ibm.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, dongxing.zhang@intel.com
Subject: Re: [PATCH] ALSA: compress: Fix the mismatch size of struc between
 share lib(32bit) and kernel(64bit)
Message-ID: <20140609153544.GA25075@intel.com>
References: <1402346792.30956.17.camel@wxm-ubuntu>
 <s5hwqcqwnne.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwqcqwnne.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2014 at 09:24:53AM +0200, Takashi Iwai wrote:
> At Mon, 09 Jun 2014 16:46:32 -0400,
> Wang, Xiaoming wrote:
> > 
> > 
> > The size of struct snd_compr_avail is 0x1c in 32bit kernel,
> > while it is 0x20 in 64bit kernel 0x4 bytes added because of
> > alignment. It is OK when 32bit kernel met 32bit user space.
> > There exist stack corruption if 64bit kernel met 32bit user
> > space, because the size of struct snd_compr_avail is 0x1c
> > in 32bit user space which is smaller than it will get from
> > kernel. The extra 4 bytes can corrupt the stack, and
> > introduce unpredictable error.
> > 
> > Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> > Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> 
> This would break the existing 32bit systems, so I don't think we can
> take this approach.
> 
> Either break the 64bit systems (which aren't deployed yet much, so
> far) by adding packed attribute, or implement 32/64 bit conversion in
> compat_ioctl fop.
I think former should be safe for now. Anyway we have only 1 driver using this
in mainline so fallout shouldn't be widespread!

-- 
~Vinod
> 
> 
> thanks,
> 
> Takashi
> 
> > ---
> >  include/uapi/sound/compress_offload.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/uapi/sound/compress_offload.h b/include/uapi/sound/compress_offload.h
> > index 5759810..766b416 100644
> > --- a/include/uapi/sound/compress_offload.h
> > +++ b/include/uapi/sound/compress_offload.h
> > @@ -70,6 +70,7 @@ struct snd_compr_tstamp {
> >  	__u32 pcm_frames;
> >  	__u32 pcm_io_frames;
> >  	__u32 sampling_rate;
> > +	__u32 reserved[1];
> >  };
> >  
> >  /**
> > -- 
> > 1.7.1
> > 

-- 
