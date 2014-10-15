Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaJOGxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:53:11 -0400
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:4992
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751183AbaJOGxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:53:07 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Joseph Lo <josephl@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "peter@hurleysoftware.com" <peter@hurleysoftware.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Topic: [PATCHv4] serial: of-serial: fix up PM ops on no_console_suspend
 and port type
Thread-Index: AQHP55FFIMYR88HhxkeSAEfc0gxGHJwwV92AgABVjuCAAAmnAIAAAQtA
Date: Wed, 15 Oct 2014 06:53:03 +0000
Message-ID: <90749a1246fc4a84bcb7b76994d066e0@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1413276146-20388-1-git-send-email-jingchang.lu@freescale.com>
 <543DC753.4070304@nvidia.com>
 <67564f37252242079bcd4c65827b8352@BL2PR03MB467.namprd03.prod.outlook.com>
 <543E1730.2040108@nvidia.com>
In-Reply-To: <543E1730.2040108@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB467;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(13464003)(199003)(377454003)(479174003)(99286002)(106116001)(76482002)(4396001)(106356001)(120916001)(76576001)(95666004)(74316001)(31966008)(105586002)(33646002)(99396003)(66066001)(19580395003)(19580405001)(64706001)(20776003)(107046002)(86362001)(2501002)(46102003)(80022003)(85852003)(21056001)(122556002)(93886004)(85306004)(101416001)(40100003)(2656002)(87936001)(97736003)(54356999)(108616004)(76176999)(50986999)(92566001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB467;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB498;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9F6rLPc029506

>-----Original Message-----
>From: Joseph Lo [mailto:josephl@nvidia.com]
>Sent: Wednesday, October 15, 2014 2:42 PM
>To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>Cc: peter@hurleysoftware.com; arnd@arndb.de; linux-kernel@vger.kernel.org;
>linux-serial@vger.kernel.org; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on
>no_console_suspend and port type
>
>On 10/15/2014 02:32 PM, Jingchang Lu wrote:
>>> -----Original Message-----
>>> From: Joseph Lo [mailto:josephl@nvidia.com]
>>> Sent: Wednesday, October 15, 2014 9:01 AM
>>> To: Lu Jingchang-B35083; gregkh@linuxfoundation.org
>>> Cc: peter@hurleysoftware.com; arnd@arndb.de;
>>> linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org;
>>> linux-arm-kernel@lists.infradead.org
>>> Subject: Re: [PATCHv4] serial: of-serial: fix up PM ops on
>>> no_console_suspend and port type
>>>
>>> On 10/14/2014 04:42 PM, Jingchang Lu wrote:
>>>> This patch fixes commit 2dea53bf57783f243c892e99c10c6921e956aa7e,
>>>> "serial: of-serial: add PM suspend/resume support", which disables
>>>> the uart clock on suspend, but also causes a hardware hang on
>>>> register access if no_console_suspend command line option is used.
>>>>
>>>> Also, not every of_serial device is an 8250 port, so the serial8250
>>>> suspend/resume functions should only be applied to a real 8250 port.
>>>>
>>>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>>>
>>> If you can make sure this patch can build without include
>>> <linux/console.h>, then this patch
>> The build passes on my cloned linux-next tree, include next-20141014,
>> but is required on my another kernel-3.12+ based tree, then I didn't
>> add this header file when upstream.
>> Is the build broken on your source tree, and is the tree latest?
>> If the header is needed, I will add it.
>I tested it on next-20141013 and k3.14, both of them need the fix. I can
>check it again against the latest linux-next tree later. Thanks.
Sorry, it is needed indeed, I have forgotten enable the PM in the next tree
due the lack of PM supporting of my board, I test the function on my 3.12 tree.
I will add it right now.

Best Regards,
Jingchang
>
>-Joseph
>
>> Thanks.
>>
>> Best Regards,
>> Jingchang
>>>
>>> Tested-by: Joseph Lo <josephl@nvidia.com>
>>>
>>> And thanks for your fix.
>>>
>>>> ---
>>>> changes in v4:
>>>>    separate 8250 port suspend/resume from of_serial_suspend/resume.
>>>>
>>>> changes in v3:
>>>>    fix up point reference and deference.
>>>>
>>>> changes in v2:
>>>>    add switch selection on uart type.
>>>>
>>>>    drivers/tty/serial/of_serial.c | 52
>>> ++++++++++++++++++++++++++++++++++++------
>>>>    1 file changed, 45 insertions(+), 7 deletions(-)
>>>>
>>>> diff --git a/drivers/tty/serial/of_serial.c
>>>> b/drivers/tty/serial/of_serial.c index 8bc2563..5281f8f 100644
>>>> --- a/drivers/tty/serial/of_serial.c
>>>> +++ b/drivers/tty/serial/of_serial.c
>>>> @@ -241,13 +241,48 @@ static int of_platform_serial_remove(struct
>>> platform_device *ofdev)
>>>>    }
>>>>
>>>>    #ifdef CONFIG_PM_SLEEP
>>>> -static int of_serial_suspend(struct device *dev)
>>>> +#ifdef CONFIG_SERIAL_8250
>>>> +static void of_serial_suspend_8250(struct of_serial_info *info)
>>>>    {
>>>> -	struct of_serial_info *info = dev_get_drvdata(dev);
>>>> +	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
>>>> +	struct uart_port *port = &port8250->port;
>>>>
>>>>    	serial8250_suspend_port(info->line);
>>>> -	if (info->clk)
>>>> +	if (info->clk && (!uart_console(port) || console_suspend_enabled))
>>>>    		clk_disable_unprepare(info->clk);
>>>> +}
>>>> +
>>>> +static void of_serial_resume_8250(struct of_serial_info *info) {
>>>> +	struct uart_8250_port *port8250 = serial8250_get_port(info->line);
>>>> +	struct uart_port *port = &port8250->port;
>>>> +
>>>> +	if (info->clk && (!uart_console(port) || console_suspend_enabled))
>>>> +		clk_prepare_enable(info->clk);
>>>> +
>>>> +	serial8250_resume_port(info->line);
>>>> +}
>>>> +#else
>>>> +static inline void of_serial_suspend_8250(struct of_serial_info
>>>> +*info) { }
>>>> +
>>>> +static inline void of_serial_resume_8250(struct of_serial_info
>>>> +*info) { } #endif
>>>> +
>>>> +static int of_serial_suspend(struct device *dev) {
>>>> +	struct of_serial_info *info = dev_get_drvdata(dev);
>>>> +
>>>> +	switch(info->type) {
>>>> +	case PORT_8250 ... PORT_MAX_8250:
>>>> +		of_serial_suspend_8250(info);
>>>> +		break;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>>
>>>>    	return 0;
>>>>    }
>>>> @@ -256,10 +291,13 @@ static int of_serial_resume(struct device *dev)
>>>>    {
>>>>    	struct of_serial_info *info = dev_get_drvdata(dev);
>>>>
>>>> -	if (info->clk)
>>>> -		clk_prepare_enable(info->clk);
>>>> -
>>>> -	serial8250_resume_port(info->line);
>>>> +	switch(info->type) {
>>>> +	case PORT_8250 ... PORT_MAX_8250:
>>>> +		of_serial_resume_8250(info);
>>>> +		break;
>>>> +	default:
>>>> +		break;
>>>> +	}
>>>>
>>>>    	return 0;
>>>>    }
>>>>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
