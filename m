Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaKKSWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:22:42 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47967 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbaKKSWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:22:41 -0500
Date: Tue, 11 Nov 2014 19:22:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chen Gong <gong.chen@linux.intel.com>, X86 ML <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141111182235.GL31490@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic>
 <CALCETrULeLC3MhqdG5yJKXp9YL6ir3gOO4e9WGt1X3kkKMXdJw@mail.gmail.com>
 <20141111161309.GG31490@pd.tnic>
 <CALCETrWqGkNBCsPr5QLt4dQSH2mwDgN2tfKy7fqVG4ERZW8e2Q@mail.gmail.com>
 <20141111163059.GH31490@pd.tnic>
 <CALCETrX+u-LZV0GGudi8z-VtcY0y7BD8Yk_4BgTA5C5hekVAtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrX+u-LZV0GGudi8z-VtcY0y7BD8Yk_4BgTA5C5hekVAtQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 09:15:18AM -0800, Andy Lutomirski wrote:
> Oh -- does it need to sleep?

Oh yeah, iterates over all tasks and generally async access to VM stuff.
You can have a look if bored: mm/memory-failure.c

:-)

> I find myself wondering whether a much cleaner solution might be to
> sync regs and switch stacks before invoking do_machine_check rather
> than afterwards.  Then do_machine_check would really be completely
> non-atomic.  It would add a few lines of asm, though.

That's like wagging the dog.

I'd prefer much more to actually have a mechanism to do something to
tasks before scheduling them in.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
