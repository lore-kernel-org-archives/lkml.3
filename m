Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbaKST3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:29:31 -0500
Received: from one.firstfloor.org ([193.170.194.197]:53890 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbaKST3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:29:30 -0500
Date: Wed, 19 Nov 2014 20:29:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v3 3/3] sched, x86: Check that we're on the right stack
 in schedule and __might_sleep
Message-ID: <20141119192928.GL12538@two.firstfloor.org>
References: <cover.1416352397.git.luto@amacapital.net>
 <c25e1a64e5b718fa156e141fd9ecbf31011c6059.1416352397.git.luto@amacapital.net>
 <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFztsw6Vt4CyVs1OsqdKXxQmFrxHdE7z89VMZ_1KwKPcmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:40:10AM -0800, Linus Torvalds wrote:
> On Tue, Nov 18, 2014 at 3:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On x86, sleeping while on an IST or irq stack has a surprisingly
> > good chance of working, but it can also fail dramatically.  Add an
> > arch hook to allow schedule and __might_sleep to catch sleeping on
> > the wrong stack.
> 
> Why doesn't the normal in_interrupt() test catch this?

The exception handlers which use the IST stacks don't necessarily 
set irq count. Maybe they should.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
