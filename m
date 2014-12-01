Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaLAJ4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:56:48 -0500
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:2816
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752719AbaLAJ4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:56:45 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: "vinod.koul@intel.com" <vinod.koul@intel.com>
CC: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Topic: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Index: AQHP7dxw0ZXsnje90ESiN3180LVrWZxq5yNQgA/UC+A=
Date: Mon, 1 Dec 2014 09:56:43 +0000
Message-ID: <BN3PR0301MB1236DA27ED13519CB8724F26877D0@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1413968035-12855-1-git-send-email-jingchang.lu@freescale.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.51]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
x-forefront-prvs: 0412A98A59
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(13464003)(199003)(377454003)(4396001)(20776003)(107046002)(106116001)(2351001)(105586002)(99396003)(19580405001)(120916001)(19580395003)(46102003)(77156002)(77096004)(62966003)(95666004)(106356001)(76576001)(99286002)(54206007)(40100003)(101416001)(2656002)(87936001)(21056001)(2501002)(33656002)(122556002)(31966008)(97736003)(74316001)(50986999)(54606007)(76176999)(64706001)(54356999)(86362001)(92726001)(92566001)(110136001)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1234;H:BN3PR0301MB1236.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sB19usc8007965

Hi, Vinod,

  Could you please help review and merge this patch if possible. Thanks.

Thanks and Best Regards,
Jingchang

>>-----Original Message-----
>>From: Jingchang Lu [mailto:jingchang.lu@freescale.com]
>>Sent: Wednesday, October 22, 2014 4:54 PM
>>To: vinod.koul@intel.com
>>Cc: dmaengine@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>>linux-kernel@vger.kernel.org; Lu Jingchang-B35083
>>Subject: [PATCHv4] dmaengine: fsl-edma: fixup reg offset and hw S/G
>>support in big-endian model
>>
>>The offset of all 8-/16-bit registers in big-endian eDMA model are
>>swapped in a 32-bit size opposite those in the little-endian model.
>>
>>The hardware Scatter/Gather requires the subsequent TCDs stored in
>>memory in little endian independent of the register endian model, the
>>eDMA engine will do the swap if need.
>>
>>This patch also use regular assignment for tcd variables r/w instead of
>>with io function previously that may not always be true.
>>
>>Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>>---
>>changes in v4:
>> use __le32/16 define little endian tcd struct explicitly.
>> modify fsl_edma_set_tcd_regs() to simplify parameters.
>> define fsl_edma_fill_tcd() as inline function.
>>
>>changes in v3:
>> use unsigned long instead of u32 in reg offset swap cast to avoid
>warning.
>>
>>changes in v2:
>> simplify register offset swap calculation.
>> use regular assignment for tcd variables r/w instead of io function.
>>
>> drivers/dma/fsl-edma.c | 189
>>+++++++++++++++++++++++++-------------------
>>-----
>> 1 file changed, 96 insertions(+), 93 deletions(-)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
