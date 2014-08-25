Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbaHYOxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:53:37 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:41706
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932667AbaHYOxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:53:36 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Richard Weinberger <richard.weinberger@gmail.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Topic: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Index: AQHPu6pIm2pwB6mvJU2s1pqxWk+oepvYcg4AgABn54CACFLTAIAAQ+1w
Date: Mon, 25 Aug 2014 14:53:32 +0000
Message-ID: <2c4d3b36d8be4fbf884d78c7507a29af@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140819123655.GC12160@sucs.org>
	<8dcf334714c44eeda54ecb129479719b@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
	<20140820034116.GA3407@sucs.org>
 <CAFLxGvx5_JSb7sRPXY01d+eNJ4p4fk=MySGyui91KNbdyLyQ_g@mail.gmail.com>
In-Reply-To: <CAFLxGvx5_JSb7sRPXY01d+eNJ4p4fk=MySGyui91KNbdyLyQ_g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(13464003)(51704005)(199003)(189002)(377454003)(164054003)(24454002)(83322001)(19580405001)(81342001)(21056001)(19580395003)(81542001)(101416001)(99396002)(76176999)(77096002)(74316001)(83072002)(85852003)(87936001)(76576001)(106356001)(86362001)(33646002)(92566001)(105586002)(80022001)(106116001)(66066001)(64706001)(99286002)(108616004)(20776003)(95666004)(74662001)(31966008)(74502001)(76482001)(85306004)(90102001)(77982001)(79102001)(86612001)(54356999)(50986999)(107046002)(93886004)(4396001)(2656002)(46102001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0709;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7PErhCf027425



> -----Original Message-----
> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Monday, August 25, 2014 3:48 AM
> To: Sitsofe Wheeler
> Cc: Haiyang Zhang; KY Srinivasan; Greg Kroah-Hartman;
> devel@linuxdriverproject.org; linux-kernel@vger.kernel.org; Jason Wang;
> Daniel Borkmann; David S. Miller; netdev@vger.kernel.org
> Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
> 
>  via
> 
> 
> On Wed, Aug 20, 2014 at 5:41 AM, Sitsofe Wheeler <sitsofe@gmail.com>
> wrote:
> > Aug 20 04:04:41 ubuntuhv kernel: [    9.230399] random: nonblocking pool is
> initialized
> > Aug 20 04:04:41 ubuntuhv kernel: [   10.338487] EXT4-fs (sda1): re-
> mounted. Opts: errors=remount-ro
> > Aug 20 04:04:41 ubuntuhv kernel: [   11.099094] hv_storvsc vmbus_0_1:
> cmd 0x85 scsi status 0x2 srb status 0x6
> > Aug 20 04:04:41 ubuntuhv kernel: [   11.099901] hv_storvsc vmbus_0_1:
> cmd 0x85 scsi status 0x2 srb status 0x6
> > Aug 20 04:04:43 ubuntuhv kernel: [   12.999830] psmouse serio1: trackpoint:
> IBM TrackPoint firmware: 0x01, buttons: 0/0
> > Aug 20 03:55:47 ubuntuhv kernel: [   13.003659] input: TPPS/2 IBM
> TrackPoint as /devices/platform/i8042/serio1/input/input4
> > Aug 20 03:57:28 ubuntuhv kernel: [  113.711832] hv_netvsc vmbus_0_14:
> > net device safe to remove Aug 20 03:57:28 ubuntuhv kernel: [
> > 113.713882] hv_netvsc: hv_netvsc channel opened successfully Aug 20
> > 03:57:29 ubuntuhv kernel: [  114.961312] hv_netvsc vmbus_0_14: Send
> > section size: 6144, Section count:2560 Aug 20 03:57:29 ubuntuhv
> > kernel: [  114.962711] hv_netvsc vmbus_0_14: Device MAC
> > 00:15:5d:6f:02:af link state up Aug 20 03:57:34 ubuntuhv kernel: [
> > 120.027718] hv_netvsc vmbus_0_14: net device safe to remove Aug 20
> > 03:57:34 ubuntuhv kernel: [  120.030047] hv_netvsc: hv_netvsc channel
> > opened successfully Aug 20 03:57:34 ubuntuhv kernel: [  120.035422]
> hv_netvsc vmbus_0_14 eth0: unable to establish receive buffer's gpadl Aug
> 20 03:57:34 ubuntuhv kernel: [  120.039778] hv_netvsc vmbus_0_14 eth0:
> unable to connect to NetVSP - 4 Aug 20 03:57:34 ubuntuhv kernel: [
> 120.039818] ------------[ cut here ]------------ Aug 20 03:57:34 ubuntuhv kernel:
> [  120.039832] kernel BUG at drivers/hv/channel.c:504!
> 
> This is one is also a rude BUG_ON:
>         ret = vmbus_post_msg(msg, sizeof(struct
> vmbus_channel_close_channel));
> 
>         BUG_ON(ret != 0);
> 
> vmbus_post_msg() hv_post_message() can easily return !0.
> i.e. if this kmalloc() fails:
>         addr = (unsigned long)kmalloc(sizeof(struct aligned_input),
> GFP_ATOMIC);
>         if (!addr)
>                 return -ENOMEM;

I will submit a patch to handle this case. I suspect though that the original ASSERT at channel.c (line 504)
is not related to kmalloc failing in vmbus_post_msg(). I will also look at that issue as well.

Regards,

K. Y
> 
> --
> Thanks,
> //richard
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
