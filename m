Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbaEFLgf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:36:35 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:59219
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbaEFLge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:36:34 -0400
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
Thread-Index: AQHPaJ/f7r6faF+fSUiFpt/iOZTHKZsyyC8Q
Date: Tue, 6 May 2014 11:36:30 +0000
Message-ID: <7bc7c23d3bd541b2a021065f9fed174e@BLUPR05MB037.namprd05.prod.outlook.com>
References: <55cab9fba2ea4eed8f73591b37cc874b@BLUPR05MB037.namprd05.prod.outlook.com>
 <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1399321388-15148-1-git-send-email-boris.brezillon@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-vipre-scanned: 004D47DA0070EC004D4927
x-originating-ip: [98.100.91.242]
x-forefront-prvs: 0203C93D51
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(377454003)(51704005)(13464003)(21056001)(76576001)(87936001)(101416001)(99396002)(83072002)(4396001)(85852003)(81342001)(33646001)(81542001)(2656002)(76482001)(83322001)(19580405001)(19580395003)(46102001)(77982001)(76176999)(50986999)(54356999)(64706001)(20776003)(79102001)(66066001)(92566001)(80022001)(74502001)(31966008)(74662001)(74316001)(86362001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR05MB040;H:BLUPR05MB037.namprd05.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
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

I tried the patch and it didn't help.  I still have the same issue.  Do you see this problem on your end?  Is there debug output that would be helpful to see?

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

