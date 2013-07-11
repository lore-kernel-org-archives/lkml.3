Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab3GKKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:09:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3GKKJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:09:25 -0400
Date: Thu, 11 Jul 2013 12:09:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <51DDD3E9.6090601@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, H. Peter Anvin wrote:

> > If any CPU instruction execution would collide with the patching,
> > it'd be trapped by the int3 breakpoint and redirected to the provided
> > "handler" (which would typically mean just skipping over the patched
> > region, acting as "nop" has been there, in case we are doing nop -> jump
> > and jump -> nop transitions).
> > 
> 
> I'm wondering if it would be easier/more general to just return to the
> instruction.  The "more general" bit would allow this to be used for
> other things, like alternatives, 

As Boris already pointed out, this is not really that interesting, as it's 
being done through text_poke_early(), which is rather a different story 
anyway.

> and perhaps eventually dynamic call patching.

Umm ... could you please elaborate either what exactly do you mean by 
that, or why it can't be used currently as-is?

> Returning to the instruction will, in effect, be a busy-wait for the 
> faulted CPU until the patch is complete; more or less what stop_machine 
> would do, but only for a CPU which actually strays into the affected 
> region.

To be honest, I fail to see a clear advantage ... we don't avoid any extra 
IPI by it, and wrt. "correctness", the end result is the same.

Thanks,

-- 
Jiri Kosina
SUSE Labs
