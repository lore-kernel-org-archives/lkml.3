Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab3ECPVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:21:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761580Ab3ECPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:21:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH, RFC 04/22] staging/drm: imx: add missing dependencies
Date: Fri, 3 May 2013 17:21:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de> <1367507786-505303-5-git-send-email-arnd@arndb.de> <20130503021650.GL3442@S2101-09.ap.freescale.net>
In-Reply-To: <20130503021650.GL3442@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305031721.37954.arnd@arndb.de>
X-Provags-ID: V02:K0:br80MY1l47p0yuabnWbknS+h4z3zuiHRWssi+c2T3TK
 Dy/4H81hVMgKU6I6NhNNisASSq+pqJjWXTWhSZOmw5cr3EOsLx
 cVQ10tZNJGToGfWfG1GIeoju5/bd3fVTRnXm47DNFcrxdHZagE
 VbMHd4t1iJwaozLaJqcEjMV62X24dN98cKJBLQfTH3hvaTtsFT
 WjzUEa3FPqh025lrwOIzgfZfyPaPA0aPCnY9Unu3H0UfXdIKbv
 uf8X+Jehx7RKpXCSREaTZ6g4f776zB2BKoMVc+S6sbQekgAUPM
 R5Dc+ljvx3yUlyDB5IpX2R/ffbvLkP9ZL2M4shTED7q7ECsVdC
 4+u18FpLk1wqluiWWjpk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 May 2013, Shawn Guo wrote:
> On Thu, May 02, 2013 at 05:16:08PM +0200, Arnd Bergmann wrote:
> > The imx DRM driver needs a couple of extra Kconfig dependencies
> > to avoid random build failures:
> > 
> > drivers/staging/imx-drm/ipuv3-crtc.c:448:
> >  undefined reference to `ipu_idmac_put'
> >  drivers/staging/imx-drm/ipuv3-crtc.c:450: undefined reference to
> >  `ipu_dmfc_put' drivers/staging/imx-drm/ipuv3-crtc.c:452:
> >  undefined reference to `ipu_dp_put'
> >  drivers/staging/imx-drm/ipuv3-crtc.c:454: undefined reference to
> >  `ipu_di_put'
> > drivers/built-in.o: In function `ipu_probe':
> >  :(.text+0x4b4174): undefined reference to `device_reset'
> > drivers/built-in.o: In function `imx_tve_probe':
> >  drivers/staging/imx-drm/imx-tve.c:648: undefined reference to
> >  `devm_regmap_init_mmio_clk'
> > drivers/built-in.o: In function
> >  `imx_pd_connector_get_modes':
> 
> >  drivers/staging/imx-drm/parallel-display.c:78: undefined
> >  reference to `of_get_drm_display_mode'
> 
> There is a patch [1] from Marek fixing this one.
> 
> Shawn
> 
> [1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/233449
> 

That patch only addresses one of the four missing dependencies.
I originally had four separate patches, but did not want to
bother everyone with those so I combined them into one.

	Arnd
