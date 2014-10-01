Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaJANrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 09:47:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:49902 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750992AbaJANrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 09:47:49 -0400
Date: Wed, 1 Oct 2014 14:47:30 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
Message-ID: <20141001134729.GP5182@n2100.arm.linux.org.uk>
References: <cover.1411547014.git.moinejf@free.fr> <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr> <20140930192540.GL4273@sirena.org.uk> <20141001112846.0dbc80ae@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001112846.0dbc80ae@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 11:28:46AM +0200, Jean-Francois Moine wrote:
> On Tue, 30 Sep 2014 20:25:40 +0100
> Mark Brown <broonie@kernel.org> wrote:
> 
> > > +	request_module("snd-soc-hdmi-codec");
> > > +	pdev = platform_device_register_resndata(&priv->hdmi->dev,
> > > +						 "hdmi-audio-codec",
> > > +						  PLATFORM_DEVID_NONE,
> > > +						  NULL, 0,
> > > +						  &tda998x_hdmi_data,
> > > +						  sizeof tda998x_hdmi_data);  
> > 
> > Why is this request_module() needed?  If there is a good reason for it
> > we should have some documentation.
> 
> The reason is simple: as the HDMI CODEC is not declared in the DT, the
> associated module must be loaded in memory.

Module auto-loading works in non-DT environments too.  Unlike the
direction that the arm port is going, the core kernel features, such
as driver autoloading, are coded *not* to require DT (or indeed any
particular firmware.)

There are circumstances where this has been lost sight of (such as
the gpiod stuff), but as a general rule, features do not rely on DT.

Platform drivers will be auto-loaded if they have:

MODULE_ALIAS(PLATFORM_MODULE_PREFIX DRIVER_NAME);

and DRIVER_NAME matches the non-id part of the platform device name.
In the case of platform driver ID tables:

MODULE_DEVICE_TABLE(platform, id-table);

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
