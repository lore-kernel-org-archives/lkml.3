Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaCLJxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:53:13 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:52862
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752951AbaCLJxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:53:10 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(z579ehzbb2dI98dI9371I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 17:33:54 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Jyri Sarha <jsarha@ti.com>
CC: <broonie@kernel.org>, <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <kuninori.morimoto.gx@renesas.com>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <Li.Xiubo@freescale.com>, <linux-doc@vger.kernel.org>,
        <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <rob@landley.net>, <galak@codeaurora.org>,
        <moinejf@free.fr>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: simple-card: overwrite
 cpu_dai->fmt with codec_dai->fmt
Message-ID: <20140312093353.GH1177@MrMyself>
References: <1394593331-22867-1-git-send-email-Guangyu.Chen@freescale.com>
 <5320280C.6080004@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5320280C.6080004@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:25:32AM +0200, Jyri Sarha wrote:
> On 03/12/2014 05:02 AM, Nicolin Chen wrote:
> >The current simple-card driver separates the daimft for cpu_dai and codec_dai.
> >So we might get different values for them (0x4003 and 0x1003 for example):
> >
> >asoc-simple-card sound-cs42888.12: cpu : 2024000.esai / 4003 / 132000000
> >asoc-simple-card sound-cs42888.12: codec : cs42888 / 1003 / 24576000
> >asoc-simple-card sound-cs42888.12: cs42888 <-> 2024000.esai mapping ok
> >
> >This is not allowed at all as we need to keep the DAIFMT settings identical
> >for both the ends of the link.
> >
> >Thus this patch fixes it by overwriting the cpu_dai->fmt with codec_dai->fmt
> >since we defined the DAIFMT_MASTER basing on CODEC at the first place while
> >the other bits are same.
> >
> >Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> >---
> Hi Nicolin,
> This patch is an improvement, but in my opinion the binding is still
> a bit confusing.
> 
> How about changing 'frame-master' and 'bitclock-master' to
> 'codec-frame-master' and 'codec-bitclock-master'. We could possibly
> keep the old names as aliases until all the .dts files out there
> have been fixed.
> 
> At the same go we could add SND_SOC_DAIFMT_MASTER_MASK here:
> 
> > /* get CPU/CODEC common format via simple-audio-card,format */
> > priv->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
> >		(SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);
> 
> or leave the masking out all together. Can't see why
> SND_SOC_DAIFMT_CONT/GATED could not be defined at dai-link level
> too.
> 
> This way the norm would be defining the daifmt at link level. We
> could still keep the possibility to overwrite the setting at dai
> level if there is need for that.

Hi Jyri,

After looking at Morimoto-san's mail, I think there might be a better
solution for this issue as he suggested: We may move the fmt from
struct asoc_simple_dai to a common place for both CPU and CODEC.

I'm not sure if there's any defect from this idea, but as long as we
keep DAIFMT settings identical for both dai-link ends, it'll be a
neater way.

So I'd like to pend this patch and wait for further solution from that
topic.

Thank you,
Nicolin Chen


