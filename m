Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3GKWb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:31:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484Ab3GKWbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:31:55 -0400
Date: Fri, 12 Jul 2013 00:31:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
In-Reply-To: <51DF1B3C.8040603@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307120027570.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz> <51DF1B3C.8040603@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, H. Peter Anvin wrote:

> > synchronization after replacing "all but first" instructions should not
> > be necessary (on Intel hardware), as the syncing after the subsequent
> > patching of the first byte provides enough safety.
> > But there's not only Intel HW out there, and we'd rather be on a safe
> > side.
> 
> Has anyone talked to AMD or VIA about this at all?  Did anyone else ever
> make SMP-capable x86?

If Boris can verify for AMD, that'd be good; we could then just remove one 
extra syncing of the cores as a followup (can be done any time later, both 
for alternative.c and ftrace in fact).

With the "extra" sync, the procedure is already verified to work properly 
by ftace.

Thanks,

-- 
Jiri Kosina
SUSE Labs
