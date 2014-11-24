Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaKXPzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:55:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48994 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753607AbaKXPzP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:55:15 -0500
Date: Mon, 24 Nov 2014 16:55:13 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 3/5] x86, entry: Switch stacks on a paranoid entry
 from userspace
Message-ID: <20141124155512.GD20296@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net>
 <955e71b4b8427aec7e8b86de0bf877e7944ba1f3.1416604491.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <955e71b4b8427aec7e8b86de0bf877e7944ba1f3.1416604491.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:26:09PM -0800, Andy Lutomirski wrote:
> This causes all non-NMI, non-double-fault kernel entries from
> userspace to run on the normal kernel stack.  Double-fault is
> exempt to minimize confusion if we double-fault directly from
> userspace due to a bad kernel stack.
> 
> This is, suprisingly, simpler and shorter than the current code.  It
> removes the IMO rather frightening paranoid_userspace path, and it
> make sync_regs much simpler.
> 
> There is no risk of stack overflow due to this change -- the kernel
> stack that we switch to is empty.
> 
> This will also enable us to create non-atomic sections within
> machine checks from userspace, which will simplify memory failure
> handling.  It will also allow the upcoming fsgsbase code to be
> simplified, because it doesn't need to worry about usergs when
> scheduling in paranoid_exit, as that code no longer exists.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
