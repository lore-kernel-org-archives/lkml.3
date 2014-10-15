Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307AbaJOHQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 03:16:38 -0400
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:46912
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750775AbaJOHQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 03:16:36 -0400
X-Greylist: delayed 163616 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2014 03:16:36 EDT
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Joseph Lo <josephl@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Topic: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Index: AQHP55FFIMYR88HhxkeSAEfc0gxGHJwwV92AgABVjuCAAAmnAIAAAxSAgAAEtuA=
Date: Wed, 15 Oct 2014 07:16:33 +0000
Message-ID: <b7caa34e784a47dfa585cea66ebfbb69@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
 <543DC753.4070304@nvidia.com>
 <67564f37252242079bcd4c65827b8352@BL2PR03MB467.namprd03.prod.outlook.com>
 <543E1730.2040108@nvidia.com> <543E19C5.3040200@nvidia.com>
In-Reply-To: <543E19C5.3040200@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB465;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(24454002)(51704005)(189002)(479174003)(377454003)(199003)(33646002)(107046002)(40100003)(108616004)(92566001)(93886004)(85306004)(120916001)(99396003)(105586002)(106116001)(99286002)(106356001)(74316001)(101416001)(95666004)(122556002)(19580395003)(21056001)(19580405001)(76576001)(76176999)(80022003)(46102003)(54356999)(85852003)(87936001)(66066001)(76482002)(2656002)(64706001)(20776003)(97736003)(50986999)(86362001)(2501002)(31966008)(4396001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB465;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9F7Ghqf029606

>-----Original Message-----
>From: Joseph Lo [mailto:josephl@nvidia.com]
>Sent: Wednesday, October 15, 2014 2:53 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: linux-arm-kernel@lists.infradead.org; linux-serial@vger.kernel.org;
>peter@hurleysoftware.com; arnd@arndb.de; linux-kernel@vger.kernel.org
>Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on
>no_console_suspend and port type
>
>On 10/15/2014 02:41 PM, Joseph Lo wrote:
>> On 10/15/2014 02:32 PM, Jingchang Lu wrote:
>>>> -----Original Message-----
>>>> From: Joseph Lo [mailto:josephl@nvidia.com]
>>>> Sent: Wednesday, October 15, 2014 9:01 AM
>>>> To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>>>> Cc: peter@hurleysoftware.com; arnd@arndb.de;
>>>> linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
>>>> linux-arm-kernel@lists.infradead.org
>>>> Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on
>>>> no_console_suspend and port type
>>>>
>>>> On 10/14/2014 04:42 PM, Jingchang Lu wrote:
>>>>> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
>>>>> "serial: of-serial: add PM suspend/resume support", which disables
>>>>> the uart clock on suspend, but also causes a hardware hang on
>>>>> register access if no_console_suspend command line option is used.
>>>>>
>>>>> Also, not every of_serial device is an 8250 port, so the serial8250
>>>>> suspend/resume functions should only be applied to a real 8250 port.
>>>>>
>>>>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>>>>
>>>> If you can make sure this patch can build without include
>>>> <linux/console.h>, then this patch
>>> The build passes on my cloned linux-next tree, include next-20141014,
>>> but is required on my another kernel-3.12+ based tree, then I didn't
>>> add this header file when upstream.
>>> Is the build broken on your source tree, and is the tree latest?
>>> If the header is needed, I will add it.
>> I tested it on next-20141013 and k3.14, both of them need the fix. I
>> can check it again against the latest linux-next tree later. Thanks.
>>
>OK, I confirmed it. You should add the header file. It also doesn't build
>for me with the latest linux-next tree. Maybe you missed to enable
>CONFIG_PM_SLEEP or CONFIG_SERIAL_8250 when doing the build test in linux-
>next tree.
I have sent out the v5 patch with last git-send-email command line,
didn't realized the missing of your email address in the cc list when sending.
Please help review the v5 patch. Thanks.

Best Regards,
Jingchang
>
>-Joseph
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
