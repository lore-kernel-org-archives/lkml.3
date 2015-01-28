Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbbA1UZo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:25:44 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57442 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414AbbA1UZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:37 -0500
Date: Wed, 28 Jan 2015 11:58:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 2/2] x86: Add support for the clwb instruction
Message-ID: <20150128105852.GF12929@pd.tnic>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
 <1422377631-8986-3-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422377631-8986-3-git-send-email-ross.zwisler@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:53:51AM -0700, Ross Zwisler wrote:
> Add support for the new clwb (cache line write back) instruction.  This
> instruction was announced in the document "Intel Architecture
> Instruction Set Extensions Programming Reference" with reference number
> 319433-022.

...

> After this function completes the data pointed to by vaddr is has been
> accepted to memory and will be durable if the vaddr points to
> persistent memory.
> 
> Regarding the details of how the alternatives assembly is set up, we
> need one additional byte at the beginning of the clflush so that we can
> flip it into a clflushopt by changing that byte into a 0x66 prefix.  Two
> options are to either insert a 1 byte ASM_NOP1, or to add a 1 byte
> NOP_DS_PREFIX.  Both have no functional effect with the plain clflush,
> but I've been told that executing a clflush + prefix should be faster
> than executing a clflush + NOP.
> 
> We had to hard code the assembly for clwb because, lacking the ability
> to assemble the clwb instruction itself, the next closest thing is to
> have an xsaveopt instruction with a 0x66 prefix.  Unfortunately xsaveopt
> itself is also relatively new, and isn't included by all the GCC
> versions that the kernel needs to support.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: H Peter Anvin <h.peter.anvin@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@alien8.de>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
