Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbbAILM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:12:57 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:9138 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbbAILM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:12:56 -0500
Date: Fri, 9 Jan 2015 12:15:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI
 transmitter
Message-ID: <20150109121513.1c829fdc@armhf>
In-Reply-To: <54AFAC4C.7010209@ti.com>
References: <cover.1420628786.git.moinejf@free.fr>
	<23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>
	<54AD4C77.5000401@arm.com>
	<20150107154138.GL12302@n2100.arm.linux.org.uk>
	<20150107190241.27ebac8b@armhf>
	<54AFAC4C.7010209@ti.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015 12:24:12 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> > 	select SND_SOC_TDA998X if SND_SOC
> >
> > should work in all cases.
> >  
> 
> I think that would still fail if DRM and TDA998x is built in and SND_SOC 
> is built as modules. A request_module() call before 
> tda9998x_codec_register() should help. Or could could write:
> 
> select SND_SOC_TDA998X if (SND_SOC=DRM_I2C_NXP_TDA998X || SND_SOC=y)

request_module() is not needed because there are functions calls from
the transmitter to the codec.

With the simple "if SND_SOC", make menuconfig refuses to have TDA998x
built in and SND_SOC built as modules, as it should.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
