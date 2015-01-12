Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbbALQzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:55:36 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58174 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbbALQze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:55:34 -0500
Date: Mon, 12 Jan 2015 17:55:31 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, gleb@kernel.org, pbonzini@redhat.com,
        borntraeger@de.ibm.com, cornelia.huck@de.ibm.com,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        a.motakis@virtualopensystems.com
Subject: Re: [PATCH v5 4/5] KVM: irqfd: use
 kvm_arch_is_virtual_intc_initialized
Message-ID: <20150112165531.GJ3868@cbox>
References: <1417622832-5460-1-git-send-email-eric.auger@linaro.org>
 <1417622832-5460-5-git-send-email-eric.auger@linaro.org>
 <20150111211713.GF3868@cbox>
 <54B3CEB3.1010709@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B3CEB3.1010709@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 02:40:03PM +0100, Eric Auger wrote:
> On 01/11/2015 10:17 PM, Christoffer Dall wrote:
> > On Wed, Dec 03, 2014 at 05:07:11PM +0100, Eric Auger wrote:
> >> On arm/arm64, the interrupt controller is dynamically instantiated.
> >> There is a risk the user-space assigns an irqfd before this latter
> >> is initialized and ready to accept virtual irq injection. On such
> >> attempt, the IRQFD setup is rejected and -EAGAIN is returned.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> ---
> >>  virt/kvm/eventfd.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> >> index b0fb390..f837c83 100644
> >> --- a/virt/kvm/eventfd.c
> >> +++ b/virt/kvm/eventfd.c
> >> @@ -314,6 +314,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
> >>  	unsigned int events;
> >>  	int idx;
> >>  
> >> +	if (!kvm_arch_is_virtual_intc_initialized(kvm))
> >> +		return -EAGAIN;
> >> +
> > 
> > You can fold this into the patch that defines the static inline since
> > nothing defines the KVM_HAVE_ARCH_... yet.
> Not sure to understand what you mean:
> __KVM_HAVE_ARCH_VIRTUAL_INTC_INITIALIZED was defined in previous patch
> file (3/5). Nethertheless I can drop that patch file.
> 
I'm just saying that you don't need to split this into multiple patches.

-Christoffer
