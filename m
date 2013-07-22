Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab3GVVA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:00:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757770Ab3GVVAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:00:55 -0400
Date: Mon, 22 Jul 2013 23:00:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, x86@kernel.org
Subject: Re: [PATCH -tip/x86/jumplabel] x86: call out into int3 handler
 directly instead of using notifier
In-Reply-To: <51ED9BC0.6020206@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307222256120.14024@pobox.suse.cz>
References: <20130720131226.GA13893@localhost> <alpine.LNX.2.00.1307221307280.23128@pobox.suse.cz> <51ED9BC0.6020206@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, H. Peter Anvin wrote:

>  What is the baseline for this patch?

Hi!

it's x86/jumplabel branch, as a followup to commit 
fd4363fff3d96 ("x86: Introduce int3 (breakpoint)-based instruction 
patching") sitting there.

This branch however seems to be broken by Ingo's mismerge; this e-mail 
from earlier today:

	https://lkml.org/lkml/2013/7/22/147

implied that he fixed this ("all is fine"), however x86/jumplabel still 
contains just 3/3 of Masami's series, and therefore is broken; 3/3 is not 
enough, it needs also

	kprobes/x86: Remove an incorrect comment about int3 in NMI/MCE
	kprobes/x86: Use text_poke_bp() instead of text_poke_smp*()

included or

	kprobes/x86: Remove unused text_poke_smp() and text_poke_smp_batch() functions

dropped to be in consistent state again.

I pinged Ingo about this:

	https://lkml.org/lkml/2013/7/22/281

but the branch still seems to be in an odd state, containing last patch of 
Masami's series.

Thanks in advance for fixing this and applying mi fix as well,	

-- 
Jiri Kosina
SUSE Labs
