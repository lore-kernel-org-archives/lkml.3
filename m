Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaKUXnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 18:43:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaKUXnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 18:43:13 -0500
Date: Fri, 21 Nov 2014 15:43:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, tglx@linutronix.de, james.hogan@imgtec.com,
        avagin@openvz.org, Paul.Clothier@imgtec.com, palves@redhat.com,
        oleg@redhat.com, dhowells@redhat.com, davej@redhat.com,
        davem@davemloft.net, mikey@neuling.org, benh@kernel.crashing.org,
        sukadev@linux.vnet.ibm.com, mpe@ellerman.id.au,
        sam.bobroff@au1.ibm.com
Subject: Re: [PATCH V4 1/8] elf: Add new PowerPC specifc core note sections
Message-Id: <20141121154310.489097fb4403d664f2156043@linux-foundation.org>
In-Reply-To: <1415683597-22819-2-git-send-email-khandual@linux.vnet.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
	<1415683597-22819-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014 10:56:30 +0530 Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:

> This patch adds four new core note sections for PowerPC transactional
> memory and one core note section for general miscellaneous debug registers.
> These addition of new elf core note sections extends the existing elf ABI
> without affecting it in any manner.
> 
> Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
> ---
>  include/uapi/linux/elf.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
> index ea9bf25..2260fc0 100644
> --- a/include/uapi/linux/elf.h
> +++ b/include/uapi/linux/elf.h
> @@ -379,6 +379,11 @@ typedef struct elf64_shdr {
>  #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
>  #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
>  #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
> +#define NT_PPC_TM_SPR	0x103		/* PowerPC TM special registers */
> +#define NT_PPC_TM_CGPR	0x104		/* PowerpC TM checkpointed GPR */
> +#define NT_PPC_TM_CFPR	0x105		/* PowerPC TM checkpointed FPR */
> +#define NT_PPC_TM_CVMX	0x106		/* PowerPC TM checkpointed VMX */
> +#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
>  #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
>  #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
>  #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */

ack from me, if that was at all expected.

Please cc Shuah Khan <shuah.kh@samsung.com> on the tools/testing/selftests
changes.

