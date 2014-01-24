Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbaAXCqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:46:49 -0500
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:4160
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbaAXCqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:46:48 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "moinejf@free.fr" <moinejf@free.fr>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH Resend 7/8] ASoC: add
 snd_soc_of_parse_audio_simple_widgets for DeviceTree
Thread-Topic: [PATCH Resend 7/8] ASoC: add
 snd_soc_of_parse_audio_simple_widgets for DeviceTree
Thread-Index: AQHPGACs90QsyiOhrEWLbv1Hg0tOIZqStbuAgABvx4A=
Date: Fri, 24 Jan 2014 02:46:33 +0000
Message-ID: <638679dfd176409680c962cdeb3704ef@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-8-git-send-email-Li.Xiubo@freescale.com>
 <20140123193945.GH11727@sirena.org.uk>
In-Reply-To: <20140123193945.GH11727@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 01018CB5B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(164054003)(189002)(80022001)(47446002)(74502001)(74316001)(81342001)(85306002)(4396001)(76576001)(87936001)(31966008)(90146001)(81542001)(56816005)(2656002)(93516002)(74366001)(77982001)(94316002)(69226001)(85852003)(86362001)(83072002)(74706001)(65816001)(87266001)(76796001)(74662001)(49866001)(47736001)(74876001)(83322001)(81686001)(33646001)(66066001)(47976001)(46102001)(80976001)(63696002)(53806001)(51856001)(59766001)(79102001)(54316002)(92566001)(50986001)(81816001)(76786001)(54356001)(56776001)(76482001)(93136001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0O2kxPe028019


> > +static struct snd_soc_dapm_widget simple_widgets[] = {
> > +	SND_SOC_DAPM_MIC("Mic", NULL),
> > +	SND_SOC_DAPM_LINE("Line", NULL),
> > +	SND_SOC_DAPM_HP("Hp", NULL),
> > +	SND_SOC_DAPM_SPK("Spk", NULL),
> > +};
> 

This is the templates for "Microphone XXX", "Line XXX", "Headphone XXX"
and "Spk XXX" .



> Does this mean we're restricted to a particular set of names?  That
> seems sad and won't work if there's a desire for more than one of a
> given widget - the main use case I can see is multiple microphones with
> separate microphone biases.  How about having some templates that we
> copy and then replace the name with the one the user supplied?
> 

This code has already supplied this I think.

Using this API, the only limitation is that, for example if the user has
multiple Microphones, it should set the name in DT file like:

"Mic XXX", "Mic YYY", "Mic ZZZ"...

And these widgets will use the template of : SND_SOC_DAPM_MIC("Mic", NULL),
And the widgets' names will be replaced with "Mic XXX", "Mic YYY",
"Mic ZZZ"... from the user's DT node.



Or your suggestion is £º

The templates is:
+static struct snd_soc_dapm_widget simple_widgets[] = {
+	SND_SOC_DAPM_MIC("Mic", NULL),
+	SND_SOC_DAPM_LINE("Line", NULL),
+	SND_SOC_DAPM_HP("Hp", NULL),
+	SND_SOC_DAPM_SPK("Spk", NULL),
+};

And in the DT node:
simple-off-codec-widgets = 
/*	template-name	user-supplied-name	*/
	"Mic",		"Microphone XXX",
	"Mic",		"UUU Microphone YYY",
	"Hp",		"TTT Headphone XXX",
	"Hp",		"Headphone YYY";

And then just replace the template's name with the user supplied name?


Thanks,

Best Regards,
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
