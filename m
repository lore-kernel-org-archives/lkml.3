Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab3GYLVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:21:03 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:7910 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648Ab3GYLVA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:21:00 -0400
X-Forefront-Antispam-Report: CIP:131.107.125.8;KIP:(null);UIP:(null);IPV:NLI;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:autodiscover.service.exchange.microsoft.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bh8275dhz2fh2a8h683h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(24454002)(13464003)(189002)(199002)(377454003)(51704005)(19580395003)(51856001)(63696002)(74706001)(66066001)(46102001)(83322001)(76796001)(69226001)(16406001)(76576001)(56776001)(81342001)(31966008)(74876001)(77982001)(74316001)(47736001)(59766001)(47976001)(80022001)(74366001)(76482001)(53806001)(74502001)(81542001)(56816003)(50986001)(74662001)(65816001)(19580405001)(47446002)(54316002)(83072001)(49866001)(79102001)(4396001)(33646001)(77096001)(76786001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:173.61.119.57;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>, Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Thread-Topic: [PATCH] Drivers: hv: remove HV_DRV_VERSION
Thread-Index: AQHOXE8x4taQvJKyL0KIqc/Iu67A7Zl1MdMAgABnBBA=
Date: Thu, 25 Jul 2013 11:19:32 +0000
Message-ID: <cd681dca6d694f2a862612a3522c4373@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1369819747-6218-1-git-send-email-olaf@aepfle.de>
 <20130725051004.GA21893@kroah.com>
In-Reply-To: <20130725051004.GA21893@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.61.119.57]
x-forefront-prvs: 0918748D70
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-OriginatorOrg: microsoft.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, July 25, 2013 1:10 AM
> To: Olaf Hering
> Cc: KY Srinivasan; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Drivers: hv: remove HV_DRV_VERSION
> 
> On Wed, May 29, 2013 at 11:29:07AM +0200, Olaf Hering wrote:
> > Remove HV_DRV_VERSION, it has no meaning for upstream drivers.
> >
> > Initially it was supposed to show the "Linux Integration Services"
> > version, now it is not in sync anymore with the out-of-tree drivers
> > available from the MSFT website.
> >
> > The only place where a version string is still required is the KVP
> > command "IntegrationServicesVersion" which is handled by
> > tools/hv/hv_kvp_daemon.c. To satisfy such KVP request from the host pass
> > the current string to the daemon during KVP userland registration.
> >
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hid/hid-hyperv.c        |  1 -
> >  drivers/hv/hv_balloon.c         |  1 -
> >  drivers/hv/hv_kvp.c             |  2 ++
> >  drivers/hv/hv_util.c            |  1 -
> >  drivers/hv/vmbus_drv.c          |  1 -
> >  drivers/net/hyperv/netvsc_drv.c |  2 --
> >  drivers/scsi/storvsc_drv.c      |  1 -
> >  drivers/video/hyperv_fb.c       |  1 -
> >  include/linux/hyperv.h          | 21 ---------------------
> >  9 files changed, 2 insertions(+), 29 deletions(-)
> 
> KY, what happened to this patch?  Any ack/nak for it?
> 
> thanks,
> 
> greg k-h
> 
> 



