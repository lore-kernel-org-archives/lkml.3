Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbaJIHx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:53:58 -0400
Received: from mail-by2on0107.outbound.protection.outlook.com ([207.46.100.107]:47712
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873AbaJIHxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:53:51 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Joseph Lo <josephl@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] serial: of-serial: add PM suspend/resume support
Thread-Topic: [PATCH] serial: of-serial: add PM suspend/resume support
Thread-Index: AQHP1xCbXYJ2l2dpvUGwFdgTLB6wQZweDemAgAllb4A=
Date: Thu, 9 Oct 2014 07:53:47 +0000
Message-ID: <b315028a386e46dca9abd70b65210bb1@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1411461252-8730-1-git-send-email-jingchang.lu@freescale.com>
 <542E5421.5070708@nvidia.com>
In-Reply-To: <542E5421.5070708@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB466;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(13464003)(41574002)(189002)(199003)(479174003)(377454003)(51704005)(122556002)(40100002)(85306004)(33646002)(2501002)(54356999)(50986999)(76176999)(95666004)(108616004)(99286002)(99396003)(105586002)(107046002)(74316001)(106116001)(106356001)(120916001)(76576001)(101416001)(76482002)(46102003)(80022003)(31966008)(4396001)(20776003)(19580405001)(19580395003)(97736003)(85852003)(2656002)(87936001)(21056001)(66066001)(64706001)(86362001)(92566001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB466;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s997s2xh029053

>-----Original Message-----
>From: Joseph Lo [mailto:josephl@nvidia.com]
>Sent: Friday, October 03, 2014 3:46 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: devicetree@vger.kernel.org; arnd@arndb.de; linux-
>kernel@vger.kernel.org; linux-serial@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org
>Subject: Re: [PATCH] serial: of-serial: add PM suspend/resume support
>
>Hi,
>
>This patch might have a potential issue that cause system hard hung
>immediately when it accesses to registers with no clock. This could happen
>on many chips that mainline kernel supporting with the setting
>"no_console_suspend=1" during suspend time.
>
>On 09/23/2014 04:34 PM, Jingchang Lu wrote:
>> This adds PM suspend/resume support for the of-serial driver to
>> provide power management support on devices attatched to it.
>>
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>> ---
>>   drivers/tty/serial/of_serial.c | 27 +++++++++++++++++++++++++++
>>   1 file changed, 27 insertions(+)
>>
>> diff --git a/drivers/tty/serial/of_serial.c
>> b/drivers/tty/serial/of_serial.c index 27981e2..8bc2563 100644
>> --- a/drivers/tty/serial/of_serial.c
>> +++ b/drivers/tty/serial/of_serial.c
>> @@ -240,6 +240,32 @@ static int of_platform_serial_remove(struct
>platform_device *ofdev)
>>   	return 0;
>>   }
>>
>> +#ifdef CONFIG_PM_SLEEP
>> +static int of_serial_suspend(struct device *dev) {
>> +	struct of_serial_info *info = dev_get_drvdata(dev);
>> +
>> +	serial8250_suspend_port(info->line);
>> +	if (info->clk)
>The fix would be something like this.
>	if (info->clk && console_suspend_enabled)
>
Yes, there will be, I will send a fix on this, thanks!

Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
