Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaJAJ2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:28:43 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:23361 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbaJAJ2l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:28:41 -0400
Date: Wed, 1 Oct 2014 11:28:46 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
Message-ID: <20141001112846.0dbc80ae@armhf>
In-Reply-To: <20140930192540.GL4273@sirena.org.uk>
References: <cover.1411547014.git.moinejf@free.fr>
	<4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
	<20140930192540.GL4273@sirena.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 20:25:40 +0100
Mark Brown <broonie@kernel.org> wrote:

> > +	request_module("snd-soc-hdmi-codec");
> > +	pdev = platform_device_register_resndata(&priv->hdmi->dev,
> > +						 "hdmi-audio-codec",
> > +						  PLATFORM_DEVID_NONE,
> > +						  NULL, 0,
> > +						  &tda998x_hdmi_data,
> > +						  sizeof tda998x_hdmi_data);  
> 
> Why is this request_module() needed?  If there is a good reason for it
> we should have some documentation.

The reason is simple: as the HDMI CODEC is not declared in the DT, the
associated module must be loaded in memory.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
