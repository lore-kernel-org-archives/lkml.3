Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaHaQ0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 12:26:14 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:56604 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230AbaHaQ0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 12:26:10 -0400
Date: Sun, 31 Aug 2014 18:27:25 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jyri Sarha <jsarha@ti.com>, Nicolin Chen <nicoleotsuka@gmail.com>
Subject: Re: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Message-ID: <20140831182725.3135db4f@armhf>
In-Reply-To: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
References: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014 14:46:37 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> This patch merge single DAI link and muti-DAI links code together,
> and simply the simple-card driver code.
> 
> And also do some other improvement:
> 
> Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
> mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
> frame clock is as master/slave.
> 
> So these same DAI formats should be informed to CPU and CODE DAIs at
> the same time. For the Codec driver will set the bit clock and frame
> clock as the DAI formats said, but for the CPU driver, if the the
> bit clock or frame clock is as Codec master, so it should be set CPU
> DAI device as bit clock or frame clock as slave, and vice versa.
> 
> The old code will cause confusion, and we should be clear that the
> letter 'C' here mean to Codec.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: Jyri Sarha <jsarha@ti.com>
> Cc: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
> 
> Hi,
> 
> This patch will break the old DT, so i just send one RFC version, and
> will add the old DT patches in next version if this patch can work
> well.
> 
> Any comments and advices are welcome.

Hi Xiubo,

My DT is

	sound {
		compatible = "simple-audio-card";
		simple-audio-card,name = "Cubox Audio";

		simple-audio-card,dai-link@0 {		/* I2S - HDMI */
			format = "i2s";
			cpu {
				sound-dai = <&audio1 0>;
			};
			codec {
				sound-dai = <&hdmi 0>;
			};
		};
	...

I was getting 0x1001 as the format (codec clk & FRM master and i2s').

With your patch, I get 0x4000 (clk master & frame slave and no format).

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
