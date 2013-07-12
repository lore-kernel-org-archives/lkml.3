Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab3GLH6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:58:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59316 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757273Ab3GLH56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:57:58 -0400
Date: Fri, 12 Jul 2013 09:57:38 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v3] x86: introduce int3-based instruction patching
Message-ID: <20130712075738.GB24008@pd.tnic>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
 <alpine.LNX.2.00.1307112221110.29788@pobox.suse.cz>
 <51DF1B3C.8040603@linux.intel.com>
 <20130711210452.GE8900@pd.tnic>
 <51DF2566.8000806@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51DF2566.8000806@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 02:36:38PM -0700, H. Peter Anvin wrote:
> On 07/11/2013 02:04 PM, Borislav Petkov wrote:
> > On Thu, Jul 11, 2013 at 01:53:16PM -0700, H. Peter Anvin wrote:
> >> Has anyone talked to AMD or VIA about this at all?
> > 
> > I guess I can try to take care of the AMD part. Just to confirm, is this
> > the exact sequence we're interested in:
> > 
> > 1. Setup int3 handler for fixup.
> > 
> > 2. Put a breakpoint (int3) on the first byte of modifying region, and
> > synchronize code on all CPUs.
> > 
> > 3. Modify other bytes of modifying region.
> > 
> > 4. Modify the first byte of modifying region, and synchronize code on
> > all CPUs.
> > 
> > 5. Clear int3 handler.
> > 
> > If a suitable int3 handler is left permanently in place then the
> > synchronization in step 4 is unnecessary.
> > 
> 
> Correct.

Right, above sequence would work on AMD.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
