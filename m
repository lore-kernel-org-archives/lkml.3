Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaKMADA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 19:03:00 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:40222 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaKMAC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 19:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141112220058.GA5295@redhat.com> <CALCETrWA5z7-1fiz_9N0Qi2OR5s1jCkHiynCtTD_+9taOBs-Mg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292BAB4@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Nov 2014 16:02:37 -0800
Message-ID: <CALCETrU8uyc4nu-5MBXQR0PY0rexUhPkuPRLK+gWt0gEWMDhTA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 3:41 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> v2 coming soon with these changes and some additional comment cleanups.
>

v2's not going to make a difference unless you're using uprobes at the
same time.

> So v1 + do_machine_check change is not surviving some real testing.  I'm injecting and
> consuming errors sequentially with a small delay in between - so no fancy corner cases with
> multiple errors being processed ... we get all the way done with one error before we start
> the next.  Test only survives about 400ish recoveries before Linux dies complaining:
>     "Timeout synchronizing machine check over CPUs".
> This probably means that some cpu wandered into the weeds and never showed up in the
> handler.

In the interest of my sanity, can you add something like
BUG_ON(!user_mode_vm(regs)) or the mce_panic equivalent before calling
memory_failure?

What happens if there's a shared bank but the actual offender has a
higher order than the cpu that finds the error?

Is this something I can try under KVM?

--Andy
