Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaKKQbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:31:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48627 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbaKKQbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:31:04 -0500
Date: Tue, 11 Nov 2014 17:30:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chen Gong <gong.chen@linux.intel.com>, X86 ML <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141111163059.GH31490@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic>
 <CALCETrULeLC3MhqdG5yJKXp9YL6ir3gOO4e9WGt1X3kkKMXdJw@mail.gmail.com>
 <20141111161309.GG31490@pd.tnic>
 <CALCETrWqGkNBCsPr5QLt4dQSH2mwDgN2tfKy7fqVG4ERZW8e2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWqGkNBCsPr5QLt4dQSH2mwDgN2tfKy7fqVG4ERZW8e2Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 08:22:45AM -0800, Andy Lutomirski wrote:
> I think it's okay-ish, but only if it's necessary, and I still don't
> see why it's necessary.
> 
> Can't you just remove TIF_MCE_NOTIFY entirely and just do all the
> mce_notify_process work directly in do_machine_check?  IOW, why do you
> need to store any state per-task when it's already on the stack
> anyway.

I wish but memory_failure() can't run in #MC context as it noodles
quite a lot and grabs all kinds of locks and does a bunch of other
atomit-context-unsafe things.

And it needs to run *before* the process is killed as it looks at its
pages.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
