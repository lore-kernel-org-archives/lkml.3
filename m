Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535Ab3JISyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:54:07 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:52135 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3JISyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:54:06 -0400
MIME-Version: 1.0
In-Reply-To: <20131009181613.GW30970@tucnak.zalov.cz>
References: <20131005234430.GA22485@localhost>
	<CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	<20131008143400.GA14721@redhat.com>
	<20131009080459.GA2298@localhost>
	<20131009124310.GA11769@redhat.com>
	<20131009140734.GH3081@twins.programming.kicks-ass.net>
	<20131009143359.GU26785@twins.programming.kicks-ass.net>
	<20131009144656.GV26785@twins.programming.kicks-ass.net>
	<20131009181613.GW30970@tucnak.zalov.cz>
Date: Wed, 9 Oct 2013 11:54:04 -0700
X-Google-Sender-Auth: tRxZyQIs1kbB2SWwlmqGdWrV3gI
Message-ID: <CA+55aFzUWkBWnoLh3rYSoQmeCrRvJDTV0jLHpkGKEGixxgD8Rw@mail.gmail.com>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 11:16 AM, Jakub Jelinek <jakub@redhat.com> wrote:
>
> Confirmed as gcc bug, filed http://gcc.gnu.org/PR58670
> Seems all of 4.[6-9] miscompile it.  Will have a look tomorrow
> unless somebody beats me to it.  But historically, the case where
> asm goto labels jump to fallthru basic block had numerous problems in the
> past.

Ok, so it isn't even specific for x86-32, because your test-case shows
the bug for me on 64-bit too. Apparently we just have a harder time
hitting it in practice in the kernel on x86-64./

Too bad. It makes me nervous about all our _traditional_ uses of asm
goto too, never mind the new ones..

              Linus
