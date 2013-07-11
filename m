Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3GKT3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:29:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab3GKT3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:29:19 -0400
Date: Thu, 11 Jul 2013 21:29:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        Borislav Petkov <bpetkov@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH 1/2 v2] x86: introduce int3-based instruction
 patching
In-Reply-To: <51DED90D.5050205@linux.intel.com>
Message-ID: <alpine.LNX.2.00.1307112127530.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102218200.25858@pobox.suse.cz> <alpine.LNX.2.00.1307102328540.25858@pobox.suse.cz> <51DE8799.9020904@hitachi.com> <51DED90D.5050205@linux.intel.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jul 2013, H. Peter Anvin wrote:

> >> + * The way it is done:
> >> + *	- add a int3 trap to the address that will be patched
> >> + *	- sync cores
> > 
> > You don't need this "sync cores". (and your code didn't) :)
> 
> I believe you do, lest you get "Frankenstructions".  I believe you don't
> need the second one, however.  I should dig up my notes on this.

I found this post from 2010 from you:

	http://lkml.indiana.edu/hypermail/linux/kernel/1001.1/01530.html

If it's still valid and you guys at Intel haven't discovered any reason 
why that procedure would be invalid, I'll send out v3 with that'd be using 
exactly this ordering of syncing of the cores.

Thanks,

-- 
Jiri Kosina
SUSE Labs
