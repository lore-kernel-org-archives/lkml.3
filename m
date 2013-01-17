Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3AQVbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 16:31:44 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.23]:47867
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3AQVbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 16:31:42 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT003.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 19/28] Drivers: hv: Add code to distribute channel
 interrupt load
Thread-Topic: [PATCH 19/28] Drivers: hv: Add code to distribute channel
 interrupt load
Thread-Index: AQHNz89/4hIcDHGXNUiGiDxXIWeDXphONNoAgAAcHVA=
Date: Thu, 17 Jan 2013 21:28:55 +0000
Message-ID: <c99da99322484c938bfaea64d1606c2a@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-19-git-send-email-kys@microsoft.com>
 <20130117193834.GA21956@kroah.com>
In-Reply-To: <20130117193834.GA21956@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [66.235.28.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC103.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC103.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(24454001)(13464002)(51704002)(50986001)(50466001)(49866001)(47736001)(79102001)(56776001)(33646001)(47976001)(4396001)(46406002)(6806001)(56816002)(46102001)(54316002)(5343635001)(23726001)(51856001)(59766001)(16676001)(47446002)(44976002)(77982001)(31966008)(76482001)(47776002)(53806001)(74662001)(74502001)(54356001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB019;H:TK5EX14MLTC103.redmond.corp.microsoft.com;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0729050452
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, January 17, 2013 2:39 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH 19/28] Drivers: hv: Add code to distribute channel interrupt
> load
> 
> On Sat, Dec 01, 2012 at 06:46:50AM -0800, K. Y. Srinivasan wrote:
> > +/*
> > + * This is an array of channels (devices) that are performance critical.
> > + * We attempt to distribute the interrupt load for these devices across
> > + * all available CPUs.
> > + */
> > +static const uuid_le hp_devs[] = {
> > +	/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
> > +	/* IDE */
> > +	{
> > +		.b = {
> > +			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> > +			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> > +		}
> > +	},
> > +	/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
> > +	/* Storage - SCSI */
> > +	{
> > +		.b  = {
> > +			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
> > +			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
> > +		}
> > +	},
> > +	/* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
> > +	/* Network */
> > +	{
> > +		.b = {
> > +			0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
> > +			0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
> > +		}
> > +	},
> > +
> > +};
> 
> You are now duplicating these "ids" in different places in the kernel,
> perhaps you should put them in one place (hyperv.h?) and then reference
> them that way?  It's like a device id for pci, once you use it in two
> places, it goes into pci_ids.h.
> 
> I'm not going to reject this patch, but can you please do this in a
> follow-on patch?

Thanks Greg. Will do.

Regards,

K. Y

> 
> thanks,
> 
> greg k-h
> 


