Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3GKKyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:54:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab3GKKyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:54:12 -0400
Date: Thu, 11 Jul 2013 12:54:08 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1307111251240.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DDD3E9.6090601@linux.intel.com> <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Jiri Kosina wrote:

> > Returning to the instruction will, in effect, be a busy-wait for the 
> > faulted CPU until the patch is complete; more or less what stop_machine 
> > would do, but only for a CPU which actually strays into the affected 
> > region.
> 
> To be honest, I fail to see a clear advantage ... we don't avoid any extra 
> IPI by it, and wrt. "correctness", the end result is the same.

Ok, after some offline discussion, my understanding is that with this 
proposal you are willing to make this usable in a more general way than 
just simple nop -> jump -> nop patching.

That makes sense, but I'd propose to have a different independent 
interface for this if needed (text_poke_bp_busy() ... ?) in parallel to 
the text_poke_bp() as is in my patchset, due to the obvious extra cycles 
it's bringing.

Thanks,

-- 
Jiri Kosina
SUSE Labs
