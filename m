Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaHMKKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 06:10:10 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:11061
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751530AbaHMKKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 06:10:07 -0400
From: Peter Chan <peter.chan@freescale.com>
To: Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "shengjiu.wang@freescale.com" <shengjiu.wang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        Nicolin Chen <nicoleotsuka@gmail.com>,
        "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "rf@opensource.wolfsonmicro.com" <rf@opensource.wolfsonmicro.com>
Subject: RE: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
 enable mono speaker output
Thread-Topic: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to
 enable mono speaker output
Thread-Index: AQHPtniApJTszbxsakmAu2awz0JIaJvOTKrQ
Date: Wed, 13 Aug 2014 10:10:02 +0000
Message-ID: <c26b64bd035e49a7a145a0ac81b01f8e@DM2PR03MB384.namprd03.prod.outlook.com>
References: <1407412549-14983-1-git-send-email-nicoleotsuka@gmail.com>
 <20140807165836.GL17528@sirena.org.uk> <20140808082043.GB6333@MrMyself>
 <39712b9fd56546f8a943d605230a2f18@BL2PR03MB371.namprd03.prod.outlook.com>
 <20140811131949.GA28085@opensource.wolfsonmicro.com>
 <20140812082416.GA15833@opensource.wolfsonmicro.com>
 <20140812215742.GE17528@sirena.org.uk>
In-Reply-To: <20140812215742.GE17528@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.170.1]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(51704005)(199003)(13464003)(189002)(24454002)(80022001)(83322001)(92566001)(86362001)(74662001)(54356999)(20776003)(19580395003)(66066001)(83072002)(64706001)(108616004)(76576001)(2656002)(19580405001)(74502001)(21056001)(4396001)(46102001)(76482001)(85852003)(106116001)(33646002)(77982001)(79102001)(106356001)(93886004)(107046002)(85306004)(99396002)(31966008)(101416001)(50986999)(76176999)(74316001)(105586002)(99286002)(81342001)(87936001)(95666004)(81542001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB448;H:DM2PR03MB384.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that in mono speaker mode, only the left channel is enable. The SPKOUTR_PGA_ENA bit remains 0 in this case. Thus when SPKOUTR_ENA is set, poor sound quality results.

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Wednesday, August 13, 2014 5:58 AM
To: Charles Keepax
Cc: CHAN Peter-B18700; alsa-devel@alsa-project.org; tiwai@suse.de; linux-kernel@vger.kernel.org; patches@opensource.wolfsonmicro.com; Wang Shengjiu-B02247; lgirdwood@gmail.com; Nicolin Chen; Chen Guangyu-B42378; rf@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH] ASoC: wm8962: Correct the bit offset to enable mono speaker output

On Tue, Aug 12, 2014 at 09:24:16AM +0100, Charles Keepax wrote:
> On Mon, Aug 11, 2014 at 02:19:49PM +0100, Charles Keepax wrote:

> > From the wording of "tie both outputs together" in the datasheet I 
> > would assume that means both should be fed the same audio? Was this 
> > done? I will try to give the hardware guys here a shout and see if I 
> > can get some clarification on mono mode on this device.

> I have had a word with the hardware team here and both channels do 
> need to be enabled but audio should only be fed to the left channel. 
> So the driver definitely needs updated for the mono case, but I am 
> unclear as to what is causing your poor audio quality issue.

Overdriving the speaker perhaps?
