Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbaKRQNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:13:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48804 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbaKRQNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:13:07 -0500
Date: Tue, 18 Nov 2014 17:12:59 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141118161259.GC5238@pd.tnic>
References: <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic>
 <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic>
 <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic>
 <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:05:59PM -0800, Andy Lutomirski wrote:
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/paranoid
> 
> I'm not quite ready to send v3.  I want to do two things first:
> 
> 1. Consider disabling the stack switch for double_fault.

Sounds conservatively nice :)

> 2. Clean up the macros.  I'll validate this by ensuring that the
> generated code is identical to the current version.
> 
> IOW, I don't expect the asm for machine_check to change.

Right, so I don't see anything wrong with the patch but entry_64.S is
nasty so don't take my word for it.

I guess handlers should need to do "if (user_mode_vm(regs))" after your
change now, in order to know what to do.

I'll try to do some error injection here too, on my boxes to see how
this behaves.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
