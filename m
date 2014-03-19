Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaCSScW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 14:32:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36476 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaCSScU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 14:32:20 -0400
Message-ID: <5329E2A6.2040605@ti.com>
Date: Wed, 19 Mar 2014 20:32:06 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>, <alsa-devel@alsa-project.org>,
        <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for multi-DAI
 links
References: <cover.1394883134.git.moinejf@free.fr> <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr> <20140317164339.GR11706@sirena.org.uk> <20140318091728.1d2240ca@armhf> <53296CB7.1000909@ti.com> <20140319134625.GN11706@sirena.org.uk>
In-Reply-To: <20140319134625.GN11706@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 03:46 PM, Mark Brown wrote:
> On Wed, Mar 19, 2014 at 12:08:55PM +0200, Jyri Sarha wrote:
>
>> While we are at it we could update the bitclock-master and frame-master
>> syntax to be like this:
>
>> bitclock-master = "cpu"
>> frame-master = "codec"
>
>> With the above explicit definition all the daifmt settings could be defined
>> in link level. For backwards compatibility we could still define that
>> omitting the value equals "codec" and omitting the property equals "cpu".
>
> It seems it'd be a bit more idiomatic to do that with a phandle rather
> than with a string in order to allow extensions for things like TDM (the
> I2S to mono speaker driver use case for example).
>

You mean a like this:

sound {
     compatible = "simple-audio-card";
     simple-audio-card,name = "Simple Audio";
     simple-audio-card,widgets = ...
     simple-audio-card,routing = ...

     simple-audio-card,dai-link@0 {        /* I2S - codec */
         format = "i2s";
         bitclock-master = <&codec 0>
         frame-master = <&codec 0>;
         bitclock-inversion = <1>;
         simple-audio-card,cpu {
             sound-dai = <&audio1 0>;
             bitclock-inversion = <0>;
         };
         simple-audio-card,codec {
             sound-dai = <&codec 0>;
             system-clock-frequency = <12000000>;
         };
     };
...

Yep, that makes sense when considering tdm setups with multiple codecs 
on the same wires.

Best regards,
Jyri
