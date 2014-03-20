Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbaCTLYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:24:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56463 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481AbaCTLYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:24:38 -0400
Message-ID: <532ACFE6.5060703@ti.com>
Date: Thu, 20 Mar 2014 13:24:22 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 4/4] ASoC: simple-card: Add DT documentation
 for multi-DAI links
References: <cover.1394883134.git.moinejf@free.fr> <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr> <20140317164339.GR11706@sirena.org.uk> <20140318091728.1d2240ca@armhf> <53296CB7.1000909@ti.com> <5329E749.6070900@metafoo.de> <5329ECC2.7040803@ti.com> <20140319192157.GW11706@sirena.org.uk> <5329F0A1.8020801@metafoo.de>
In-Reply-To: <5329F0A1.8020801@metafoo.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 09:31 PM, Lars-Peter Clausen wrote:
> On 03/19/2014 08:21 PM, Mark Brown wrote:
>> On Wed, Mar 19, 2014 at 09:15:14PM +0200, Jyri Sarha wrote:
>>> On 03/19/2014 08:51 PM, Lars-Peter Clausen wrote:
>>
>>>> When does this make sense? Either the bitclock is inverted for all of
>>>> them or for none.
>>
>>> Definition of clock signal and it's inversion varies between chip
>>> manufacturers and sometimes it may not be possible to get all the dai
>>> drivers to work identically in this respect. Because of this in some
>>> cases
>>> there may be a need to set the inversion bit only at one end of the
>>> link.
>>
>> No, Linux has a definition of all the clock modes which applies to all
>> devices regardless of what the manufacturer documents in their
>> datasheet.
>>
>
> Yep. The clock properties are well defined for the different modes that
> can be specified in the format property. It's up to the driver to
> translate this to driver specific settings. If two drivers behave
> differently for the same mode one of them (or both) are broken.
>

After a little thinking it is clear to me too that only reason to have 
this overwrite capability is a badly written dai driver. Even with buggy 
HW it should always be possible to present the working modes in daifmt 
terms. Ok, let's remove it.

Here is an updated DT example with updated phandle for master settings:

sound {
     compatible = "simple-audio-card";
     simple-audio-card,name = "Simple Audio";
     simple-audio-card,widgets = ...
     simple-audio-card,routing = ...

     simple-audio-card,dai-link@0 {        /* I2S - codec */
         format = "i2s";
         bitclock-master = <&dai_link_master>
         frame-master = <&dai_link_master>;
         bitclock-inversion;
         simple-audio-card,cpu {
             sound-dai = <&audio1 0>;
         };
         dai_link_master: simple-audio-card,codec {
             sound-dai = <&codec 0>;
             system-clock-frequency = <12000000>;
         };
     };
...


> We should probably add the definitions for the different formats to the
> DT bindings. E.g. what is default, what is inverted polarity, etc.
>

That is a good idea.

Best regards,
Jyri
