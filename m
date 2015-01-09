Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbbAIN7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:59:03 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:39876 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754843AbbAIN7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:59:01 -0500
Message-ID: <54AFDE8D.3000504@arm.com>
Date: Fri, 09 Jan 2015 13:58:37 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jean-Francois Moine <moinejf@free.fr>
CC: Jyri Sarha <jsarha@ti.com>, Mark Brown <broonie@kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 1/4] drm/i2c: tda998x: Add DT support for audio
References: <cover.1420628786.git.moinejf@free.fr> <0084acea5a3475a77531d6a77483f36d3469111a.1420628786.git.moinejf@free.fr> <54AE99F5.1010404@ti.com> <20150108174257.557f7ea5@armhf> <54AFA9B0.6040405@ti.com> <20150109123036.4bc4bbf6@armhf> <20150109114529.GH12302@n2100.arm.linux.org.uk> <20150109135401.5b270d46@armhf> <20150109130725.GN12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150109130725.GN12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/15 13:07, Russell King - ARM Linux wrote:
> On Fri, Jan 09, 2015 at 01:54:01PM +0100, Jean-Francois Moine wrote:
>> On Fri, 9 Jan 2015 11:45:29 +0000
>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>> I think we need to understand exactly how the 998x map I2S inputs to the
>>> HDMI channels to avoid making a mistake with the binding; remember, the
>>> binding isn't something that can be easily "bug fixed" at a later date
>>> as anything we come up with now has to be supported long term by the
>>> kernel.
>>
>> The DT describes the hardware configuration.
> 
> You're missing my point.
> 
> How does the driver know which of the I2S pins to enable in I2S mode?

[snip]

> My question is: how do we know which I2S inputs to enable, or are
> you suggesting that all I2S inputs should be enabled if operating in
> I2S mode irrespective of whether they may be active?
> 

Isn't it the case that for I2S:

* Word Select (WS) is always required to disambiguate left/right. So WS need
  not be specified in any device tree configuration.

* The audio inputs depend on a particular board but at least one is 
  required.  Fortunately, the TDA998x devices have all the same pin/input
  numbering so they /could/ be described as i2s0, i2s1, i2s2 and i2s3 as 
  per J-F's earlier email.  But tt isn't clear from my reading of the 
  TDA19988 datasheet (for example) whether one can skip channels (so
  does channel 0 always have to be present?).  If the channels must
  be enabled from 0 then one could simply specify the number of inputs.
  (The datasheets that I have don't indicate whether there's any 
  channel remapping performed internally by the TDA998x).

* What the driver does need to take account of is the number of inputs
  that are active so that the sound CODEC can be properly configured.


	Andrew


