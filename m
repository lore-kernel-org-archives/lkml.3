Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044AbaCSKJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:09:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38218 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758982AbaCSKJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:09:06 -0400
Message-ID: <53296CB7.1000909@ti.com>
Date: Wed, 19 Mar 2014 12:08:55 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCH v3 4/4] ASoC: simple-card: Add DT documentation for multi-DAI
 links
References: <cover.1394883134.git.moinejf@free.fr>	<d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>	<20140317164339.GR11706@sirena.org.uk> <20140318091728.1d2240ca@armhf>
In-Reply-To: <20140318091728.1d2240ca@armhf>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2014 10:17 AM, Jean-Francois Moine wrote:
> On Mon, 17 Mar 2014 16:43:39 +0000
> Mark Brown <broonie@kernel.org> wrote:
>
>> On Sat, Mar 15, 2014 at 12:30:05PM +0100, Jean-Francois Moine wrote:
> 	[snip]
...

>
> I agree. I see two possible syntaxes:
>
> 1) keep the same definitions in the containers:
>
> sound {
> 	compatible = "simple-audio-card";
> 	simple-audio-card,name = "Cubox Audio";
>
> 	simple-audio-card,dai-link@0 {		/* I2S - HDMI */
> 		simple-audio-card,cpu {
> 			sound-dai = <&audio1 0>;
> 			format = "i2s";
> 		};
> 		simple-audio-card,codec {
> 			sound-dai = <&tda998x 0>;
> 		};
> 	};
>
> 	simple-audio-card,dai-link@1 {		/* S/PDIF - HDMI */
> 		simple-audio-card,cpu {
> 			sound-dai = <&audio1 1>;
> 		};
> 		simple-audio-card,codec {
> 			sound-dai = <&tda998x 1>;
> 		}
> 	};
> 	...
>

I vote for the version above. As Mark said there is need for dai 
specific properties.

While we are at it we could update the bitclock-master and frame-master 
syntax to be like this:

bitclock-master = "cpu"
frame-master = "codec"

With the above explicit definition all the daifmt settings could be 
defined in link level. For backwards compatibility we could still define 
that omitting the value equals "codec" and omitting the property equals 
"cpu".

It may sometimes be helpful to allow overwriting link level settings in 
dai level. In order to do that it should be possible to write all daifmt 
settings explicitly like this:

bitclock-inversion = <0>; /* <0> = no bitclock-inversion */

If backward compatibility is necessary we could recognize the syntax 
version from the existence dai-link node.

sound {
	compatible = "simple-audio-card";
	simple-audio-card,name = "Simple Audio";
	simple-audio-card,widgets = ...
	simple-audio-card,routing = ...

	simple-audio-card,dai-link@0 {		/* I2S - codec */
		format = "i2s";
		bitclock-master = "codec";
		frame-master = "codec";
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

I can participate in the implementation too.

Best regards,
Jyro
