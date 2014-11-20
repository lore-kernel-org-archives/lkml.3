Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbaKTK2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:28:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50285 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbaKTK2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:28:38 -0500
Date: Thu, 20 Nov 2014 11:28:36 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack
 in schedule and __might_sleep
Message-ID: <20141120102836.GB791@pd.tnic>
References: <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
 <20141119192928.GL12538@two.firstfloor.org>
 <CA+55aFwykb6aZYgyZXbU1DQ3OL0umpv8gkHYWykBEC2B7UdMbw@mail.gmail.com>
 <CALCETrXi7vdNAk4RziNDtqX4asPqXxi1VsLzL7pP0zivkjTH4Q@mail.gmail.com>
 <CA+55aFx4-WzNQ0e-ZTcCig3b7U7xmt1WB1jzO3TLk9zHD006ng@mail.gmail.com>
 <CALCETrVJJUcPRfkWRouLJCNUVNRH3aWX0X_K8L62yrUu1aR8Vg@mail.gmail.com>
 <CA+55aFy0neTJAAm-8KsmPPU33zevyHmYa+vZjPk-DozSPPW_nQ@mail.gmail.com>
 <CALCETrXzMe2WcpY3yX48WtvdRQDvSg7CZRO1T1TdLynmAcJHXg@mail.gmail.com>
 <CA+55aFxNkD8=1JB0-4EyQTR+Yd0YaofB3+E5J+L3vsfki-RUSQ@mail.gmail.com>
 <CALCETrWBpmS_W3sN3Pf-qRL8jgxoBoQWnQuk3r_TT_eBm9eNqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWBpmS_W3sN3Pf-qRL8jgxoBoQWnQuk3r_TT_eBm9eNqQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 04:46:29PM -0800, Andy Lutomirski wrote:
> So we'd do, in do_machine_check:
> 
> irq_enter();
> 
> do atomic stuff;
> 
> ist_stop_being_atomic(regs);
> local_irq_enable();
> ...
> local_irq_disable();
> ist_start_being_atomic_again();

Well, why would I want to go atomic again? We just do the minimally
needed atomic stuff, irq_exit() and then do the rest.

> 
> irq_exit();

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
