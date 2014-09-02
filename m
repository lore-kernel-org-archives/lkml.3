Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaIBJF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:05:58 -0400
Received: from mail-bl2lp0204.outbound.protection.outlook.com ([207.46.163.204]:18581
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752121AbaIBJFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:05:55 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jyri Sarha <jsarha@ti.com>, "broonie@kernel.org" <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Nicolin Chen <nicoleotsuka@gmail.com>
Subject: RE: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Topic: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
 code.
Thread-Index: AQHPw1WlKghmtyQaZ0ed1b/HG05M45vsCn4AgAGG1ZA=
Date: Tue, 2 Sep 2014 09:05:37 +0000
Message-ID: <6df8b3abd4ef45b093e15010ca3fd156@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1409294797-21948-1-git-send-email-Li.Xiubo@freescale.com>
 <54043EBE.9020808@ti.com>
In-Reply-To: <54043EBE.9020808@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(24454002)(53474002)(199003)(13464003)(479174003)(377454003)(51704005)(31966008)(106356001)(54356999)(50986999)(74502001)(76176999)(101416001)(33646002)(46102001)(95666004)(21056001)(20776003)(99286002)(85306004)(83072002)(74662001)(105586002)(107046002)(85852003)(77982001)(90102001)(108616004)(77096002)(74316001)(83322001)(81542001)(80022001)(19580405001)(76576001)(106116001)(19580395003)(87936001)(99396002)(86362001)(81342001)(66066001)(92566001)(4396001)(2656002)(2201001)(76482001)(64706001)(2501002)(15866825004)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jyri,

I'll follow Mark's advice of maintaining compatibility with the old DTs.

Thanks very much for your comments, and this is very important for me.

And I will also update the binding documet for simple card, please help
me review it, any comment and advice are welcome.

The goal is to simplify the simple card code and make it more readable and
Easier to add muti DAI links support from the single DAI link DTs, this will
Be very useful on my LS1+ SoCs in the future.


BRs
Xiubo



> -----Original Message-----
> From: Jyri Sarha [mailto:jsarha@ti.com]
> Sent: Monday, September 01, 2014 5:39 PM
> To: Xiubo Li-B47053; broonie@kernel.org; alsa-devel@alsa-project.org
> Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Kuninori
> Morimoto; Jean-Francois Moine; Nicolin Chen
> Subject: Re: [RFC][PATCH] ASoC: simple-card: Merge single and muti DAI link
> code.
> 
> This patch would break the current syntax without introducing any
> improvements over it (actually the opposite, see bellow). So in its
> current form I don't like this patch at all.
> 
> On 08/29/2014 09:46 AM, Xiubo Li wrote:
>  > This patch merge single DAI link and muti-DAI links code together,
>  > and simply the simple-card driver code.
>  >
>  > And also do some other improvement:
>  >
>  > Since from the DAI format micro SND_SOC_DAIFMT_CBx_CFx, the 'CBx'
>  > mean Codec's bit clock is as master/slave and the 'CFx' mean Codec's
>  > frame clock is as master/slave.
>  >
>  > So these same DAI formats should be informed to CPU and CODE DAIs at
>  > the same time. For the Codec driver will set the bit clock and frame
>  > clock as the DAI formats said, but for the CPU driver, if the the
>  > bit clock or frame clock is as Codec master, so it should be set CPU
>  > DAI device as bit clock or frame clock as slave, and vice versa.
>  >
> 
> But there is no such problem with the current code any more. The new
> preferred way is to indicate bitclock and frame master with phandles
> that refer to the master DAI on the link (see the examples bellow).
> 
>  > The old code will cause confusion, and we should be clear that the
>  > letter 'C' here mean to Codec.
>  >
>  > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
>  > Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
>  > Cc: Jean-Francois Moine <moinejf@free.fr>
>  > Cc: Jyri Sarha <jsarha@ti.com>
>  > Cc: Nicolin Chen <nicoleotsuka@gmail.com>
>  > ---
>  >
>  > Hi,
>  >
>  > This patch will break the old DT, so i just send one RFC version, and
>  > will add the old DT patches in next version if this patch can work
>  > well.
> 
> I do not object in getting rid of this simplified description for a
> single dailink card:
> 
> (example 1)
> sound {
> 	compatible = "simple-audio-card";
> ...
> 	simple-audio-card,format = "left_j";
> 	simple-audio-card,bitclock-master = <&dailink0_master>;
> 	simple-audio-card,frame-master = <&dailink0_master>;
> 	simple-audio-card,cpu {
> 		sound-dai = <&sh_fsi2 0>;
> 	};
> 
> 	dailink0_master: simple-audio-card,codec {
> 		sound-dai = <&ak4648>;
> 		clocks = <&osc>;
> 	};
> };
> 
> and describing the DAI-links always like this:
> 
> (example 2)
> sound {
> 	compatible = "simple-audio-card";
> ...
> 	simple-audio-card,dai-link@0 {
> 		format = "i2s";
> 		bitclock-master = <&dailink0_master>;
> 		frame-master = <&dailink0_master>;
> 		dailink0_master: cpu {
> 			sound-dai = <&audio1 0>;
> 		};
> 		codec {
> 			sound-dai = <&tda998x 0>;
> 		};
> 	};
> };
> 
> But I do object going back to the old syntax exclusively and
> describing the bitclock and frame master always with simple boolean
> properties, like this:
> 
> (example 3)
> sound {
> 	compatible = "simple-audio-card";
> ...
> 	simple-audio-card,dai-link@0 {
> 		format = "i2s";
> 		dailink0_master: cpu {
> 			sound-dai = <&audio1 0>;
> 		};
> 		codec {
> 			sound-dai = <&tda998x 0>;
> 			bitclock-master;
> 			frame-master;
> 		};
> 	};
> };
> 
> In my opinion we should rather get rid of this syntax than move
> exclusively to it.
> 
> The syntax of example 2 is simply superior to the syntax of example
> 3. With the syntax on example 2 it is possible to describe TDM setups
> where there is multiple codecs on a single i2s bus. The syntax of
> example 3 simply can not describe that kind of setup.
> 
> If you need to have the backwards compatibility syntax describing the
> clock masters to work also in the multilink mode (example 3), then do
> just that (it is simple enough [1]). But please do not break the new
> phandle based syntax!!!
> 
> Best regards,
> Jyri
> 
> [1] To enable legacy syntax in multilink mode just apply this patch:
> 
> diff --git a/sound/soc/generic/simple-card.c
> b/sound/soc/generic/simple-card.c
> index 8dd7957..aed3423 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -242,10 +242,10 @@ static int simple_card_dai_link_of(struct
> device_node *node,
>          if (ret < 0)
>                  goto dai_link_of_err;
> 
> -       if (strlen(prefix) && !bitclkmaster && !framemaster) {
> -               /* No dai-link level and master setting was not found from
> -                  sound node level, revert back to legacy DT parsing and
> -                  take the settings from codec node. */
> +       if (!bitclkmaster && !framemaster) {
> +               /* No dai-link level master setting was found, revert
> +                  back to legacy DT parsing and take the settings
> +                  from the codec node boolean properties. */
>                  dev_dbg(dev, "%s: Revert to legacy daifmt parsing\n",
>                          __func__);
>                  dai_props->cpu_dai.fmt = dai_props->codec_dai.fmt =

