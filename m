Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKKFlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:41:15 -0500
Received: from mail-bl2on0134.outbound.protection.outlook.com ([65.55.169.134]:4640
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751421AbaKKFlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:41:13 -0500
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Florian Fainelli <f.fainelli@gmail.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: RE: [RESENDv5] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Topic: [RESENDv5] serial: of-serial: fix up PM ops on
 no_console_suspend and port type
Thread-Index: AQHP8c6eJ+ao8BHnc0mVemoPtQSwvpxa7NwAgAAP2gCAAAKUsA==
Date: Tue, 11 Nov 2014 05:41:10 +0000
Message-ID: <bc2787a32b4d41a79acf582433831510@BN3PR0301MB1236.namprd03.prod.outlook.com>
References: <1414401857-21121-1-git-send-email-jingchang.lu@freescale.com>
 <CAGVrzcamoYbdPijWtrU=ge+UE+g9zBHAG84PJB7G3EyA09jBWg@mail.gmail.com>
 <20141111052720.GC24727@kroah.com>
In-Reply-To: <20141111052720.GC24727@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1235;
x-forefront-prvs: 0392679D18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(189002)(24454002)(13464003)(51704005)(377454003)(199003)(107046002)(62966003)(99396003)(101416001)(4396001)(77096003)(77156002)(76576001)(120916001)(19580395003)(97736003)(21056001)(19580405001)(86362001)(46102003)(108616004)(92566001)(33646002)(66066001)(74316001)(40100003)(20776003)(64706001)(50986999)(87936001)(2656002)(106116001)(76176999)(106356001)(95666004)(99286002)(54356999)(105586002)(122556002)(31966008)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1235;H:BN3PR0301MB1236.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAB5fJ3v001378



>-----Original Message-----
>From: Greg KH [mailto:gregkh@linuxfoundation.org]
>Sent: Tuesday, November 11, 2014 1:27 PM
>To: Florian Fainelli
>Cc: Lu Jingchang-B35083; linux-arm-kernel@lists.infradead.org; linux-
>kernel@vger.kernel.org; linux-serial@vger.kernel.org
>Subject: Re: [RESENDv5] serial: of-serial: fix up PM ops on
>no_console_suspend and port type
>
>On Mon, Nov 10, 2014 at 08:30:36PM -0800, Florian Fainelli wrote:
>> 2014-10-27 2:24 GMT-07:00 Jingchang Lu <jingchang.lu@freescale.com>:
>> > This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
>> > "serial: of-serial: add PM suspend/resume support", which disables
>> > the uart clock on suspend, but also causes a hardware hang on
>> > register access if no_console_suspend command line option is used.
>> >
>> > Also, not every of_serial device is an 8250 port, so the serial8250
>> > suspend/resume functions should only be applied to a real 8250 port.
>>
>> Greg, can you pick this one and submit it for your next 3.18-rc
>> submission? This fixes a regression when using "no_console_suspend"
>> introduced by:
>>
>> 2dea53bf57783f243c892e99c10c6921e956aa7e ("serial: of-serial: add PM
>> suspend/resume support") which has been merged during 3.18-rc1
>
>Why can't I just revert that patch instead?  This is really late in the -
>rc cycle to be doing large fixes like this.
>
>And this patch is already queued up for 3.19-rc1, so this is a mess...
>
>Any objection to me just reverting
>2dea53bf57783f243c892e99c10c6921e956aa7e, and then this one in my tty-next
>branch as well, and then someone resending the original patch in a format
>that actually works?
Do you mean resending the "serial: of-serial: add PM suspend/resume support"
patch with "serial: of-serial: fix up PM ops on no_console_suspend and port type"
merged together? For you would like to reverting the previous patch of
"2dea53bf57783f243c892e99c10c6921e956aa7e".

Thanks and Best Regards,
Jingchang
>
>thanks,
>
>greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
