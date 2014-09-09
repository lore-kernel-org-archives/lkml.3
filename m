Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaIIO6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:58:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56099 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaIIO62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:58:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BCBFf1lW1GOWN/Ur8FwV7
Date: Tue, 9 Sep 2014 07:58:19 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] omap-dma: Allow compile-testing omap1_camera driver
Message-ID: <20140909145818.GK10785@atomide.com>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <540F114D.4040509@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540F114D.4040509@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140909 07:40]:
> +linux-omap, tony
> -Balaji
> 
> On 09/09/2014 09:38 AM, Mauro Carvalho Chehab wrote:
> > We want to be able to COMPILE_TEST the omap1_camera driver.
> > It compiles fine, but it fails linkediting:
> > 
> > ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > 
> > So, add some stub functions to avoid it.

How about just remove that old driver? I doubt it works, and I'm
almost certain nobody has actually tried to use it for many
years. At least I'm not aware of any hardware supported in the
mainline kernel with it. And we're moving things to dma engine
API anyways.

Regards,

Tony


> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > diff --git a/include/linux/omap-dma.h b/include/linux/omap-dma.h
> > index 6f06f8bc612c..7c8bfdd90a33 100644
> > --- a/include/linux/omap-dma.h
> > +++ b/include/linux/omap-dma.h
> > @@ -294,43 +294,24 @@ struct omap_system_dma_plat_info {
> >  extern struct omap_system_dma_plat_info *omap_get_plat_info(void);
> >  
> >  extern void omap_set_dma_priority(int lch, int dst_port, int priority);
> > -extern int omap_request_dma(int dev_id, const char *dev_name,
> > -			void (*callback)(int lch, u16 ch_status, void *data),
> > -			void *data, int *dma_ch);
> >  extern void omap_enable_dma_irq(int ch, u16 irq_bits);
> >  extern void omap_disable_dma_irq(int ch, u16 irq_bits);
> > -extern void omap_free_dma(int ch);
> > -extern void omap_start_dma(int lch);
> > -extern void omap_stop_dma(int lch);
> > -extern void omap_set_dma_transfer_params(int lch, int data_type,
> > -					 int elem_count, int frame_count,
> > -					 int sync_mode,
> > -					 int dma_trigger, int src_or_dst_synch);
> >  extern void omap_set_dma_color_mode(int lch, enum omap_dma_color_mode mode,
> >  				    u32 color);
> >  extern void omap_set_dma_write_mode(int lch, enum omap_dma_write_mode mode);
> >  extern void omap_set_dma_channel_mode(int lch, enum omap_dma_channel_mode mode);
> >  
> > -extern void omap_set_dma_src_params(int lch, int src_port, int src_amode,
> > -				    unsigned long src_start,
> > -				    int src_ei, int src_fi);
> >  extern void omap_set_dma_src_index(int lch, int eidx, int fidx);
> >  extern void omap_set_dma_src_data_pack(int lch, int enable);
> >  extern void omap_set_dma_src_burst_mode(int lch,
> >  					enum omap_dma_burst_mode burst_mode);
> >  
> > -extern void omap_set_dma_dest_params(int lch, int dest_port, int dest_amode,
> > -				     unsigned long dest_start,
> > -				     int dst_ei, int dst_fi);
> >  extern void omap_set_dma_dest_index(int lch, int eidx, int fidx);
> >  extern void omap_set_dma_dest_data_pack(int lch, int enable);
> > -extern void omap_set_dma_dest_burst_mode(int lch,
> > -					 enum omap_dma_burst_mode burst_mode);
> >  
> >  extern void omap_set_dma_params(int lch,
> >  				struct omap_dma_channel_params *params);
> >  
> > -extern void omap_dma_link_lch(int lch_head, int lch_queue);
> >  extern void omap_dma_unlink_lch(int lch_head, int lch_queue);
> >  
> >  extern int omap_set_dma_callback(int lch,
> > @@ -356,18 +337,9 @@ extern void omap_dma_disable_irq(int lch);
> >  
> >  /* Chaining APIs */
> >  #ifndef CONFIG_ARCH_OMAP1
> > -extern int omap_request_dma_chain(int dev_id, const char *dev_name,
> > -				  void (*callback) (int lch, u16 ch_status,
> > -						    void *data),
> > -				  int *chain_id, int no_of_chans,
> > -				  int chain_mode,
> > -				  struct omap_dma_channel_params params);
> > -extern int omap_free_dma_chain(int chain_id);
> >  extern int omap_dma_chain_a_transfer(int chain_id, int src_start,
> >  				     int dest_start, int elem_count,
> >  				     int frame_count, void *callbk_data);
> > -extern int omap_start_dma_chain_transfers(int chain_id);
> > -extern int omap_stop_dma_chain_transfers(int chain_id);
> >  extern int omap_get_dma_chain_index(int chain_id, int *ei, int *fi);
> >  extern int omap_get_dma_chain_dst_pos(int chain_id);
> >  extern int omap_get_dma_chain_src_pos(int chain_id);
> > @@ -377,6 +349,87 @@ extern int omap_modify_dma_chain_params(int chain_id,
> >  extern int omap_dma_chain_status(int chain_id);
> >  #endif
> >  
> > +#ifndef CONFIG_COMPILE_TEST
> > +extern int omap_request_dma(int dev_id, const char *dev_name,
> > +			void (*callback)(int lch, u16 ch_status, void *data),
> > +			void *data, int *dma_ch);
> > +extern void omap_free_dma(int ch);
> > +extern void omap_start_dma(int lch);
> > +extern void omap_stop_dma(int lch);
> > +extern void omap_set_dma_transfer_params(int lch, int data_type,
> > +					 int elem_count, int frame_count,
> > +					 int sync_mode,
> > +					 int dma_trigger, int src_or_dst_synch);
> > +extern void omap_set_dma_src_params(int lch, int src_port, int src_amode,
> > +				    unsigned long src_start,
> > +				    int src_ei, int src_fi);
> > +extern void omap_set_dma_dest_params(int lch, int dest_port, int dest_amode,
> > +				     unsigned long dest_start,
> > +				     int dst_ei, int dst_fi);
> > +extern void omap_set_dma_dest_burst_mode(int lch,
> > +					 enum omap_dma_burst_mode burst_mode);
> > +extern void omap_dma_link_lch(int lch_head, int lch_queue);
> > +
> > +#ifndef CONFIG_ARCH_OMAP1
> > +extern int omap_request_dma_chain(int dev_id, const char *dev_name,
> > +				  void (*callback) (int lch, u16 ch_status,
> > +						    void *data),
> > +				  int *chain_id, int no_of_chans,
> > +				  int chain_mode,
> > +				  struct omap_dma_channel_params params);
> > +extern int omap_free_dma_chain(int chain_id);
> > +extern int omap_start_dma_chain_transfers(int chain_id);
> > +extern int omap_stop_dma_chain_transfers(int chain_id);
> > +#endif /* CONFIG_ARCH_OMAP1 */
> > +#else
> > +	/* Stubs for compile testing some drivers on other archs */
> > +
> > +static inline
> > +int omap_request_dma(int dev_id, const char *dev_name,
> > +		     void (*callback)(int lch, u16 ch_status, void *data),
> > +		     void *data, int *dma_ch) { return 0; }
> > +
> > +static inline void omap_free_dma(int ch) {}
> > +static inline void omap_start_dma(int lch) {}
> > +static inline void omap_stop_dma(int lch) {}
> > +
> > +static inline
> > +void omap_set_dma_transfer_params(int lch, int data_type,
> > +				  int elem_count, int frame_count,
> > +				  int sync_mode,
> > +				  int dma_trigger, int src_or_dst_synch) {}
> > +
> > +static inline
> > +void omap_set_dma_src_params(int lch, int src_port, int src_amode,
> > +			     unsigned long src_start,
> > +			     int src_ei, int src_fi) {}
> > +
> > +static inline
> > +void omap_set_dma_dest_params(int lch, int dest_port, int dest_amode,
> > +			      unsigned long dest_start,
> > +			      int dst_ei, int dst_fi) {}
> > +
> > +static inline
> > +void omap_set_dma_dest_burst_mode(int lch,
> > +				  enum omap_dma_burst_mode burst_mode) {}
> > +
> > +static inline
> > +void omap_dma_link_lch(int lch_head, int lch_queue) {}
> > +
> > +static inline
> > +int omap_request_dma_chain(int dev_id, const char *dev_name,
> > +			   void (*callback) (int lch, u16 ch_status,
> > +					     void *data),
> > +			   int *chain_id, int no_of_chans,
> > +			   int chain_mode,
> > +			   struct omap_dma_channel_params params) { return 0; }
> > +
> > +static inline int omap_free_dma_chain(int chain_id) { return 0; }
> > +static inline int omap_start_dma_chain_transfers(int chain_id) { return 0; }
> > +static inline int omap_stop_dma_chain_transfers(int chain_id) { return 0; }
> > +
> > +#endif /* CONFIG_COMPILE_TEST */
> > +
> >  #if defined(CONFIG_ARCH_OMAP1) && IS_ENABLED(CONFIG_FB_OMAP)
> >  #include <mach/lcd_dma.h>
> >  #else
> > 
> 
> 
> -- 
> Regards,
> Nishanth Menon
