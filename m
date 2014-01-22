Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaAVAb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 19:31:59 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39103 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaAVAb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 19:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <52DE9BB0.5070909@hp.com>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
	<1389761047-47566-4-git-send-email-Waiman.Long@hp.com>
	<20140120150316.GG30183@twins.programming.kicks-ass.net>
	<52DE9410.6090500@hp.com>
	<20140121153958.GA31570@twins.programming.kicks-ass.net>
	<52DE9BB0.5070909@hp.com>
Date: Tue, 21 Jan 2014 16:31:56 -0800
X-Google-Sender-Auth: bKZ0SqAWKm0T5lGiojA2oXCD-8c
Message-ID: <CA+55aFzyww_kwU36jYk=LUtxzPUU76xgnQEOUTqGMFNe80sOZA@mail.gmail.com>
Subject: Re: [PATCH v9 3/5] qrwlock, x86 - Treat all data type not bigger than
 long as atomic in x86
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 8:09 AM, Waiman Long <waiman.long@hp.com> wrote:
>
> include/linux/compiler.h:
>
> #ifndef __native_word
> # ifdef __arch_native_word(t)
> #  define __native_word(t)      __arch_native_word(t)
> # else
> #  define __native_word(t) (sizeof(t) == sizeof(int) || sizeof(t) == siizeof(long))
> # endif
> #endif

Do we even really need this?

I'd suggest removing it entirely. You might want to retain the whole

  compiletime_assert_atomic_type()

thing on purely the alpha side, but then it's all inside just the
alpha code, without any need for this "native_word" thing.

And if somebody tries to do a "smp_store_release()" on a random
structure or union, do we care? We're not some nanny state that wants
to give nice warnings for insane code.

              Linus
