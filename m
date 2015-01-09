Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbbAIJ0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:26:14 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:37158 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753588AbbAIJ0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:26:12 -0500
Message-ID: <54AF9E94.7080601@arm.com>
Date: Fri, 09 Jan 2015 09:25:40 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Jean-Francois Moine <moinejf@free.fr>
CC: Jyri Sarha <jsarha@ti.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <cover.1420628786.git.moinejf@free.fr> <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr> <54AE99F5.1010404@ti.com> <20150108174257.557f7ea5@armhf> <20150108200421.GC2634@sirena.org.uk>
In-Reply-To: <20150108200421.GC2634@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/15 20:04, Mark Brown wrote:
> On Thu, Jan 08, 2015 at 05:42:57PM +0100, Jean-Francois Moine wrote:
> 
>> Examples:
> 
>> - for the Cubox:
> 
>> 	audio-inputs = "i2s", "spdif";
> 
>> - for some other board with I2S on the pins 3 and 4 only:
> 
>> 	audio-inputs = "none", "none", "i2s", "i2s";
> 
>> - for a fully wired TDA9983B (no driver yet):
> 
>> 	audio-inputs = "i2s", "i2s", "i2s", "i2s", "spdif";
> 
> I think that mostly works, though I do wonder if we need a way to
> specify the ordering of the pins (if you can make pin 3 be the first two
> I2S channels for example)?  Someone might choose a strange mapping for
> board routing reasons for example.
> 

If it helps, I've collated the pin assignments given in the various TDA datasheets that I can find:

Chip>	9983B	9989		19988		19989	
Mode>	-	S/PDIF	I2S	S/PDIF	I2S	S/PDIF	I2S
Pin
AP0	WS	-	WS	-	WS	-	WS
AP1	I2S#0	S/PDIF	I2S#0	S/PDIF	I2S#0	S/PDIF	I2S#0
AP2	I2S#1	-	-	S/PDIF	I2S#1	S/PDIF	I2S#1
AP3	I2S#2	-	-	-	I2S#2*	MCLK	-
AP4	I2S#3	-	-	-	I2S#3*	-	-
AP5	MCLK	-	-	-	-	-	-
AP6	S/PDIF	-	-	-	-	-	-
AP7	AUX	-	-	-	-	-	-

WS = I2S Word Select
* Depends on package

The 9983B differs from the other devices in that the I2S and S/PDIF functionality is not multiplexed 
onto various pins.

	Andrew

