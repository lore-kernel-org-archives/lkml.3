Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234AbaALKPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 05:15:20 -0500
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:58965 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaALKPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 05:15:15 -0500
Date: Sun, 12 Jan 2014 11:14:20 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 26/28] drm/i2c: tda998x: code optimization
Message-ID: <20140112111420.6258799a@armhf>
In-Reply-To: <20140112094533.GP15937@n2100.arm.linux.org.uk>
References: <20140109120725.0b0f3e55@armhf>
	<20140111185509.GL15937@n2100.arm.linux.org.uk>
	<20140112092201.764fb09c@armhf>
	<20140112094533.GP15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jan 2014 09:45:33 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sun, Jan 12, 2014 at 09:22:01AM +0100, Jean-Francois Moine wrote:
> > On Sat, 11 Jan 2014 18:55:09 +0000
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> > 
> > > On Thu, Jan 09, 2014 at 12:07:25PM +0100, Jean-Francois Moine wrote:
> > > > This patch reduces the number of I2C exchanges by setting many bits in
> > > > one write and removing a useless write.
> > > > 
> > > > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > > > ---
> > > >  drivers/gpu/drm/i2c/tda998x_drv.c   | 10 ++++------
> > > >  1 file changed, 4 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> > > > index 6b4f6d2..d3b3f3a 100644
> > > > --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> > > > +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> > > > @@ -751,10 +751,10 @@ tda998x_configure_audio(struct tda998x_priv *priv,
> > > >  	}
> > > >  
> > > >  	reg_write(priv, REG_AIP_CLKSEL, clksel_aip);
> > > > -	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
> > > > +	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
> > > 
> > > This patch clearly hasn't even been build tested, so I doubt there's
> > > much point reviewing this or the following patches.  From a quick scan
> > > of the following patches, this never got fixed so the following patches
> > > can't have been build tested either.
> > 
> > I don't see what can be the problem with this patch. It does not change
> > anything in the logic. About testing, it is applied to my Cubox kernel
> > for more than 4 months and everything works correctly.
> > 
> > I will move the following comment a bit upwards. Maybe the code will be
> > clearer.
> 
> You're replacing ");" with "|" here, which is not legal C.  Parenthesis
> must be balanced and statements must be terminated.

!? they are:

-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT);
+	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |
 
 	/* Enable automatic CTS generation */
-	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_ACR_MAN);
+					AIP_CNTRL_0_ACR_MAN);

gives:

	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_LAYOUT |

	/* Enable automatic CTS generation */
					AIP_CNTRL_0_ACR_MAN);


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
