Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaATDSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 22:18:51 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:54906
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752566AbaATDSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 22:18:48 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ASoC: core: Use devm_kzalloc() instead
 kzalloc()
Thread-Topic: [alsa-devel] [PATCH] ASoC: core: Use devm_kzalloc() instead
 kzalloc()
Thread-Index: AQHPEp9NikvZnjiQ3EKzQF54KajXFJqH5UiAgAFfB4CAA7LIgA==
Date: Mon, 20 Jan 2014 03:18:44 +0000
Message-ID: <1b7c6490c56549978740f5d27bb9d392@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1389861887-32721-1-git-send-email-Li.Xiubo@freescale.com>
 <52D854A3.5090109@metafoo.de> <20140117184857.GH17314@sirena.org.uk>
In-Reply-To: <20140117184857.GH17314@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00979FCB3A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(164054003)(199002)(189002)(51704005)(51856001)(56816005)(47446002)(76482001)(74316001)(54356001)(83072002)(63696002)(33646001)(74366001)(54316002)(85852003)(65816001)(90146001)(80022001)(74662001)(93516002)(86362001)(66066001)(74502001)(74876001)(77982001)(74706001)(31966008)(46102001)(2656002)(83322001)(59766001)(53806001)(4396001)(47736001)(81816001)(85306002)(47976001)(81686001)(80976001)(93136001)(49866001)(76786001)(76576001)(87266001)(87936001)(92566001)(76796001)(81542001)(81342001)(79102001)(50986001)(69226001)(56776001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB505;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mar, Lars


> > I don't like this. I don't think it is a good design pattern to call
> > devm function from within (especial non-devm) library functions. It
> > creates an asymmetric API. The memory is allocated when
> > snd_dmaengine_pcm_register() is called, but it is not freed when
> > snd_dmaengine_pcm_unregister() is called. This goes against the
> > principle of least surprise.
> 
> Yes, I tend to agree - unless we only support managed registration the
> API shouldn't do managed things internally.

Got it.

Thanks,

