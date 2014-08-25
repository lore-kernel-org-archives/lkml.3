Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbaHYRea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:34:30 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:7207
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbaHYRe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:34:29 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Sitsofe Wheeler <sitsofe@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Topic: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
Thread-Index: AQHPu6pIm2pwB6mvJU2s1pqxWk+oepvhGNoAgACFPqA=
Date: Mon, 25 Aug 2014 17:34:27 +0000
Message-ID: <cf94fd58947d4c5aa6d0d369c1126d7f@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <20140819123655.GC12160@sucs.org> <20140825093648.GB5046@mwanda>
In-Reply-To: <20140825093648.GB5046@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e0:ee43::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(164054003)(377454003)(189002)(199003)(13464003)(74502001)(4396001)(99396002)(20776003)(74662001)(19580405001)(81542001)(86612001)(87936001)(31966008)(64706001)(83322001)(19580395003)(33646002)(92566001)(76482001)(85852003)(81342001)(86362001)(80022001)(50986999)(2656002)(79102001)(21056001)(76176999)(46102001)(90102001)(83072002)(77982001)(101416001)(77096002)(74316001)(99286002)(95666004)(54356999)(106116001)(85306004)(105586002)(106356001)(108616004)(107046002)(76576001)(24736002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Monday, August 25, 2014 2:37 AM
> To: Sitsofe Wheeler
> Cc: KY Srinivasan; Greg Kroah-Hartman; Jason Wang; linux-
> kernel@vger.kernel.org; David S. Miller; Daniel Borkmann;
> netdev@vger.kernel.org; devel@linuxdriverproject.org; Haiyang Zhang
> Subject: Re: [hyperv] BUG at drivers/hv/channel.c:462 while changing MTU
> 
> The code here is:
> 
> drivers/hv/channel.c
>    460          BUG_ON(ret != 0);
>    461          t = wait_for_completion_timeout(&info->waitevent, 5*HZ);
>    462          BUG_ON(t == 0);
> 
> So it calls BUG_ON() if the teardown takes more than 5 seconds.  It's most
> likely that there is a race condition somewhere.  It's also possible that it's just
> taking longer than 5 seconds for some odd reason and the bug would go
> away if we raised it to 60 seconds.
> 
> BUG_ON() after 5 seconds seems like a very aggressive thing.

Dan,

I am going to audit all BUG_ON() instances.

Thanks,

K. Y
> 
> regards,
> dan carpenter

