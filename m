Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbaCCHYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 02:24:41 -0500
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:10305
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753835AbaCCHYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 02:24:40 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lars@metafoo.de" <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Topic: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
Thread-Index: AQHPNpOHBWw5RTyHRUi7LlXismLKZJrOzasAgAAnM/A=
Date: Mon, 3 Mar 2014 07:24:36 +0000
Message-ID: <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
 <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
 <20140303045952.GO2411@sirena.org.uk>
In-Reply-To: <20140303045952.GO2411@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0139052FDB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(51704005)(74662001)(47446002)(74502001)(2656002)(86362001)(87266001)(66066001)(93516002)(80022001)(94946001)(65816001)(93136001)(74876001)(85306002)(76796001)(76576001)(4396001)(63696002)(47736001)(33646001)(49866001)(74706001)(47976001)(50986001)(87936001)(76786001)(79102001)(76482001)(81542001)(74316001)(69226001)(46102001)(51856001)(81816001)(83072002)(85852003)(54356001)(74366001)(54316002)(56776001)(90146001)(59766001)(56816005)(77982001)(83322001)(81342001)(80976001)(81686001)(53806001)(95416001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB428;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  static int ak4535_probe(struct snd_soc_codec *codec)
> >  {
> > -	struct ak4535_priv *ak4535 = snd_soc_codec_get_drvdata(codec);
> > -	int ret;
> > -
> > -	codec->control_data = ak4535->regmap;
> > -	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
> > -	if (ret < 0) {
> > -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> > -		return ret;
> > -	}
> >  	/* power on device */
> >  	ak4535_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
> 
> Are you sure that the set_bias_level() call doesn't do anything with
> I/O?  Can I suggest sending a patch that just does the drivers that only
> do set_cache_io() and nothing else in probe - that would be really quick
> and simple to fix.
> 
> > -	ret = snd_soc_codec_set_cache_io(codec, 8, 8, SND_SOC_REGMAP);
> > -	if (ret < 0) {
> > -		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
> > -		return ret;
> > -	}
> > -
> >  	/* Default to using ALC auto offset calibration mode. */
> >  	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
> >  			    DA7213_ALC_CALIB_MODE_MAN, 0);
> 
> This one will fail.

Sorry, I'm not very understand why will this fail ? Before the ASoC probe,
the ASoC core will set the I/O. 
:)




