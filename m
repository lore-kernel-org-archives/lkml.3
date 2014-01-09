Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaAIHnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 02:43:45 -0500
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:28803
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbaAIHnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 02:43:42 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/4] ASoC: simple-card: add simple audio card widgets
 support
Thread-Topic: [PATCH 1/4] ASoC: simple-card: add simple audio card widgets
 support
Thread-Index: AQHPDEeKUc5SfWdwt0CWvotqSXxSd5p7Hj4AgADEp/A=
Date: Thu, 9 Jan 2014 07:43:39 +0000
Message-ID: <978e195be6ae493584be24c6821a80ad@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389164556-2728-1-git-send-email-Li.Xiubo@freescale.com>
 <20140108175940.GQ31886@sirena.org.uk>
In-Reply-To: <20140108175940.GQ31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(51704005)(199002)(189002)(74366001)(46102001)(51856001)(2656002)(87936001)(65816001)(80022001)(66066001)(33646001)(85306002)(77982001)(59766001)(47976001)(50986001)(4396001)(47736001)(54316002)(49866001)(79102001)(53806001)(54356001)(87266001)(56776001)(63696002)(76482001)(74316001)(31966008)(74662001)(69226001)(76796001)(81342001)(81686001)(74502001)(47446002)(85852003)(80976001)(83072002)(83322001)(74706001)(74876001)(76576001)(76786001)(81542001)(81816001)(92566001)(56816005)(90146001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > For many audio cards there need to add some off-CODEC widgets, and this
> > is hard to be supported by dts only, because maybe some widgets need one
> > or more call backs, such as wevent.
> 
> The big question here would be why these widgets need to be added
>

For instance, from the SGTL5000 codec Spec:
----
The analog input block contains a stereo line input and a microphone input
with mic bias. Either input can be routed to the ADC. The line input can also
be configured to bypass the CODEC and be routed directly to the headphone
output.
----
And in the SGTL5000 codec driver there is one "Mic Bias" widget, and this
should be routed to one off-CODEC widget, like "Mic Jack"(the microphone input).


> the
> default thing is that all inputs and outputs are enabled so it can't be
> that and as you say callbacks are going to need to be added.
> 

Some drivers may need like this:
----
         SND_SOC_DAPM_PGA_E("Output Amp", SND_SOC_NOPM, 0, 0, NULL, 0,
                         XXX_output_amp_event, SND_SOC_DAPM_PRE_PMU |
                         SND_SOC_DAPM_POST_PMD),
----
 ?



> If this is used then it probably makes sense for the card to set the
> fully routed flag since one possible use is to disable unconnected pins
> on the CODEC.
> 
> > +- simple-sudio-card,widgets		: The name of the audio card off-CODEC
> widgets.
> 
> simple-audio-card.  This also needs more documentation about what is
> supposed to be filled in here.
> 

Yes, if needed.

> > +void
> > +asoc_simple_card_widgets_unregister(struct asoc_simple_card_widgets *comp)
> 
> We always use snd_soc.
> 
> One interesting thing here is that this is done separately to the card
> itself.  Is there any actual dependency on the simple card, could this
> be made into a generic library that any machine driver could use?  I can
> see other machines being able to make use of this.

No, has no dependency on the simple card.




Thanks,

--
Best Regards,
Xiubo


