Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaLDMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 07:34:27 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:25680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753806AbaLDMeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 07:34:25 -0500
From: Zidan Wang <B50113@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "ckeepax@opensource.wolfsonmicro.com" 
	<ckeepax@opensource.wolfsonmicro.com>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel][PATCH v2] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Topic: [alsa-devel][PATCH v2] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Index: AQHQD5uHBipu5Wzgq0uo7TZDsuUQHpx/SrgAgAACTNA=
Date: Thu, 4 Dec 2014 12:34:20 +0000
Message-ID: <BY1PR0301MB1253AD2792540463CD7D70F68D780@BY1PR0301MB1253.namprd03.prod.outlook.com>
References: <1417681425-4360-1-git-send-email-b50113@freescale.com>
 <20141204112512.GS7712@sirena.org.uk>
In-Reply-To: <20141204112512.GS7712@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0620;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0620;
x-forefront-prvs: 041517DFAB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(13464003)(377454003)(24454002)(199003)(40100003)(76576001)(31966008)(122556002)(107046002)(54356999)(4396001)(21056001)(76176999)(54606007)(50986999)(68736005)(106116001)(106356001)(64706001)(20776003)(105586002)(66066001)(120916001)(77156002)(99396003)(62966003)(97736003)(101416001)(46102003)(99286002)(2656002)(87936001)(95666004)(19580405001)(19580395003)(92726001)(92566001)(110136001)(86362001)(33656002)(54206007)(74316001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0620;H:BY1PR0301MB1253.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply. 
You are right, the machine driver should disable the PLL.


Best Regards,
Zidan

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Thursday, December 04, 2014 7:25 PM
To: Wang Zidan-B50113
Cc: lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; lars@metafoo.de; ckeepax@opensource.wolfsonmicro.com; Xiubo Li-B47053; patches@opensource.wolfsonmicro.com; alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v2] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK

On Thu, Dec 04, 2014 at 04:23:45PM +0800, Zidan Wang wrote:

> If we use PLL to generate sysclk, wm8960_set_dai_pll() will enable 
> PLL. But PLL doesn't power down after using codec. So power down PLL in suspend().

That would be a bug in the machine driver, the machine driver should be disabling the PLL when it suspends since the startup and shutdown of the PLL need to be coordinated with the input clocks.  Besides, if we were doing this in the CODEC driver then as I said last time the PLL needs to be restored on resume since the machine driver should be able to expect that settings it has made are preserved (eg, if it sets things up on init).
