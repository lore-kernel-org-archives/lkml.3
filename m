Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3EVRQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:16:48 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46503 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3EVRQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:16:47 -0400
Message-ID: <519CFD79.3050002@koalo.de>
Date: Wed, 22 May 2013 19:16:41 +0200
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Liam Girdwood <lgirdwood@gmail.com>, swarren@wwwdotorg.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ASoC: Add support for BCM2708
References: <519CD1CC.8070507@koalo.de> <20130522163942.GQ1627@sirena.org.uk>
In-Reply-To: <20130522163942.GQ1627@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2013 18:39, Mark Brown wrote:
> On Wed, May 22, 2013 at 04:10:20PM +0200, Florian Meier wrote:
> 
>> This driver adds support for digital audio (I2S)
>> for the BCM2708 SoC that is used by the
>> Raspberry Pi. External audio codecs can be
>> connected to the Raspberry Pi via P5 header.
> 
> Split this up into a patch series, for example one per CPU side driver
> and one per machine driver.  I've given the code a relatively quick run
> through here, it looks mostly sensible though DT would be nice but
> there's a few comments.
> 
>> +static inline void bcm2708_i2s_write_reg(struct bcm2708_i2s_dev *dev,
>> +					   int reg, u32 val)
>> +{
>> +	dev_dbg(dev->dev, "I2S write to register %p = %x\n",
>> +			dev->clk_base + reg, val);
>> +	__raw_writel(val, dev->i2s_base + reg);
>> +}
> 
> This all looks like you want to use regmap-mmio.........

Thank you for your comments! I will have a look at them and send a new
patch series taking them into account.
Before that I will create a patch for the DMA engine driver.

