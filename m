Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaLHJt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:49:58 -0500
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:52288
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751969AbaLHJt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:49:56 -0500
From: Zidan Wang <B50113@freescale.com>
To: Mark Brown <broonie@kernel.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Topic: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver
 manage its own MCLK
Thread-Index: AQHQELJ7KekiT6rB20u7rIYT8SQqOZyFW1pA
Date: Mon, 8 Dec 2014 09:49:51 +0000
Message-ID: <BN3PR0301MB12511B448B1C0B9E8F0BB6C48D640@BN3PR0301MB1251.namprd03.prod.outlook.com>
References: <1417696879-15402-1-git-send-email-b50113@freescale.com>
 <20141205170156.GB14516@opensource.wolfsonmicro.com>
 <20141205173932.GN11764@sirena.org.uk>
In-Reply-To: <20141205173932.GN11764@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.53]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0610;
x-forefront-prvs: 041963B986
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(13464003)(189002)(377454003)(199003)(51704005)(122556002)(31966008)(21056001)(62966003)(77156002)(68736005)(120916001)(46102003)(4396001)(107046002)(102836002)(97736003)(54206007)(99396003)(74316001)(40100003)(19580405001)(19580395003)(101416001)(106356001)(33656002)(106116001)(99286002)(105586002)(66066001)(50986999)(20776003)(76176999)(54356999)(64706001)(2656002)(87936001)(76576001)(92566001)(54606007)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0610;H:BN3PR0301MB1251.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0705;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I should move mclk to wm8960_priv. 
And doing wm8960_priv->mclk = devm_clk_get(&i2c->dev, "codec_mclk") in wm8960_i2c_probe.

Best Regards,
Zidan

-----Original Message-----
From: Mark Brown [mailto:broonie@kernel.org] 
Sent: Saturday, December 06, 2014 1:40 AM
To: Charles Keepax
Cc: Wang Zidan-B50113; lgirdwood@gmail.com; perex@perex.cz; tiwai@suse.de; lars@metafoo.de; Xiubo Li-B47053; patches@opensource.wolfsonmicro.com; alsa-devel@alsa-project.org; linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH v3] ASoC: wm8960: Let wm8960 codec driver manage its own MCLK

On Fri, Dec 05, 2014 at 05:01:56PM +0000, Charles Keepax wrote:
> On Thu, Dec 04, 2014 at 08:41:19PM +0800, Zidan Wang wrote:

> >  struct wm8960_data {
> > +	struct clk *mclk;

> Is this really pdata? Would the pdata entry to locate the clock not be 
> a string holding the clock name that you call clk_get on, rather than 
> a clk pointer itself? Probably this should go in wm8960_priv instead.

There should be no platform data of any kind for the clock, the name should be fixed and defined in terms of the name of the clock on the device requesting it.  The code is actually doing the right thing here, it's just that it's put the variable into the platform data because currently the driver just uses the platform data as the driver data.
