Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaKVQzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:55:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37231 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaKVQzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:55:03 -0500
Date: Sat, 22 Nov 2014 17:55:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v4 1/5] uprobes, x86: Fix _TIF_UPROBE vs
 _TIF_NOTIFY_RESUME
Message-ID: <20141122165501.GB4395@pd.tnic>
References: <cover.1416604491.git.luto@amacapital.net>
 <4eb18b212f8f62d0ea3dc0679930ede82d7d37fc.1416604491.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4eb18b212f8f62d0ea3dc0679930ede82d7d37fc.1416604491.git.luto@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 01:26:07PM -0800, Andy Lutomirski wrote:
> x86 call do_notify_resume on paranoid returns if TIF_UPROBE is set
> but not on non-paranoid returns.  I suspect that this is a mistake
> and that the code only works because int3 is paranoid.
> 
> Setting _TIF_NOTIFY_RESUME in the uprobe code was probably a
> workaround for the x86 bug.  With that bug fixed, we can remove
> _TIF_NOTIFY_RESUME from the uprobes code.
> 
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
