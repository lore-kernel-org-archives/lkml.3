Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbbA1UZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:25:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:57443 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757461AbbA1UZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:25:37 -0500
Date: Wed, 28 Jan 2015 11:58:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <h.peter.anvin@intel.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v3 1/2] x86: Add support for the pcommit instruction
Message-ID: <20150128105818.GE12929@pd.tnic>
References: <1422377631-8986-1-git-send-email-ross.zwisler@linux.intel.com>
 <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422377631-8986-2-git-send-email-ross.zwisler@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 09:53:50AM -0700, Ross Zwisler wrote:
> Add support for the new pcommit (persistent commit) instruction.  This
> instruction was announced in the document "Intel Architecture
> Instruction Set Extensions Programming Reference" with reference number
> 319433-022.
> 
> https://software.intel.com/sites/default/files/managed/0d/53/319433-022.pdf
> 
> The pcommit instruction ensures that data that has been flushed from the
> processor's cache hierarchy with clwb, clflushopt or clflush is accepted to
> memory and is durable on the DIMM.  The primary use case for this is persistent
> memory.
> 
> This function shows how to properly use clwb/clflushopt/clflush and
> pcommit with appropriate fencing:

...

> This is still correct, but now you've got two fences separated by only a
> nop.  With the commit and the fence together in pcommit_sfence() you
> avoid the final unneeded fence.
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
