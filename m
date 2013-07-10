Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab3GJUZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 16:25:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3GJUZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 16:25:51 -0400
Date: Wed, 10 Jul 2013 22:25:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] [PATCH 0/2] x86: make jump labels use int3-based breakpoint
 instead of stop_machine()
Message-ID: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a resurrection of a few years old idea to have jump labels use 
synchronization based on int3 breakpoint rather than relying on 
stop_machine() with all the consequences.

ftrace has been doing exactly this kind of patching for year since 
08d636b6 ("ftrace/x86: Have arch x86_64 use breakpoints instead of stop 
machine").

This patchset first introduces generic text_poke_bp() that provides means 
to perform this method of patching in parallel to text_poke_smp(), and 
then converts x86 jump label code to use it.

If this is merged, I'll do a followup patch converting ftrace to use this 
infrastructure as well, as it's doing the same thing in principle already.

Comments welcome.

-- 
Jiri Kosina
SUSE Labs
