Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3BATgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:36:46 -0500
Received: from na01-bl2-obe.ptr.protection.outlook.com ([65.55.169.29]:28077
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990Ab3BATgo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:36:44 -0500
X-Forefront-Antispam-Report-Untrusted: CIP:157.56.240.21;KIP:(null);UIP:(null);(null);H:BL2PRD0310HT002.namprd03.prod.outlook.com;R:internal;EFV:INT
X-SpamScore: -9
X-BigFish: PS-9(zzbb2dI98dI9371I1e83M1102I542I1432Izz1ee6h1de0h1202h1e76h1d1ah1d2ahz97hz17326ah8275dhz31h2a8h668h839h944hd24hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h9a9j1155h)
X-Forefront-Antispam-Report-Untrusted: SFV:SKI;SFS:;DIR:OUT;SFP:;SCL:-1;SRVR:SN2PR03MB064;H:SN2PR03MB061.namprd03.prod.outlook.com;LANG:en;
From: KY Srinivasan <kys@microsoft.com>
To: KY Srinivasan <kys@microsoft.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "olaf@aepfle.de" <olaf@aepfle.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@alien8.de" <bp@alien8.de>, Jan Beulich <JBeulich@suse.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Topic: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Thread-Index: AQHN/oBZKjWVFkcFI0COSVsKHXB045hhkYiAgAJo1QCAAQYzgIAAErFggABUT8A=
Date: Fri, 1 Feb 2013 19:34:26 +0000
Message-ID: <00b29e4bf7ce4d5dab76582e72171b9d@SN2PR03MB061.namprd03.prod.outlook.com>
References: <1359507077-26050-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-1-git-send-email-kys@microsoft.com>
 <1359507108-26091-2-git-send-email-kys@microsoft.com>
 <5108ED9702000078000BAA08@nat28.tlf.novell.com> <510AE4F6.1050407@zytor.com>
 <alpine.DEB.2.02.1302011307440.10432@kaball.uk.xensource.com>
 <eef612ac273744d29e9ae38f289cdfa3@SN2PR03MB061.namprd03.prod.outlook.com>
In-Reply-To: <eef612ac273744d29e9ae38f289cdfa3@SN2PR03MB061.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.192.195]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OrganizationHeadersPreserved: SN2PR03MB064.namprd03.prod.outlook.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%SUSE.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ALIEN8.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%VGER.KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUTRONIX.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXDRIVERPROJECT.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%CANONICAL.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%AEPFLE.DE$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%ZYTOR.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%EU.CITRIX.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%KERNEL.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%REDHAT.COM$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-FOPE-CONNECTOR: Id%59$Dn%LINUXFOUNDATION.ORG$RO%2$TLS%6$FQDN%131.107.125.5$TlsDn%
X-CrossPremisesHeadersPromoted: TK5EX14HUBC107.redmond.corp.microsoft.com
X-CrossPremisesHeadersFiltered: TK5EX14HUBC107.redmond.corp.microsoft.com
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(199002)(479174001)(13464002)(189002)(43544002)(51704002)(78114001)(24454001)(377454001)(1511001)(47776003)(31966008)(6806001)(20776003)(50986001)(46102001)(47976001)(33646001)(56816002)(23726001)(5343655001)(16676001)(46406002)(50466001)(59766001)(47736001)(77982001)(49866001)(4396001)(63696002)(76482001)(44976002)(51856001)(47446002)(15202345001)(74662001)(74502001)(79102001)(53806001)(54316002)(54356001)(56776001)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB032;H:TK5EX14HUBC107.redmond.corp.microsoft.com;RD:;A:1;MX:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0744CFB5E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: devel [mailto:devel-bounces@linuxdriverproject.org] On Behalf Of KY
> Srinivasan
> Sent: Friday, February 01, 2013 10:11 AM
> To: Stefano Stabellini; H. Peter Anvin
> Cc: olaf@aepfle.de; gregkh@linuxfoundation.org; jasowang@redhat.com;
> x86@kernel.org; linux-kernel@vger.kernel.org; bp@alien8.de; Jan Beulich;
> apw@canonical.com; devel@linuxdriverproject.org; tglx@linutronix.de
> Subject: RE: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> 
> 
> 
> > -----Original Message-----
> > From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> > Sent: Friday, February 01, 2013 8:20 AM
> > To: H. Peter Anvin
> > Cc: Jan Beulich; KY Srinivasan; olaf@aepfle.de; bp@alien8.de;
> > apw@canonical.com; x86@kernel.org; tglx@linutronix.de;
> > devel@linuxdriverproject.org; gregkh@linuxfoundation.org;
> > jasowang@redhat.com; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> >
> > On Thu, 31 Jan 2013, H. Peter Anvin wrote:
> > > On 01/30/2013 12:53 AM, Jan Beulich wrote:
> > > >
> > > > I'm not convinced that's the right approach - any hypervisor
> > > > could do similar emulation, and hence you either want to make
> > > > sure you run on Hyper-V (by excluding all others), or you
> > > > tolerate using the emulation (which may require syncing up with
> > > > the other guest implementations so that shared resources don't
> > > > get used by two parties).
> > > >
> > > > I also wonder whether using the Hyper-V emulation (where
> > > > useful, there might not be anything right now, but this may
> > > > change going forward) when no Xen support is configured
> > > > wouldn't be better than not using anything...
> > > >
> > >
> > > I'm confused about "the right approach" here is.  As far as I
> > > understand, this only can affect a Xen guest where HyperV guest support
> > > is enabled but not Xen support, and only because Xen emulates HyperV but
> > > does so incorrectly.
> > >
> > > This is a Xen bug, and as such it makes sense to reject Xen
> > > specifically.  If another hypervisor emulates HyperV and does so
> > > correctly there seems to be no reason to reject it.
> >
> > I don't think so.
> >
> > AFAIK originally there were features exported as flags and Xen doesn't
> > turn on the flags that correspond to features that are not implemented.
> > The problem here is that Hyper-V is about to introduce a feature without
> > a flag that is not implemented by Xen (see "X86: Deliver Hyper-V
> > interrupts on a separate IDT vector").
> > K.Y. please confirm if I got this right.
> 
> I am not sure I can agree with you here. There are two discriminating factors
> here: (a) Hypervisor check and (b) Feature check. Not every feature of the
> hypervisor can be surfaced as feature bit and furthermore, just because a
> feature
> bit is turned on, it does not necessarily mean that the feature is to be used. For
> instance,
> let us say that Windows guests begin to use the "partition counter" and Xen
> chooses
> to implement that to better support Windows. This does not mean that while
> hosting
> Linux on Xen, you want to plug in a clock source based on the emulated
> "partition counter". This is what would happen in the code we have today.
> 
> Other Hypervisors emulating Hyper-V do not have this problem and Xen would
> not either
> if the emulation bit is selectively turned on (only while running Windows) or if
> Xen were allowed
> to check first ahead of Hyper-V (unconditionally) in the hypervisor detection
> code. As Peter pointed out, we
> have this problem because of the unique situation with Xen.
> 
> In any event, I am not going to further argue this issue; this last round of patches I
> sent out,
> fixes the issue for Xen. Jan wants me to make this check more general. While I
> don't think
> we need to do that, I will see if I can do it. I am checking to see if MSFT
> guarantees that Hyper-V
> would initialize the unused CPUID space to 0. If this is the case, I will implement
> the check
> Jan has suggested; if not, we have to live with the Xen specific check that I
> currently have.

I checked with the Hyper-V guys and I am told that there is no guarantee that Hyper-V
would not use some other range in the CPUID space in the future. So, I will keep the Xen
specific check that I had in this version. I will add the appropriate compilation switches to
take care of the "dead code" and resubmit the patches.

Regards,


K. Y
> 
> >
> > If I were the Microsoft engineer implementing this feature, no matter
> > what Xen does or does not, I would also make sure that there is a
> > corresponding flag for it, because in my experience they avoid future
> > headaches.
> > I wonder what happens if you run Linux with Hyper-V support on an old
> > Hyper-V host that doesn't support vector injection.
> >
> 
> To answer your specific question, this feature of being able to distribute vmbus
> interrupt load across all VCPUs in the guest is a win8 and beyond feature. On prior
> hosts, all interrupts will be delivered on the boot CPU. VMBUS, as part of
> connecting with
> the hosts determines host supported protocol version and decides how it wants
> to
> program the hypervisor with regards to interrupt delivery. Even though we might
> setup
> an IDT entry for delivering the hypervisor interrupt, if the host is a pre-win8 host,
> the vmbus
> driver will program the hypervisor to deliver the interrupt on the boot CPU via a
> legacy interrupt
> vector.
> 
> Regards,
> 
> K. Y
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
> 


