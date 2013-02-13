Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab3BMRLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:11:16 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.30]:19334
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760088Ab3BMRLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:11:14 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT004.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -3
X-BigFish: PS-3(zzbb2dI98dI9371I542I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h19ceh9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Topic: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
 delivering VMBUS interrupts
Thread-Index: AQHOBHqGdmZWmCfA3EOMQRE9yVbBN5htMw+AgAnGt4CAADNcoIAA1naAgAAC4FA=
Date: Wed, 13 Feb 2013 17:08:45 +0000
Message-ID: <c31482583b394bfcaa16b76a63c413fe@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1360164359-12273-1-git-send-email-kys@microsoft.com>
 <20130206191313.GA1470@kroah.com> <511ADEB7.6080909@zytor.com>
 <ae14ef66af2d4206baf4ccb382fc4205@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130213162211.GA21253@kroah.com>
In-Reply-To: <20130213162211.GA21253@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.110.61.163]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%corpf5vips-237160.customer.frontbridge.com$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC106.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC106.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(377454001)(13464002)(189002)(199002)(24454001)(479174001)(51704002)(31966008)(44976002)(74662001)(53806001)(46102001)(77982001)(47776003)(5343655001)(76482001)(49866001)(16676001)(54316002)(20776003)(54356001)(50986001)(65816001)(47976001)(50466001)(56776001)(59766001)(51856001)(63696002)(6806001)(47736001)(4396001)(80022001)(74502001)(79102001)(47446002)(33646001)(46406002)(23726001)(66066001)(56816002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB020;H:TK5EX14HUBC106.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 07562C22DA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, February 13, 2013 11:22 AM
> To: KY Srinivasan
> Cc: H. Peter Anvin; x86@kernel.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com; bp@alien8.de
> Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> delivering VMBUS interrupts
> 
> On Wed, Feb 13, 2013 at 02:07:52PM +0000, KY Srinivasan wrote:
> >
> >
> > > -----Original Message-----
> > > From: H. Peter Anvin [mailto:hpa@zytor.com]
> > > Sent: Tuesday, February 12, 2013 7:31 PM
> > > To: Greg KH
> > > Cc: KY Srinivasan; x86@kernel.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > jasowang@redhat.com; tglx@linutronix.de; JBeulich@suse.com;
> bp@alien8.de
> > > Subject: Re: [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for
> > > delivering VMBUS interrupts
> > >
> > > On 02/06/2013 11:13 AM, Greg KH wrote:
> > > > On Wed, Feb 06, 2013 at 07:25:59AM -0800, K. Y. Srinivasan wrote:
> > > >> Use the infrastructure for delivering VMBUS interrupts using a
> > > >> special vector. With this patch, we can now properly handle
> > > >> the VMBUS interrupts that can be delivered on any CPU. Also,
> > > >> turn on interrupt load balancing as well.
> > > >>
> > > >> This patch requires the infrastructure that was implemented in the patch:
> > > >> X86: Handle Hyper-V vmbus interrupts as special hypervisor interrupts
> > > >>
> > > >
> > > > Because of the dependancy, this should go through the x86 tree as well:
> > > > 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > >
> > >
> > > This does not apply to v3.8-rc7 + the set of three vmbus patches for
> > > x86.  I take it there are additional dependencies -- K.Y., what do I
> > > need here?
> >
> > Greg,
> >
> > Peter has checked in the infrastructural patches into v3.8-rc7. This version
> > does not have the patches that upgraded the VMBUS protocol version to the
> > win8 levels.
> 
> What is "this version"?

I looked at the tree that Peter checked in the patches:

https://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=shortlog;h=refs/heads/x86/hyperv

The code under drivers/hv is not the current tip code in your tree. That is the reason, I don't
think this patch:  [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts
should go into Peter's tree.

> 
> > How will the infrastructural patches get moved forward to the version
> > where you have checked-in all the vmbus protocol updates:
> > [PATCH 00/28] Drivers: hv: Update the Vmbus protocol.
> 
> Those are in the char-misc git tree and will to go Linus for 3.9-rc1.
 
The patches that Peter checked in have no dependence on the vmbus patches
that you have checked into 3.9-rc1. My question was with regards to how the
patches that Peter has checked in to 3.8-rc7 will be merged into 3.9-rc1. If the patches that
Peter checked are going to show up in 3.9 rc1, then that would be perfect.
> 
> > Now that Peter has checked in the needed patches, could you take this
> > patch through your tree.
> 
> What again is "this"?
"this" is the current patch in this email:
[PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts

As noted earlier, this patch requires the patches that Peter has now checked into 3.8 rc7. If these
are going to be merged with 3.9-rc1, then you can pick up the patch titled:

 [PATCH 1/1] Drivers: hv: vmbus: Use the new infrastructure for delivering VMBUS interrupts


> 
> > Let me know, if you need, I can re-send this patch to you.
> 
> Will it cause build problems if I take this patch in my tree, without
> the changes in the -tip tree?

You need to first pick up the patches that Peter has check in. 

Regards,

K. Y


