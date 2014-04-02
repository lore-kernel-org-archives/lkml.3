Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaDBMjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:39:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15840 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758580AbaDBMjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:39:13 -0400
Date: Wed, 2 Apr 2014 13:38:44 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Joe Sylve <joe.sylve@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits
 [31:30]
Message-ID: <20140402123844.GE31892@arm.com>
References: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 05:00:38AM +0100, Joe Sylve wrote:
> Section D7.2.83 TCR_EL1, Translation Control Register (EL1) of the
> latest ARM Architecture Reference Manual, ARMv8, for ARMv8-A states
> that TCR_EL1 TG1 (bits [31:30]) should be set to 11 for a 64KB
> TTBR1_EL1 granule size. The mainline 3.14 kernel incorrectly sets
> those bits to 01 (which is a 16KB granule size).
> 
> Signed-off-by: Joe Sylve <joe.sylve@gmail.com>
> ---
> 
> --- a/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:22.619868978 -0500
> +++ b/arch/arm64/include/asm/pgtable-hwdef.h 2014-04-01 22:13:58.071869886 -0500
> @@ -121,7 +121,7 @@
>  #define TCR_ORGN_MASK ((UL(3) << 10) | (UL(3) << 26))
>  #define TCR_SHARED ((UL(3) << 12) | (UL(3) << 28))
>  #define TCR_TG0_64K (UL(1) << 14)
> -#define TCR_TG1_64K (UL(1) << 30)
> +#define TCR_TG1_64K (UL(3) << 30)
>  #define TCR_IPS_40BIT (UL(2) << 32)
>  #define TCR_ASID16 (UL(1) << 36)
>  #define TCR_TBI0 (UL(1) << 37)

According to the spec, 4K pages is also wrong. The strange thing is that
it works fine on the model. I'll ask internally for clarification
whether it's a typo in the manual or Linux needs fixing.

Thanks.

-- 
Catalin
