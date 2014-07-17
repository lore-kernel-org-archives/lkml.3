Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351AbaGQLbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:31:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:44637 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755998AbaGQLbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:31:13 -0400
Message-ID: <53C7B3FA.3050506@redhat.com>
Date: Thu, 17 Jul 2014 13:31:06 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Fix virtual interrupt delivery injection
References: <1405594981-31384-1-git-send-email-wanpeng.li@linux.intel.com>
In-Reply-To: <1405594981-31384-1-git-send-email-wanpeng.li@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 13:03, Wanpeng Li ha scritto:
> +		/*
> +		 * Fall back to old way to inject the interrupt since there
> +		 * is no vAPIC-v for L2.
> +		 */
> +		if (vcpu->arch.exception.pending ||
> +				vcpu->arch.nmi_injected ||
> +				vcpu->arch.interrupt.pending)
> +			return;

This is just

	if (kvm_event_needs_reinjection(vcpu))
		return;

but apart from this the patch is okay.  I'll make the change and apply 
it, thanks.

Paolo
