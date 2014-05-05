Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbaEEVAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:00:41 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:24617
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753312AbaEEVAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:00:39 -0400
From: Bryan Evenson <bevenson@melinkcorp.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
Thread-Topic: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
Thread-Index: AQHPaJ/f7r6faF+fSUiFpt/iOZTHKZsyc8iw
Date: Mon, 5 May 2014 20:44:48 +0000
Message-ID: <ab4d2f575d33406f996a119e6c433a79@BLUPR05MB037.namprd05.prod.outlook.com>
References: <55cab9fba2ea4eed8f73591b37cc874b@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 01E4B0730070E201E4B1C0
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(377454003)(51704005)(199002)(189002)(81542001)(2656002)(85852003)(83072002)(99396002)(92566001)(33646001)(21056001)(86362001)(74316001)(101416001)(81342001)(77982001)(19580405001)(19580395003)(83322001)(99286001)(76576001)(80022001)(54356999)(87936001)(76482001)(4396001)(66066001)(50986999)(79102001)(20776003)(76176999)(46102001)(74502001)(74662001)(31966008)(64706001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB039;H:BLUPR05MB037.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bevenson@melinkcorp.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: melinkcorp.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris,

> -----Original Message-----
> From: Boris BREZILLON [mailto:boris.brezillon@free-electrons.com]
> Sent: Monday, May 05, 2014 4:23 PM
> To: Bryan Evenson
> Cc: Andrew Victor; Nicolas Ferre; Jean-Christophe Plagniol-Villard; linux-arm-
> kernel@lists.infradead.org; Alessandro Zummo; rtc-
> linux@googlegroups.com; linux-kernel@vger.kernel.org; Boris BREZILLON
> Subject: [PATCH] rtc: rtc-at91rm9200: fix lost ACKUPD interrupt
> 
> If an alarm interrupt raises just after the CR register is written and before the
> ACKUPD is unmasked the ACKUPD bit might be cleaned up without waking
> up the waiting thread.
> 
> Unmask the ACKUPD interrupt before writing the CR register so that the
> ACKUPD cannot be lost.
> 
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
> ---
> Hello Bryan,
> 
> Could you try to apply this patch and tell me if it fixes your bug ?
> 

I'll incorporate the patch and see what happens.  I'll be able to let you know the results tomorrow morning.

Regards,
Bryan

> Best Regards,
> 
> Boris
> 
>  drivers/rtc/rtc-at91rm9200.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c index
> 3281c90..c16c423 100644
> --- a/drivers/rtc/rtc-at91rm9200.c
> +++ b/drivers/rtc/rtc-at91rm9200.c
> @@ -163,9 +163,9 @@ static int at91_rtc_settime(struct device *dev, struct
> rtc_time *tm)
> 
>  	/* Stop Time/Calendar from counting */
>  	cr = at91_rtc_read(AT91_RTC_CR);
> +	at91_rtc_write_ier(AT91_RTC_ACKUPD);
>  	at91_rtc_write(AT91_RTC_CR, cr | AT91_RTC_UPDCAL |
> AT91_RTC_UPDTIM);
> 
> -	at91_rtc_write_ier(AT91_RTC_ACKUPD);
>  	wait_for_completion(&at91_rtc_updated);	/* wait for ACKUPD
> interrupt */
>  	at91_rtc_write_idr(AT91_RTC_ACKUPD);
> 
> --
> 1.8.3.2

