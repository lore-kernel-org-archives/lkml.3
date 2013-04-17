Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966753Ab3DQOr6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:47:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966531Ab3DQOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:47:57 -0400
Date: Wed, 17 Apr 2013 16:48:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Message-ID: <20130417134850.GB26335@redhat.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-1-git-send-email-kys@microsoft.com>
 <1359940959-32168-2-git-send-email-kys@microsoft.com>
 <20130417070616.GA4487@redhat.com>
 <423ae84de75f4b3587eb2d1a365cbd95@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417124852.GD6801@redhat.com>
 <3b76ebfdb240419aa601309465a4c154@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130417132523.GB26157@redhat.com>
 <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ffd83acf6ac4a7bb5d51c95c96e6f50@SN2PR03MB061.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 02:34:57PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > Sent: Wednesday, April 17, 2013 9:25 AM
> > To: KY Srinivasan
> > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> > JBeulich@suse.com; bp@alien8.de
> > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> > 
> > On Wed, Apr 17, 2013 at 02:12:12PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > > > Sent: Wednesday, April 17, 2013 8:49 AM
> > > > To: KY Srinivasan
> > > > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> > kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> > > > JBeulich@suse.com; bp@alien8.de
> > > > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
> > > >
> > > > On Wed, Apr 17, 2013 at 01:20:58PM +0000, KY Srinivasan wrote:
> > > > >
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > > > > > Sent: Wednesday, April 17, 2013 3:06 AM
> > > > > > To: KY Srinivasan
> > > > > > Cc: x86@kernel.org; gregkh@linuxfoundation.org; linux-
> > > > kernel@vger.kernel.org;
> > > > > > devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> > > > > > jasowang@redhat.com; tglx@linutronix.de; hpa@zytor.com;
> > > > > > JBeulich@suse.com; bp@alien8.de
> > > > > > Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of
> > Hyper-V
> > > > > >
> > > > > > On Sun, Feb 03, 2013 at 05:22:38PM -0800, K. Y. Srinivasan wrote:
> > > > > > > Xen emulates Hyper-V to host enlightened Windows. Looks like this
> > > > > > > emulation may be turned on by default even for Linux guests. Check
> > and
> > > > > > > fail Hyper-V detection if we are on Xen.
> > > > > > >
> > > > > > > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > > > > >
> > > > > > I'm very curious what's the specific bug that is fixed here?
> > > > > > I went over the original discussion in
> > > > > > https://patchwork.kernel.org/patch/2064331/
> > > > > > and that's still not clear to me. Is there a configuration
> > > > > > that is broken without this patch but starts working with
> > > > > > this patch?
> > > > > >
> > > > > > It seems that one might want to use hyper-v emulation e.g. to test
> > > > > > hyper-v code without using windows, so the functionality
> > > > > > that this patch disables is not completely useless,
> > > > > > so there should be a good reason for disabling it.
> > > > > >
> > > > > > Could you enlighten me please? :)
> > > > >
> > > > > Michael,
> > > > >
> > > > > If I recall correctly, the issue here was that Xen was enabling
> > > > > Hyper-V emulation un-conditionally even for Linux guests.
> > > >
> > > > Okay so basically some Xen specific strangeness.
> > > >
> > > > > Clearly,
> > > > > this was not the intention to begin with. This check was added to
> > > > > ensure that while hosting Linux we would not un-intentionally enable
> > > > > Hyper-V emulation in Xen.
> > > >
> > > > What if you want to intentionally enable Hyper-V emulation in Xen?
> > > > There's no way to do this now, right?
> > > >
> > > > > Not all Hyper-V features are tagged with a
> > > > > CPUID feature bit and so it was agreed that it would be better to
> > > > > disable Hyper-V emulation when hosting Linux on Xen.
> > > > >
> > > > > Regards,
> > > > >
> > > > > K. Y
> > > >
> > > > I was just asking whether there are any specific examples of a bug
> > > > or is this change done just in case?
> > >
> > > Ideally, if Hyper-V could be emulated in a plug compatible way, in that the guest
> > would not know
> > > the difference as to whether Hyper-V was being emulated or indeed it was
> > Hyper-V underneath, I would agree with you.
> > > Even in this case, I would argue that we would somehow give preference to the
> > native implementation rather
> > > than the emulated environment. Having done the initial emulation of Hyper-V
> > on Xen, I know the current emulation of
> > > Hyper-V is restricted to emulating a few features advertised via the CPUID bits.
> > If I recall correctly, Xen did not implement
> > > the enlightened TLB flush scheme. Furthermore, none of the Hyper-V
> > emulations implement the I/O related infrastructure.
> > > For Linux to run efficiently on Hyper-V, the I/O paths are significantly more
> > important than what Hyper-V emulation there is
> > > in Xen and I suspect in KVM. So, I don't think we want to run Linux on Xen/KVM
> > that is emulating Hyper-V (cpuids).
> > 
> > No, it's a Xen specific bug.  KVM in a hyper-v mode still emulates PCI
> > so can still use KVM PV devices which are all PCI devices. So there's no problem
> > there.
> 
> Even Xen does not have a problem here; Xen would install its PV drivers in the guest.
> So, the I/O infrastructure that would be installed in the guest would be based on the 
> host.
> > 
> > Also, why override this in the guest? With time Xen hyper-v emulation
> > might improve, meanwhile it's always possible to disable this in
> > the hypervisor.
> > 
> > > The specific case I ran into that required this patch was when I moved the
> > VMBUS interrupts to be delivered via a special
> > > hypervisor vector (to support full interrupt distribution amongst all VCPUs in
> > the guest). This feature is not tagged in the CPUID
> > > feature bits and without this check, I would install an interrupt handler for the
> > hypervisor vector that clearly did not make
> > > any sense in anything other than Hyper-V. I suspect there will be more such
> > situations as we go forward.
> > >
> > > Regards,
> > >
> > > K. Y
> > 
> > Why? Because there's no VMBUS on Xen? So check whether VMBUS exists?
> On Linux, Hyper-V detection is used to load hyper-V related drivers (VMBUS etc.). For the case in
> point, it was not clear to me how I could install the vmbus interrupt handler in a way that would
> make sense when Xen was unconditionally emulating Hyper-V. 
> 
> Regards,
> 
> K. Y

For example, check whether there is anything on the vmbus?

> > 
> > > >
> > > > > >
> > > > > > > ---
> > > > > > >  arch/x86/kernel/cpu/mshyperv.c |    7 +++++++
> > > > > > >  1 files changed, 7 insertions(+), 0 deletions(-)
> > > > > > >
> > > > > > > diff --git a/arch/x86/kernel/cpu/mshyperv.c
> > > > > > b/arch/x86/kernel/cpu/mshyperv.c
> > > > > > > index 646d192..4dab317 100644
> > > > > > > --- a/arch/x86/kernel/cpu/mshyperv.c
> > > > > > > +++ b/arch/x86/kernel/cpu/mshyperv.c
> > > > > > > @@ -30,6 +30,13 @@ static bool __init ms_hyperv_platform(void)
> > > > > > >  	if (!boot_cpu_has(X86_FEATURE_HYPERVISOR))
> > > > > > >  		return false;
> > > > > > >
> > > > > > > +	/*
> > > > > > > +	 * Xen emulates Hyper-V to support enlightened Windows.
> > > > > > > +	 * Check to see first if we are on a Xen Hypervisor.
> > > > > > > +	 */
> > > > > > > +	if (xen_cpuid_base())
> > > > > > > +		return false;
> > > > > > > +
> > > > > > >  	cpuid(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS,
> > > > > > >  	      &eax, &hyp_signature[0], &hyp_signature[1],
> > &hyp_signature[2]);
> > > > > > >
> > > > > > > --
> > > > > > > 1.7.4.1
> > > > > > >
> > > > > > > --
> > > > > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > > > > the body of a message to majordomo@vger.kernel.org
> > > > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > > > >
> > > > >
> > > >
> > >
> > 
> 
