Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3GKTnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:43:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60057 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3GKTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:43:44 -0400
Date: Thu, 11 Jul 2013 21:43:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org,
        Jason Baron <jbaron@akamai.com>
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <1373558223.17876.22.camel@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1307112141151.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz>  <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <1373558223.17876.22.camel@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, Steven Rostedt wrote:

[ .. snip .. ]
> > +	smp_wmb();
> > +
> > +	text_poke(addr, &int3, sizeof(int3));
> > +
> > +	if (len - sizeof(int3) > 0) {
> 
> I believe we need a sync here. Otherwise, if the instruction crosses
> cache lines, the original first byte could have been pulled in, and then
> after the text_poke() below, it gets the updated version, causing a
> crash on that CPU.
> 
> 		on_each_cpu(do_sync_core, NULL, 1);

Right you are.

OTOH we apparently don't need the one after the text_poke() below, as 
syncing the cores just after patching the first byte afterwards provides 
safe enough guard (at least according to hpa's words back in 2010 :) ).

Will change it for next respin of the patchset, thanks for review.

-- 
Jiri Kosina
SUSE Labs
