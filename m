Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaAFFmE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 00:42:04 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:28632
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750810AbaAFFmD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 00:42:03 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>
CC: "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCH v2] ASoC: soc-core: add snd_soc_of_parse_master_clkdir()
 for dt
Thread-Topic: [PATCH v2] ASoC: soc-core: add
 snd_soc_of_parse_master_clkdir() for dt
Thread-Index: AQHPB20FBDU3KsnZwkq1MPUZG+B5i5p3M+oQ
Date: Mon, 6 Jan 2014 05:41:59 +0000
Message-ID: <23375d0ac7734f37be9928d6add885f7@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388630905-1321-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1388630905-1321-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0083A7F08A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(51704005)(45074003)(189002)(164054003)(199002)(33646001)(47976001)(50986001)(77982001)(46102001)(2656002)(74876001)(56816005)(31966008)(87266001)(74662001)(74502001)(47446002)(74706001)(90146001)(4396001)(87936001)(85306002)(85852003)(76576001)(76786001)(76796001)(74316001)(79102001)(54356001)(51856001)(59766001)(80976001)(65816001)(76482001)(80022001)(66066001)(74366001)(83322001)(81816001)(47736001)(81342001)(81542001)(49866001)(69226001)(83072002)(81686001)(54316002)(19580395003)(56776001)(19580405001)(63696002)(53806001)(24736002)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to know the current status of this patch, and there are some
other patches that for simple-card are depended on this one.

Thanks,


--
> This patch adds snd_soc_of_parse_master_clkdir() and supports below
> style on dt:
> 
> master-clkdir-out;
> 
> If this property is absent 0 will be returned, 1 otherwise.
> 0 : SND_SOC_CLOCK_IN
> 1 : SND_SOC_CLOCK_OUT
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  include/sound/soc.h  |  1 +
>  sound/soc/soc-core.c | 11 +++++++++++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/include/sound/soc.h b/include/sound/soc.h
> index 5a049d9..690f4f6 100644
> --- a/include/sound/soc.h
> +++ b/include/sound/soc.h
> @@ -1170,6 +1170,7 @@ int snd_soc_of_parse_card_name(struct snd_soc_card *card,
>  			       const char *propname);
>  int snd_soc_of_parse_audio_routing(struct snd_soc_card *card,
>  				   const char *propname);
> +unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np);
>  unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
>  				     const char *prefix);
>  int snd_soc_of_get_dai_name(struct device_node *of_node,
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index be88df5..f155207 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -4472,6 +4472,17 @@ int snd_soc_of_parse_audio_routing(struct snd_soc_card
> *card,
>  }
>  EXPORT_SYMBOL_GPL(snd_soc_of_parse_audio_routing);
> 
> +unsigned int snd_soc_of_parse_master_clkdir(struct device_node *np)
> +{
> +	/*
> +	 * check "master-clkdir-out"
> +	 * false means SND_SOC_CLOCK_IN
> +	 * true means SND_SOC_CLOCK_OUT
> +	 */
> +	return !!of_property_read_bool(np, "master-clkdir-out");
> +}
> +EXPORT_SYMBOL_GPL(snd_soc_of_parse_master_clkdir);
> +
>  unsigned int snd_soc_of_parse_daifmt(struct device_node *np,
>  				     const char *prefix)
>  {
> --
> 1.8.4
> 

