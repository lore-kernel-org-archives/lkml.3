Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaLDJNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 04:13:36 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.140]:46775 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752922AbaLDJNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 04:13:34 -0500
Message-ID: <5480259D.6040106@arm.com>
Date: Thu, 04 Dec 2014 09:13:01 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: rajeev kumar <rajeevkumar.linux@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH 3/5] ASoC: dwc: Iterate over all channels
References: <547F3CA5.2010500@arm.com>	<20141203172928.GD7712@sirena.org.uk> <CAA7nrthuG_4837JArAmmEkcBqfqRRUM5rzyZ1UcH3TqhfF79bg@mail.gmail.com>
In-Reply-To: <CAA7nrthuG_4837JArAmmEkcBqfqRRUM5rzyZ1UcH3TqhfF79bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/14 06:55, rajeev kumar wrote:
> On Wed, Dec 3, 2014 at 10:59 PM, Mark Brown <broonie@kernel.org> wrote:
>> On Wed, Dec 03, 2014 at 04:39:01PM +0000, Andrew Jackson wrote:
>>
>>> +     /* Iterate over set of channels - independently controlled.
>>> +      */
>>> +     do {
>>> +             if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
>>> +                     i2s_write_reg(dev->i2s_base, TCR(ch_reg),
>>> +                                   xfer_resolution);
>>> +                     i2s_write_reg(dev->i2s_base, TFCR(ch_reg), 0x02);
>>> +                     irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
>>> +                     i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x30);
>>> +                     i2s_write_reg(dev->i2s_base, TER(ch_reg), 1);
>>> +             } else {
>>> +                     i2s_write_reg(dev->i2s_base, RCR(ch_reg),
>>> +                                   xfer_resolution);
>>> +                     i2s_write_reg(dev->i2s_base, RFCR(ch_reg), 0x07);
>>> +                     irq = i2s_read_reg(dev->i2s_base, IMR(ch_reg));
>>> +                     i2s_write_reg(dev->i2s_base, IMR(ch_reg), irq & ~0x03);
>>> +                     i2s_write_reg(dev->i2s_base, RER(ch_reg), 1);
>>> +             }
>>> +     } while (ch_reg-- > 0);
>>
>> The normal way to write an iteration would be with a for loop - why are
>> we not doing that?
>>
>> Also I see that you've not sent these as a single thread - please use
>> --thread.
> 
> designware i2s has individual register for channel support. It is like
> TCR(0), TCR(1) and so on.. So a macro is defined to capture these
> please check below #define
> 
> #define TCR(x)      (0x40 * x + 0x034)
> 
> and the same is true for capture also. So there is no need for
> iteration. Only writing to the particular register will do the work.

However params_channels returns the number of channels that the device needs to configure.  So, for example, when there are four channels two sets of channel registers need to be programmed.


	Andrew
> 
> ~Rajeev
> 

