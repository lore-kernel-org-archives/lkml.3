Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbaCTU0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759278AbaCTU0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:26:21 -0400
Message-ID: <1395347176.632.41.camel@ul30vt.home>
Subject: Re: [PATCH 2/4] KVM: ioapic: clear IRR for edge-triggered
 interrupts at delivery
From: Alex Williamson <alex.williamson@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        kvm@vger.kernel.org
Date: Thu, 20 Mar 2014 14:26:16 -0600
In-Reply-To: <1395154495-22807-3-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
	 <1395154495-22807-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-18 at 15:54 +0100, Paolo Bonzini wrote:
> This ensures that IRR bits are set in the KVM_GET_IRQCHIP result only if
> the interrupt is still sitting in the IOAPIC.  After the next patches, it
> avoids spurious reinjection of the interrupt when KVM_SET_IRQCHIP is
> called.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  virt/kvm/ioapic.c | 3 +++
>  1 file changed, 3 insertions(+)

Makes sense

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
> index 0b4914147b9d..25e16a6898ed 100644
> --- a/virt/kvm/ioapic.c
> +++ b/virt/kvm/ioapic.c
> @@ -288,6 +288,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
>  	irqe.level = 1;
>  	irqe.shorthand = 0;
>  
> +	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
> +		ioapic->irr &= ~(1 << irq);
> +
>  	if (irq == RTC_GSI && line_status) {
>  		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
>  		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,



