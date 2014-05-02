Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaEBPAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:00:09 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:49979
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751650AbaEBPAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:00:04 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>, Jim Davis <jim.epost@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Topic: randconfig build error with next-20140502, in
 drivers/net/hyperv/netvsc_drv.c
Thread-Index: AQHPZg5GVL3WjyEfhE21zJeJ45+lKJstXUQAgAAEiMA=
Date: Fri, 2 May 2014 14:59:58 +0000
Message-ID: <f49938e3920d4e5e9088ccd1de92f69b@BY2PR03MB299.namprd03.prod.outlook.com>
References: <CA+r1ZhhAdRwEFE3u4E1QQiCSa6Cz5Onhy1iVJHhzB4dUiEOL4g@mail.gmail.com>
 <91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
In-Reply-To: <91a4eac99889460f91f619385208cbca@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(199002)(164054003)(13464003)(51704005)(189002)(1511001)(92566001)(87936001)(64706001)(20776003)(79102001)(19580405001)(31966008)(74502001)(74662001)(2656002)(80976001)(83322001)(19580395003)(77096999)(54356999)(86362001)(76176999)(50986999)(101416001)(4396001)(85852003)(83072002)(99396002)(99286001)(86612001)(76576001)(76482001)(81342001)(66066001)(77982001)(33646001)(74316001)(80022001)(46102001)(81542001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s42F0IPP020335



> -----Original Message-----
> From: Haiyang Zhang
> Sent: Friday, May 2, 2014 7:42 AM
> To: Jim Davis; Stephen Rothwell; linux-next; linux-kernel; KY Srinivasan;
> devel@linuxdriverproject.org; netdev
> Subject: RE: randconfig build error with next-20140502, in
> drivers/net/hyperv/netvsc_drv.c
> 
> 
> 
> > -----Original Message-----
> > From: Jim Davis [mailto:jim.epost@gmail.com]
> > Sent: Friday, May 2, 2014 9:56 AM
> > To: Stephen Rothwell; linux-next; linux-kernel; KY Srinivasan; Haiyang
> > Zhang; devel@linuxdriverproject.org; netdev
> > Subject: randconfig build error with next-20140502, in
> > drivers/net/hyperv/netvsc_drv.c
> >
> > Building with the attached random configuration file,
> >
> > drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_recv_callbackâ€™:
> > drivers/net/hyperv/netvsc_drv.c:648:11: error: â€˜struct net_deviceâ€™ has
> > no member  named â€˜real_num_rx_queuesâ€™
> >         net->real_num_rx_queues);
> >            ^
> > In file included from drivers/net/hyperv/netvsc_drv.c:26:0:
> > drivers/net/hyperv/netvsc_drv.c: In function â€˜netvsc_probeâ€™:
> > drivers/net/hyperv/netvsc_drv.c:832:32: error: â€˜struct net_deviceâ€™ has
> > no member named â€˜real_num_rx_queuesâ€™
> >     net->real_num_tx_queues, net->real_num_rx_queues);
> >                                 ^
> > include/linux/device.h:1080:58: note: in definition of macro â€˜dev_infoâ€™
> >  #define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
> >                                                           ^
> > make[3]: *** [drivers/net/hyperv/netvsc_drv.o] Error 1
> 
> real_num_rx_queues is defined in "include/linux/netdevice.h":
> It requires CONFIG_SYSFS flag, which is enabled by default, but not set in
> your config file.
> 
> Could you use default config and add hyperv drivers, then try again?

Haiyang,

That is the point - the code must compile correctly for all possible configurations.
You will want to protect the dependencies appropriately.

K. Y
> 
> Thanks,
> - Haiyang
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
