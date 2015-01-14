Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbbANRqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:46:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbbANRqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:46:37 -0500
Date: Wed, 14 Jan 2015 18:04:08 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Feng Wu <feng.wu@intel.com>
Subject: Re: [PATCH] KVM: x86: amend APIC lowest priority arbitration
Message-ID: <20150114170407.GA1298@potion.brq.redhat.com>
References: <1420814246-19033-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420814246-19033-1-git-send-email-rkrcmar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-09 15:37+0100, Radim Krčmář:
> Lowest priority should take the task priority into account.
> 
> SDM 10.6.2.4 Lowest Priority Delivery Mode.
> (Too long to quote; second and last paragraphs are relevant.)
> 
> Before this patch, we strived to have the same amount of handled
> lowest-priority interrupts on all VCPUs.
> This is only a complication, but kept for compatibility.

> Real modern Intels can't send lowest priority IPIs and the chipset
> directs external ones using processors' TPR.

False, new Intels most likely don't consider TPR.
Please don't include this patch.

> AMD still has rough edges.

AMD behaves like its documentation states,

> +	/* XXX: AMD (2:16.6.2 Lowest Priority Messages and Arbitration)
> +	 *      - uses the APR register (which also considers ISR and IRR),
> +	 *      - chooses the highest APIC ID when APRs are identical,
> +	 *      - and allows a focus processor.

but we don't differentiate.  (It shouldn't create AMD-specific bugs.)
