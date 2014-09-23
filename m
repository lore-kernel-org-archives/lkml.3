Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbaIWRyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:54:16 -0400
Received: from mail-bn1on0146.outbound.protection.outlook.com ([157.56.110.146]:36544
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755465AbaIWRyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:54:15 -0400
X-Greylist: delayed 1035 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 13:54:15 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G	support
 in big-endian model
Thread-Topic: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G	support
 in big-endian model
Thread-Index: AQHP1xpkNr2vabzJX0qyW8p94G7A0ZwO9q+m
Date: Tue, 23 Sep 2014 17:21:06 +0000
Message-ID: <1411492862884.42316@freescale.com>
References: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>,<20140923103721.GQ5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140923103721.GQ5182@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.125.191.37]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;
x-forefront-prvs: 0343AC1D30
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(189002)(24454002)(199003)(101416001)(99286002)(117636001)(76482002)(85306004)(106356001)(105586002)(106116001)(76176999)(2656002)(50986999)(99396002)(64706001)(36756003)(87936001)(95666004)(21056001)(85852003)(110136001)(97736003)(92726001)(74662003)(90102001)(4396001)(107046002)(46102003)(81542003)(31966008)(19580395003)(86362001)(54356999)(19580405001)(83072002)(81342003)(20776003)(66066001)(83322001)(74502003)(92566001)(79102003)(80022003)(120916001)(77982003)(10300001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_______________________________________
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Sent: Tuesday, September 23, 2014 6:37 PM
To: Lu Jingchang-B35083
Cc: vinod.koul@intel.com; dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G   support in big-endian model

On Tue, Sep 23, 2014 at 05:15:19PM +0800, Jingchang Lu wrote:
>  static u16 edma_readw(struct fsl_edma_engine *edma, void __iomem *addr)
>  {
> -     if (edma->big_endian)
> -             return ioread16be(addr);
> -     else
> +     u32 dst;

This should be unsigned long, if it needs to exist.

> +     /* swap the reg offset for these in big-endian mode */
> +     if (edma->big_endian) {
> +             dst = ((u32)addr & ~0x3) | (((u32)addr & 0x3) ^ 0x2);

This can be simplified to:

                addr = (void __iomem *)((unsigned long)addr ^ 2);

Ditto for all the other cases.

I will do that, Thanks.

Best Regards,
Jingchang

