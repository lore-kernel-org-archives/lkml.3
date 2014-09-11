Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaIKKMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:12:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53920 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbaIKKMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:12:06 -0400
Date: Thu, 11 Sep 2014 13:12:01 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page on
 migration in vcpu_enter_guest().
Message-ID: <20140911101200.GF25317@minantech.com>
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com>
 <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com>
 <541169AD.6060908@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541169AD.6060908@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 11:21:49AM +0200, Paolo Bonzini wrote:
> Il 11/09/2014 07:38, Tang Chen ha scritto:
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index 63c4c3e..da6d55d 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -7093,6 +7093,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
> >  	vmx_set_msr_bitmap(vcpu);
> >  }
> >  
> > +static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
> > +{
> > +	vmcs_write64(APIC_ACCESS_ADDR, hpa);
> 
> This has to be guarded by "if (!is_guest_mode(vcpu))".
> 
We do need to write it if L1 and L2 share APIC_ACCESS_ADDR and skip
it otherwise, no?

> > +}
> > +

--
			Gleb.
