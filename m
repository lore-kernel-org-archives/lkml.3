Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235Ab3IZOdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:33:10 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:35137 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab3IZOdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:33:07 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>
Subject: Re: [PATCH 1/2] ARC: Handle zero-overhead-loop in unaligned access
 handler
Thread-Topic: [PATCH 1/2] ARC: Handle zero-overhead-loop in unaligned access
 handler
Thread-Index: AQHOusFSbq1g87WAs0CX+jTXZB0QNg==
Date: Thu, 26 Sep 2013 14:33:00 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514E9C3@IN01WEMBXA.internal.synopsys.com>
References: <1380203096-5842-1-git-send-email-mjonker@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 07:34 PM, Mischa Jonker wrote:
> If a load or store is the last instruction in a zero-overhead-loop, and
> it's misaligned, the loop would execute only once.
>
> This fixes that problem.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>

Applied to for-curr for 3.12-rcX

Thx,
-Vineet

> ---
>  arch/arc/kernel/unaligned.c |    6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/arc/kernel/unaligned.c b/arch/arc/kernel/unaligned.c
> index c0f832f..00ad070 100644
> --- a/arch/arc/kernel/unaligned.c
> +++ b/arch/arc/kernel/unaligned.c
> @@ -233,6 +233,12 @@ int misaligned_fixup(unsigned long address, struct pt_regs *regs,
>  		regs->status32 &= ~STATUS_DE_MASK;
>  	} else {
>  		regs->ret += state.instr_len;
> +
> +		/* handle zero-overhead-loop */
> +		if ((regs->ret == regs->lp_end) && (regs->lp_count)) {
> +			regs->ret = regs->lp_start;
> +			regs->lp_count--;
> +		}
>  	}
>  
>  	return 0;

