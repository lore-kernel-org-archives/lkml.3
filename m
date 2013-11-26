Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3KZG4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:56:47 -0500
Received: from smtp-66.nebula.fi ([83.145.220.66]:52414 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753476Ab3KZG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:56:44 -0500
Date: Tue, 26 Nov 2013 08:55:52 +0200
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        tomi.valkeinen@ti.com
Subject: Re: [PATCH v3] video: add OpenCores VGA/LCD framebuffer driver
Message-ID: <20131126065551.GA2838@chokladfabriken.org>
References: <1385094870-6962-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <20131124141211.GH18477@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131124141211.GH18477@ns203013.ovh.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 03:12:11PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 06:34 Fri 22 Nov     , Stefan Kristiansson wrote:
> > This adds support for the VGA/LCD core available from OpenCores:
> > http://opencores.org/project,vga_lcd
> > 
> > The driver have been tested together with both OpenRISC and
> > ARM (socfpga) processors.
> > 
> > Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
> 
> Tomi hold on this one I need check fee stuff on it
> > ---
> > Changes in v2:
> > - Add Microblaze as an example user and fix a typo in Xilinx Zynq
> > 
> > Changes in v3:
> > - Use devm_kzalloc instead of kzalloc
> > - Remove superflous MODULE #ifdef
> > ---
> >  drivers/video/Kconfig  |  17 ++
> >  drivers/video/Makefile |   1 +
> >  drivers/video/ocfb.c   | 471 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 489 insertions(+)
> >  create mode 100644 drivers/video/ocfb.c
> > 
> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index 84b685f..3b3f31e 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -979,6 +979,23 @@ config FB_PVR2
> >  	  (<file:drivers/video/pvr2fb.c>). Please see the file
> >  	  <file:Documentation/fb/pvr2fb.txt>.
> >  
> > +config FB_OPENCORES
> > +	tristate "OpenCores VGA/LCD core 2.0 framebuffer support"
> > +	depends on FB
> > +	select FB_CFB_FILLRECT
> > +	select FB_CFB_COPYAREA
> > +	select FB_CFB_IMAGEBLIT
> > +	default n
> non need
> 

Ok, let's get rid of that then.

I'll hold on to v4 for a while, since it sounded you potentially had some
additional comments coming up?

Stefan
