Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaKYORz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:17:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaKYORx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:17:53 -0500
Message-ID: <54748F70.70402@redhat.com>
Date: Tue, 25 Nov 2014 15:17:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        hpa@linux.intel.com
Subject: Re: [CFT PATCH v2 0/2] KVM: support XSAVES usage in the host
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com> <20141125101331.GA28985@kernel> <54745BB0.8080304@redhat.com> <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com>
In-Reply-To: <400361E2-995A-44B4-B35A-0D35793B49DD@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 15:05, Nadav Amit wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 373b0ab9a32e..ca26681455c2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -6955,6 +6955,9 @@ int fx_init(struct kvm_vcpu *vcpu)
> > 		return err;
> > 
> > 	fpu_finit(&vcpu->arch.guest_fpu);
> > +	if (cpu_has_xsaves)
> > +		vcpu->arch.guest_fpu.state->xsave.xsave_hdr.xcomp_bv =
> > +			host_xcr0 | XSTATE_COMPACTION_ENABLED;
> > 
> > 	/*
> > 	 * Ensure guest xcr0 is valid for loading
> 
> The second version works for me (w/qemu v2.1.0; Linux 3.13 guest). I
> did not need to apply this patch on top. [although I am not sure whether
> relying on userspace to call KVM_SET_XSAVE early enough is a good practice].

Did you actually try the patch? :)  If it works, I'm tempted to apply it
anyway.

> One disclaimer: Since I got limited time with the machine, I executed
> a slightly modified kernel/qemu, and not the latest version.
> Anyhow, I don’t think these differences can have any impact.

Yes, that is no problem.

Paolo
