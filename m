Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbbAMTlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:41:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50557 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbAMTle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:41:34 -0500
Message-ID: <54B574CD.9020905@ti.com>
Date: Tue, 13 Jan 2015 21:41:01 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>
CC: Philipp Zabel <p.zabel@pengutronix.de>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <20150112122527.GF12302@n2100.arm.linux.org.uk> <1421071197.3081.44.camel@pengutronix.de> <20150112140456.GI12302@n2100.arm.linux.org.uk> <20150112181341.4a53ea24@armhf> <20150112175705.GN12302@n2100.arm.linux.org.uk> <1421151718.4519.24.camel@pengutronix.de> <20150113122715.GP12302@n2100.arm.linux.org.uk> <20150113165411.5469930d@armhf> <20150113160313.GR12302@n2100.arm.linux.org.uk> <20150113200252.3dbfab14@armhf> <20150113192648.GU12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150113192648.GU12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 09:26 PM, Russell King - ARM Linux wrote:
> SCLK: _~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_~_
>    WS: __~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~________________________________~
> I2S1: llmm............................llmm............................llm
> I2S2: llmm............................llmm............................llm
> I2S3: llmm............................llmm............................llm
> I2S4: llmm............................llmm............................llm
>
> So, what I'm saying is that it is_impossible_  to drive the TDA998x using
> multiple I2S streams which are not produced by the same I2S block.

This is besides the point, but it is possible that one of the multiple 
I2S blocks is the bit-clock and frame-clock master to the i2s bus and 
the others are slaves to it (banging their bits according to SCLK and WS 
of the I2S master). However, in this situation there really is only one 
i2s bus with multiple data pins.

Just my 0.02€ to this discussion.
