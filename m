Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab3CDRtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 12:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab3CDRtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 12:49:24 -0500
Date: Mon, 4 Mar 2013 19:49:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v12 rebased] kvm: notify host when the guest is panicked
Message-ID: <20130304174913.GC14220@redhat.com>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
 <1358925575-4505-1-git-send-email-hutao@cn.fujitsu.com>
 <20130208013947.GA3364@amt.cnet>
 <20130228085425.GA16362@localhost.localdomain>
 <20130302000312.GA25309@amt.cnet>
 <20130303130022.GF23616@redhat.com>
 <20130303222953.GB5922@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130303222953.GB5922@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 07:29:53PM -0300, Marcelo Tosatti wrote:
> On Sun, Mar 03, 2013 at 03:00:22PM +0200, Gleb Natapov wrote:
> > On Fri, Mar 01, 2013 at 09:03:12PM -0300, Marcelo Tosatti wrote:
> > > On Thu, Feb 28, 2013 at 04:54:25PM +0800, Hu Tao wrote:
> > > > > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > index 06fdbd9..c15ef33 100644
> > > > > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > > > > @@ -96,5 +96,7 @@ struct kvm_vcpu_pv_apf_data {
> > > > > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > > > > >  #define KVM_PV_EOI_DISABLED 0x0
> > > > > >  
> > > > > > +#define KVM_PV_EVENT_PORT	(0x505UL)
> > > > > > +
> > > > > 
> > > > > No need for the ioport to be hard coded. What are the options to
> > > > > communicate an address to the guest? An MSR, via ACPI?
> > > > 
> > > > I'm not quite understanding here. By 'address', you mean an ioport?
> > > > how to communicate an address? (I have little knowledge about ACPI)
> > > 
> > > Yes, the ioport. The address of the ioport should not be fixed (for
> > > example future emulated board could use that fixed ioport address,
> > > 0x505UL).
> > > 
> > > One option is to pass the address via an MSR. Yes, that is probably the
> > > best option because there is no dependency on ACPI.
> > > 
> > Why dependency on ACPI is problematic? ACPI is the standard way on x86
> > to enumerate platform devices. Passing it through MSR makes this panic
> > device CPU interface which it is not. And since relying on #GP to detect
> > valid MSRs is not good interface we will have to guard it by cpuid bit.
> > 
> > --
> > 			Gleb.
> 
> KVM guest <-> KVM host interface is not dependent on ACPI, so far. Say,
> its possible to use a Linux guest without ACPI and have KVM paravirt 
> fully functional.
This is not KVM guest <-> KVM host interface though. This is yet another
device. We could implement real impi device that have crash reporting
capability, but decided to go with something simpler. Without ACPI guest
will not be able to power down itself too, but this is not the reason
for us to introduce non-ACPI interface for power down.

--
			Gleb.
