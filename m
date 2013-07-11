Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab3GKTVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:21:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab3GKTVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:21:16 -0400
Date: Thu, 11 Jul 2013 21:21:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@akamai.com>, Borislav Petkov <bpetkov@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <1373561176.17876.44.camel@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1307112116360.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz>  <51DDD3E9.6090601@linux.intel.com>  <alpine.LNX.2.00.1307111204000.29788@pobox.suse.cz>
  <51DEDDEF.4060502@linux.intel.com> <1373561176.17876.44.camel@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Steven Rostedt wrote:

> > The current code assumes that one of the two code sequences is a NOP,
> > and therefore that jumping over the region is legal.  This does not
> > allow for transitioning one active code sequence to another.
> 
> Correct, and I think we should keep the two changes separate, as the NOP
> case is trivial. No need to complicate the trivial and common updates
> (jump_labels and ftrace). But for things like kprobes, we could do a bit
> more complex code, but it should probably be separate.
> 
> Perhaps call this text_poke_nop_bp()?

Hmm ... I don't think this is exactly precise, at least as long as the 
implementation in the patchset I have submitted is concerned.

Yes, most use cases (jump labels, perhaps ftrace) will simply be skipping 
over the patched region, pretending that NOP has been there; but the 
handler provided to text_poke_bp() is completely free to do any other kind 
of trickery.

The one that jump label provides in PATCH 2/2 really just skips over the 
region, yes. But the interface potentially allows for more.

-- 
Jiri Kosina
SUSE Labs
