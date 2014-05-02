Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaEBPPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:15:11 -0400
Received: from mail-by1on0157.outbound.o365filtering.com ([207.46.101.157]:64639
	"EHLO na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990AbaEBPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:15:09 -0400
X-Greylist: delayed 1953 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2014 11:15:08 EDT
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jim Davis <jim.epost@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Topic: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Index: AQHPZg5VELXjQQ2rFUCGAjzcri4hopstWxlw
Date: Fri, 2 May 2014 14:42:06 +0000
Message-ID: <91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
In-Reply-To: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(199002)(189002)(13464003)(164054003)(377454003)(6806004)(19580395003)(76482001)(79102001)(46102001)(80976001)(81686001)(19580405001)(81816001)(83322001)(76796001)(44976005)(87266001)(85306002)(47776003)(31966008)(20776003)(76786001)(77982001)(1511001)(69226001)(33646001)(74502001)(50466002)(80022001)(66066001)(74876001)(90146001)(83072002)(81342001)(94946001)(93516002)(93136001)(94316002)(92566001)(2009001)(97736001)(95666003)(97336001)(97186001)(95416001)(23676002)(81542001)(4396001)(87936001)(74706001)(53806002)(50986002)(86612001)(85852003)(84676001)(74662001)(2656002)(74366001)(63696004)(47446003)(56776002)(54316003)(49866002)(98676001)(54356002)(59766002)(51856002)(47976003)(56816006)(99396002)(47736002)(65816002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB591;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Exchange-Antispam-Report-Test: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 019919A9E4
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s42FFKo4020446



> -----Original Message-----
> From: Jim Davis [mailto:jim.epost@gmail.com]
> Sent: Friday, May 2, 2014 9:56 AM
> To: Stephen Rothwell; linux-next; linux-kernel; KY Srinivasan; Haiyang
> Zhang; devel@linuxdriverproject.org; netdev
> Subject: randconfig build error with next-20140502, in
> drivers/net/hyperv/netvsc_drv.c
> 
> Building with the attached random configuration file,
> 
> drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_recv_callbackâ€™:
> drivers/net/hyperv/netvsc_drv.c:648:11: error: â€˜struct net_deviceâ€™ has
> no member
>  named â€˜real_num_rx_queuesâ€™
>         net->real_num_rx_queues);
>            ^
> In file included from drivers/net/hyperv/netvsc_drv.c:26:0:
> drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_probeâ€™:
> drivers/net/hyperv/netvsc_drv.c:832:32: error: â€˜struct net_deviceâ€™ has
> no member named â€˜real_num_rx_queuesâ€™
>     net->real_num_tx_queues, net->real_num_rx_queues);
>                                 ^
> include/linux/device.h:1080:58: note: in definition of macro â€˜dev_infoâ€™
>  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
>                                                           ^
> make[3]: *** [drivers/net/hyperv/netvsc_drv.o] Error 1

real_num_rx_queues is defined in "include/linux/netdevice.h":
It requires CONFIG_SYSFS flag, which is enabled by default, but not set in 
your config file.

Could you use default config and add hyperv drivers, then try again?

Thanks,
- Haiyang

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
