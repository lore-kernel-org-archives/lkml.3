Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbaHFRZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:25:18 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:20220
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756471AbaHFRZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:25:16 -0400
From: KY Srinivasan <kys@microsoft.com>
To: Jeff Leung <jleung@v10networks.ca>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of sendbuf
 region to support ws2008r2
Thread-Topic: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of
 sendbuf region to support ws2008r2
Thread-Index: AQHPsZkZsm71hIuLPkGAqf919eqKKpvD0cMAgAAAZwA=
Date: Wed, 6 Aug 2014 17:25:11 +0000
Message-ID: <17897053acd444eca0c73b08961e5f80@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1407348660-6844-1-git-send-email-kys@microsoft.com>
 <A70AC0C1B7E7FD478A6BF19705461AA011098B@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <A70AC0C1B7E7FD478A6BF19705461AA011098B@IMBER.smb.curriegrad2004.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.135.110.52]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(51704005)(377454003)(13464003)(199002)(189002)(107886001)(19580395003)(19580405001)(81342001)(95666004)(85852003)(15202345003)(83072002)(74316001)(76576001)(31966008)(20776003)(2201001)(92566001)(74662001)(85306004)(66066001)(76482001)(77982001)(99286002)(106116001)(80022001)(83322001)(105586002)(101416001)(2656002)(106356001)(87936001)(64706001)(15975445006)(107046002)(79102001)(81542001)(46102001)(33646002)(50986999)(76176999)(21056001)(54356999)(86362001)(86612001)(77096002)(4396001)(74502001)(99396002)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0711;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jeff Leung [mailto:jleung@v10networks.ca]
> Sent: Wednesday, August 6, 2014 10:19 AM
> To: KY Srinivasan; davem@davemloft.net; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: RE: [PATCH 1/1] Drivers: net-next: hyperv: Adjust the size of
> sendbuf region to support ws2008r2
> 
> > WS2008R2 is a supported platform and it turns out that the maximum
> sendbuf
> > size that ws2008R2 can support is only 15MB. Make the necessary
> > adjustment.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/net/hyperv/hyperv_net.h |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> > index 40ba1ef..459b823 100644
> > --- a/drivers/net/hyperv/hyperv_net.h
> > +++ b/drivers/net/hyperv/hyperv_net.h
> > @@ -584,7 +584,7 @@ struct nvsp_message {
> >
> >  #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*16)
> 	/* 16MB
> > */
> >  #define NETVSC_RECEIVE_BUFFER_SIZE_LEGACY	(1024*1024*15)  /*
> 15MB
> */
> > -#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 *
> 16)   /* 16MB */
> > +#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 *
> 15)   /* 15MB */
> 
> Would it be possible to use separate ifdefs depending on the version of the
> Hyper-V host so we can maintain the 16MB buffer for hosts that support it
> and leave it at 15MB for hosts that don't support that large of a buffer?

We could certainly do that. For the receive buffers, we actually size them based on the host.
For sendbuf, the performance difference between 15M and 16M is not measurable. I had initially
chosen 16MB to match with the receive buffer size. Since there was no perf advantage, I chose to
set the sendbuf size to 15M to work on all supported hosts.

K. Y 
> 
> >  #define NETVSC_INVALID_INDEX			-1
> >
> >
> > --
> > 1.7.4.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org More majordomo
> info
> > at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

