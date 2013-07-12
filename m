Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482Ab3GLVIz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 17:08:55 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:56229
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965401Ab3GLVIx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 17:08:53 -0400
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -2
X-BigFish: PS-2(zz98dI9371I542I1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1d07h1d0ch1d2eh1d3fh1de9h1dfeh1dffh1e1dh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:NSPM;SFS:(13464003)(377454003)(189002)(199002)(24454002)(51704005)(54356001)(79102001)(76576001)(69226001)(59766001)(51856001)(76482001)(49866001)(65816001)(63696002)(74876001)(46102001)(4396001)(74316001)(47446002)(83072001)(54316002)(31966008)(81342001)(74502001)(66066001)(76786001)(74366001)(80022001)(50986001)(74662001)(53806001)(56816003)(16406001)(47976001)(81542001)(74706001)(77096001)(47736001)(76796001)(77982001)(33646001)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:SN2PR03MB062;H:SN2PR03MB061.namprd03.prod.outlook.com;CLIP:98.110.61.163;RD:InfoNoRecords;MX:1;A:1;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Ben Hutchings <ben@decadent.org.uk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Stable <stable@vger.kernel.org>
Subject: RE: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
Thread-Topic: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
Thread-Index: AQHOfwXMySuJZjEOX0aRTZWPqcisBplhe3+AgAANHNA=
Date: Fri, 12 Jul 2013 21:07:19 +0000
Message-ID: <a53af503f3934a6bb8442e97de0d5ddc@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1373637292-25855-1-git-send-email-kys@microsoft.com>
 <1373637375-25936-1-git-send-email-kys@microsoft.com>
 <20130712201703.GB7729@decadent.org.uk>
In-Reply-To: <20130712201703.GB7729@decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
x-forefront-prvs: 0905A6B2C7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB062.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%DECADENT.ORG.UK$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14MLTC104.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14MLTC104.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(377454003)(13464003)(51704005)(189002)(24454002)(74876001)(59766001)(53806001)(74366001)(76786001)(54356001)(47736001)(33646001)(51856001)(47446002)(56776001)(20776003)(74316001)(47776003)(74662001)(66066001)(31966008)(46406003)(65816001)(79102001)(56816003)(77982001)(76576001)(47976001)(74502001)(80022001)(81342001)(16676001)(69226001)(50986001)(81542001)(50466002)(63696002)(76482001)(4396001)(49866001)(74706001)(23726002)(76796001)(46102001)(6806004)(77096001)(44976005)(54316002)(83072001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB037;H:TK5EX14MLTC104.redmond.corp.microsoft.com;CLIP:131.107.125.37;RD:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0905A6B2C7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Ben Hutchings [mailto:ben@decadent.org.uk]
> Sent: Friday, July 12, 2013 4:17 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Stable
> Subject: Re: [PATCH 1/2] Drivers: hv: balloon: Fix a bug in the hot-add code
> 
> On Fri, Jul 12, 2013 at 06:56:14AM -0700, K. Y. Srinivasan wrote:
> > As we hot-add 128 MB chunks of memory, we wait to ensure that the memory
> > is onlined before attempting to hot-add the next chunk. If the udev rule for
> > memory hot-add is not executed within the allowed time, we would rollback
> the
> > state and abort further hot-add. Since the hot-add has succeeded and the only
> > failure is that the memory is not onlined within the allowed time, we should not
> > be rolling back the state. Fix this bug.
> [...]
> >  		/*
> >  		 * Wait for the memory block to be onlined.
> >  		 */
> > -		t = wait_for_completion_timeout(&dm_device.ol_waitevent,
> 5*HZ);
> > -		if (t == 0) {
> > -			pr_info("hot_add memory timedout\n");
> > -			has->ha_end_pfn -= HA_CHUNK;
> > -			has->covered_end_pfn -=  processed_pfn;
> > -			break;
> > -		}
> > +		wait_for_completion_timeout(&dm_device.ol_waitevent,
> 5*HZ);
> >
> >  	}
> >
> 
> Well now it might look like a bug that you don't test the result
> of wait_for_completion_timeout().  Maybe update the comment to
> explain why it's OK to continue anyway?

I put in the comment in the patch explaining why it is ok to continue. To reiterate,
it is ok to continue because hot add has succeeded. More importantly, what I was
doing earlier - rolling back the state when in fact hot add had succeeded was incorrect.

Regards,

K. Y
> 
> Ben.
> 
> --
> Ben Hutchings
> We get into the habit of living before acquiring the habit of thinking.
>                                                               - Albert Camus
> 


