Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab3KTFi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:38:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3KTFi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:38:56 -0500
Date: Tue, 19 Nov 2013 21:39:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, devel@driverdev.osuosl.org,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH] staging: imx-drm: Fix modular build of DRM_IMX_IPUV3
Message-ID: <20131120053919.GB367@kroah.com>
References: <20131112171544.GR20328@hansolo.jdub.homelinux.org>
 <20131118090309.GU24559@pengutronix.de>
 <20131120015659.GF1908@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120015659.GF1908@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 08:56:59PM -0500, Josh Boyer wrote:
> On Mon, Nov 18, 2013 at 10:03:10AM +0100, Sascha Hauer wrote:
> > On Tue, Nov 12, 2013 at 12:15:45PM -0500, Josh Boyer wrote:
> > > commit b8d181e408af (staging: drm/imx: add drm plane support) added a file
> > > to the make target for DRM_IMX_IPUV3 but didn't adjust the objs required
> > > to actually build that as a module.  Kbuild got confused and this lead to
> > > link errors like:
> > > 
> > > ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > > ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
> > > 
> > > Additionally, it added a call to imx_drm_crtc_id which also fails with a
> > > link error as above.  To fix this, we adjust the make target with the proper
> > > objs, which will change the name of the resulting .ko.  We also add an
> > > EXPORT_SYMBOL_GPL for imx_drm_crtc_id.
> > > 
> > > Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> > 
> > 
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > Sascha
> 
> Thanks.  So who picks this fix up?  Greg, is that you?

Yes, I will once 3.13-rc1 is out.

greg k-h
