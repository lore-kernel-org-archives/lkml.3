Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786Ab3GWNbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:31:05 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38141 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239Ab3GWNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:31:04 -0400
Message-ID: <51EE8591.7060005@gmail.com>
Date: Tue, 23 Jul 2013 15:30:57 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [alsa-devel] [PATCH v3] ARM: kirkwood: extend the kirkwood i2s
 driver for DT usage
References: <20130723104615.3696f1a9@armhf> <20130723123444.GW9858@sirena.org.uk> <51EE7E1A.3040301@gmail.com> <20130723132016.GC9858@sirena.org.uk>
In-Reply-To: <20130723132016.GC9858@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/13 15:20, Mark Brown wrote:
> On Tue, Jul 23, 2013 at 02:59:06PM +0200, Sebastian Hesselbarth wrote:
>> On 07/23/13 14:34, Mark Brown wrote:
>
>>> As others have pointed out if you need to change the clock get code
>>> there's something wrong here, DT should be handled transparently by the
>>> clock API.
>
>> IMHO the reason why of_clk_get() was/is mis-used in that way is mostly
>> compatibility with legacy platform_data based setup.
>
> I'm sorry, but this doesn't make a great deal of sense to me.  Can you
> be more specific?
 >
>> As Sascha Hauer pointed out, clocks should be distinguished by names
>> (clock-names property) instead of position and then use
>> devm_clk_get(&pdev->dev, "internal") and
>> devm_clk_get(&pdev->dev, "external") respectively.
>
>> This will possibly also require to update platform_data and legacy
>> users of kirkwood-i2s or have different setup functions for non-DT
>> and DT.
>
> Why would this be required?  The driver is already asking for multiple
> clocks...

The driver is asking for multiple *DT based* clocks. Legacy
platform_data has never been updated to reflect that. Mainly because
multiple clocks are only supported on Dove, which has no active non-DT
board in mainline.

>> Also, while ASoC API separates the audio-controller into cpu-side
>> and codec-side parts, the DT should not. IIRC and as Russell repeated
>
> You mean DAI and DMA here?  I already commented on that in my review of
> the DMA binding.

Yes.

>> again, we mentioned to merge kirkwood-i2s.c and kirkwood-dma.c into
>> a single file, didn't we?
>
> That's been discussed several times but nobody's actually done it.

Correct, that is why I repeated that request to Jean-Francois.

Sebastian

