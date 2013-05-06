Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791Ab3EFXVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:21:37 -0400
Received: from kymasys.com ([64.62.140.43]:45712 "HELO kymasys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757070Ab3EFXVd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:21:33 -0400
Subject: Re: [PATCH] mips/kvm: Fix ABI for compatibility with 64-bit guests.
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Sanjay Lal <sanjayl@kymasys.com>
In-Reply-To: <1367879980-2440-1-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 6 May 2013 16:11:34 -0700
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <1069B54B-C9CD-4333-B56F-B0E1D740CADB@kymasys.com>
References: <1367879980-2440-1-git-send-email-ddaney.cavm@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 6, 2013, at 3:39 PM, David Daney wrote:

> 
> /* for KVM_GET_REGS and KVM_SET_REGS */
> +/*
> + * If Config[AT] is zero (32-bit CPU), the register contents are
> + * stored in the lower 32-bits of the struct kvm_regs fields and sign
> + * extended to 64-bits.
> + */
> struct kvm_regs {
> -	__u32 gprs[32];
> -	__u32 hi;
> -	__u32 lo;
> -	__u32 pc;
> +	/* out (KVM_GET_REGS) / in (KVM_SET_REGS) */
> +	__u64 gpr[32];
> +	__u64 hi, lo;
> +	__u64 pc;
> +};
> 
> -	__u32 cp0reg[N_MIPS_COPROC_REGS][N_MIPS_COPROC_SEL];

Hi David, I'll try out the diff with QEMU and confirm that it works as expected. Could you just leave the GPR field in kvm_regs as "gprs". Its a minor change but avoids diffs that just replace "gprs" with "gpr".

Regards
Sanjay

