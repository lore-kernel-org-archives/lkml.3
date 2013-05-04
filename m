Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab3EDMgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 08:36:06 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:29131 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757990Ab3EDMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 08:36:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h1151h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Sat, 4 May 2013 20:35:56 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH, RFC 04/22] staging/drm: imx: add missing dependencies
Message-ID: <20130504123555.GA1749@S2101-09.ap.freescale.net>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
 <1367507786-505303-5-git-send-email-arnd@arndb.de>
 <20130503021650.GL3442@S2101-09.ap.freescale.net>
 <201305031721.37954.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201305031721.37954.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 05:21:37PM +0200, Arnd Bergmann wrote:
> On Friday 03 May 2013, Shawn Guo wrote:
> > On Thu, May 02, 2013 at 05:16:08PM +0200, Arnd Bergmann wrote:
> > > The imx DRM driver needs a couple of extra Kconfig dependencies
> > > to avoid random build failures:
> > > 
> > > drivers/staging/imx-drm/ipuv3-crtc.c:448:
> > >  undefined reference to `ipu_idmac_put'
> > >  drivers/staging/imx-drm/ipuv3-crtc.c:450: undefined reference to
> > >  `ipu_dmfc_put' drivers/staging/imx-drm/ipuv3-crtc.c:452:
> > >  undefined reference to `ipu_dp_put'
> > >  drivers/staging/imx-drm/ipuv3-crtc.c:454: undefined reference to
> > >  `ipu_di_put'
> > > drivers/built-in.o: In function `ipu_probe':
> > >  :(.text+0x4b4174): undefined reference to `device_reset'
> > > drivers/built-in.o: In function `imx_tve_probe':
> > >  drivers/staging/imx-drm/imx-tve.c:648: undefined reference to
> > >  `devm_regmap_init_mmio_clk'
> > > drivers/built-in.o: In function
> > >  `imx_pd_connector_get_modes':
> > 
> > >  drivers/staging/imx-drm/parallel-display.c:78: undefined
> > >  reference to `of_get_drm_display_mode'
> > 
> > There is a patch [1] from Marek fixing this one.
> > 
> > Shawn
> > 
> > [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/233449
> > 
> 
> That patch only addresses one of the four missing dependencies.
> I originally had four separate patches, but did not want to
> bother everyone with those so I combined them into one.

Yea, I agree we can address all of them in one patch.  But it seems
people agreed that there is a more correct way [1] to fix
of_get_drm_display_mode one, and that's how v2 of Marek's patch comes.

Shawn

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/232861/focus=232898

