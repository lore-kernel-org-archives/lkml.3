Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbbA2C6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:58:03 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:46700 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbbA2C56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:57:58 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Ross Zwisler <ross.zwisler@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: H Peter Anvin <h.peter.anvin@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        "Kani, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers, Linda" <linda.knippers@hp.com>
Subject: RE: [PATCH v3 1/2] x86: Add support for the pcommit instruction
Thread-Topic: [PATCH v3 1/2] x86: Add support for the pcommit instruction
Thread-Index: AQHQOlH6sqYv8X65A0C5xMaJVRwyCpzVvIHw
Date: Wed, 28 Jan 2015 17:10:46 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295A75C517@G9W0745.americas.hpqcorp.net>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
 <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Ross Zwisler
> Sent: Tuesday, 27 January, 2015 10:54 AM
> To: linux-kernel@vger.kernel.org
> Cc: Ross Zwisler; H Peter Anvin; Ingo Molnar; Thomas Gleixner; Borislav
> Petkov
> Subject: [PATCH v3 1/2] x86: Add support for the pcommit instruction
> 
> Add support for the new pcommit (persistent commit) instruction.  This
> instruction was announced in the document "Intel Architecture
> Instruction Set Extensions Programming Reference" with reference number
> 319433-022.
> 
> https://software.intel.com/sites/default/files/managed/0d/53/319433-
> 022.pdf
> 
...
> ---
>  arch/x86/include/asm/cpufeature.h    | 1 +
>  arch/x86/include/asm/special_insns.h | 8 ++++++++
>  2 files changed, 9 insertions(+)

Should this patch series also add defines for the virtual 
machine control data structure changes?

1. Add the new VM-Execution Controls bit 21 as
    SECONDARY_EXEC_PCOMMIT_EXITING 0x00200000
to arch/x86/include/asm/vmx.h.

2. Add the new exit reason of 64 (0x41) as
	EXIT_REASON_PCOMMIT  64
to arch/x86/include/uapi/asm/vmx.h and (with a
VMX_EXIT_REASONS string) to usr/include/asm/vmx.h.

3. Add a kvm_vmx_exit_handler to arch/x86/kvm/vmx.c.


---
Rob Elliott    HP Server Storage


