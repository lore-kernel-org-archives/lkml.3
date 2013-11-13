Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3KMOIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:08:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:59640 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab3KMOIU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:08:20 -0500
Message-ID: <528387CF.5090105@arm.com>
Date: Wed, 13 Nov 2013 14:08:15 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Vinayak Kale <vkale@apm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@apm.com" <patches@apm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Will Deacon <Will.Deacon@arm.com>, "jcm@redhat.com" <jcm@redhat.com>
Subject: Re: [PATCH V2 1/2] genirq: Add an accessor for IRQ_PER_CPU flag
References: <1384340725-26073-1-git-send-email-vkale@apm.com> <1384340725-26073-2-git-send-email-vkale@apm.com>
In-Reply-To: <1384340725-26073-2-git-send-email-vkale@apm.com>
X-Enigmail-Version: 1.4.6
X-OriginalArrivalTime: 13 Nov 2013 14:08:16.0291 (UTC) FILETIME=[CC42AF30:01CEE079]
X-MC-Unique: 113111314081701201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinayak,

On 13/11/13 11:05, Vinayak Kale wrote:
> This patch adds an accessor function for IRQ_PER_CPU flag.
> The accessor function is useful to dertermine whether an IRQ is percpu or not.
> 
> Signed-off-by: Vinayak Kale <vkale@apm.com>
> ---
>  include/linux/irqdesc.h |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 56fb646..acd8a3f 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -152,6 +152,14 @@ static inline int irq_balancing_disabled(unsigned int irq)
>  	return desc->status_use_accessors & IRQ_NO_BALANCING_MASK;
>  }
>  
> +static inline int irq_is_percpu(unsigned int irq)
> +{
> +	struct irq_desc *desc;
> +
> +	desc = irq_to_desc(irq);
> +	return (desc && (desc->status_use_accessors & IRQ_PER_CPU)) ? 1 : 0;

I don't think it is worth checking for the validity of "desc" here. All
the other accessors assume that you've not passed a stupid "irq" value.

Simply having
	return !!(desc->status_use_accessors & IRQ_PER_CPU);
should be enough.

> +}
> +
>  static inline void
>  irq_set_lockdep_class(unsigned int irq, struct lock_class_key *class)
>  {
> 

Cheers,

	M.
-- 
Jazz is not dead. It just smells funny...

