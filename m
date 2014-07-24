Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbaGXDgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 23:36:39 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:12508
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758526AbaGXDgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 23:36:37 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v5 0/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v5 0/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPplZS12HOgaurWE6pPVifgTUu7ZutlmmAgADwPgA=
Date: Thu, 24 Jul 2014 03:36:34 +0000
Message-ID: <e5547e015bf6447e9b4fc18e82ddce74@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
 <201407231428.01278.marex@denx.de>
In-Reply-To: <201407231428.01278.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(24454002)(377454003)(199002)(189002)(74316001)(99396002)(21056001)(46102001)(79102001)(87936001)(64706001)(92566001)(83322001)(4396001)(85852003)(83072002)(2656002)(76576001)(85306003)(50986999)(101416001)(54356999)(105586002)(77982001)(107046002)(20776003)(81542001)(76482001)(80022001)(99286002)(66066001)(33646002)(81342001)(106116001)(74502001)(76176999)(31966008)(106356001)(95666004)(110136001)(86362001)(74662001)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB338;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Marek Vasut wrote:
> On Wednesday, July 23, 2014 at 10:24:41 AM, Yuan Yao wrote:
> > Changed in v5:
> > - add "*chan_dev = dma->chan_using->device->dev" for reduce the call time.
> 
> Did you check if the compiler generates different code ?
> 

Sorry, I didn't compare the assembly code. It's a subtle change. 
As you mentioned the "noodle" before.

Old:
dma_map_single(dma->chan_using->device->dev, ...);
dma_mapping_error(dma->chan_using->device->dev, ...);
dma_unmap_single(dma->chan_using->device->dev, ...);
	
New:
struct device *chan_dev = dma->chan_using->device->dev;
dma_map_single(chan_dev, ...);
dma_mapping_error(chan_dev, ...);
dma_unmap_single(chan_dev, ...);

> > - add the test logs.
> 
> [...]
> 
> Best regards,
> Marek Vasut
