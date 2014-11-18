Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828AbaKRV2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:28:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47302 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbaKRV2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:28:33 -0500
Date: Tue, 18 Nov 2014 13:28:21 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        james.hogan@imgtec.com, avagin@openvz.org, Paul.Clothier@imgtec.com,
        palves@redhat.com, oleg@redhat.com, dhowells@redhat.com,
        davej@redhat.com, davem@davemloft.net, mikey@neuling.org,
        benh@kernel.crashing.org, mpe@ellerman.id.au, sam.bobroff@au1.ibm.com
Subject: Re: [PATCH V4 1/8] elf: Add new PowerPC specifc core note sections
Message-ID: <20141118212821.GA21540@us.ibm.com>
References: <1415683597-22819-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1415683597-22819-2-git-send-email-khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415683597-22819-2-git-send-email-khandual@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111821-0005-0000-0000-00000673DEE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| This patch adds four new core note sections for PowerPC transactional
| memory and one core note section for general miscellaneous debug registers.
| These addition of new elf core note sections extends the existing elf ABI
| without affecting it in any manner.
| 
| Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>

Except for some minor comments to one of the patches, the patchset
looks good to me. I was also able to run the included selftest on
a PowerVM guest.

Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

| ---
|  include/uapi/linux/elf.h | 5 +++++
|  1 file changed, 5 insertions(+)
| 
| diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
| index ea9bf25..2260fc0 100644
| --- a/include/uapi/linux/elf.h
| +++ b/include/uapi/linux/elf.h
| @@ -379,6 +379,11 @@ typedef struct elf64_shdr {
|  #define NT_PPC_VMX	0x100		/* PowerPC Altivec/VMX registers */
|  #define NT_PPC_SPE	0x101		/* PowerPC SPE/EVR registers */
|  #define NT_PPC_VSX	0x102		/* PowerPC VSX registers */
| +#define NT_PPC_TM_SPR	0x103		/* PowerPC TM special registers */
| +#define NT_PPC_TM_CGPR	0x104		/* PowerpC TM checkpointed GPR */
| +#define NT_PPC_TM_CFPR	0x105		/* PowerPC TM checkpointed FPR */
| +#define NT_PPC_TM_CVMX	0x106		/* PowerPC TM checkpointed VMX */
| +#define NT_PPC_MISC	0x107		/* PowerPC miscellaneous registers */
|  #define NT_386_TLS	0x200		/* i386 TLS slots (struct user_desc) */
|  #define NT_386_IOPERM	0x201		/* x86 io permission bitmap (1=deny) */
|  #define NT_X86_XSTATE	0x202		/* x86 extended state using xsave */
| -- 
| 1.9.3

