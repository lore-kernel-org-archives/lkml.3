Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKYRFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:05:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbaKYRFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:05:48 -0500
Message-ID: <5474B6BC.2060309@redhat.com>
Date: Tue, 25 Nov 2014 18:05:00 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@linaro.org, marc.zyngier@arm.com,
        peter.maydell@linaro.org, agraf@suse.de
CC: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        bp@suse.de, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] KVM: arm: guest debug, define API headers
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org> <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
In-Reply-To: <1416931805-23223-3-git-send-email-alex.bennee@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 17:10, Alex Bennée wrote:
> +/* Exit types which define why we did a debug exit */
> +#define KVM_DEBUG_EXIT_ERROR		0x0
> +#define KVM_DEBUG_EXIT_SINGLE_STEP	0x1
> +#define KVM_DEBUG_EXIT_SW_BKPT		0x2
> +#define KVM_DEBUG_EXIT_HW_BKPT		0x3
> +#define KVM_DEBUG_EXIT_HW_WTPT		0x4
> +
>  struct kvm_debug_exit_arch {
> +	__u64 address;
> +	__u32 exit_type;
>  };
>  

So there is no register that says "this breakpoint has triggered" or
"this watchpoint has triggered"?

Paolo
