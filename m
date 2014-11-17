Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaKQUGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 15:06:22 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55012 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaKQUGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 15:06:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141117200354.GB25157@pd.tnic>
References: <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic> <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
 <20141112162225.GF16807@pd.tnic> <20141113180436.GG14070@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3293BEAE@ORSMSX114.amr.corp.intel.com>
 <20141117185030.GA25157@pd.tnic> <CALCETrXOPc3j8dC3rMS1jbcAofZkXDhFupbtHZgYw1JpmZasOQ@mail.gmail.com>
 <20141117200354.GB25157@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Nov 2014 12:05:59 -0800
Message-ID: <CALCETrW75rES4=c1AYFXO0pobTZVjb6gYzpgWb0f9jAjYYduPQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:03 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Nov 17, 2014 at 11:57:22AM -0800, Andy Lutomirski wrote:
>> Would it be worth making a decision on task_work_add vs. stack
>> switching first?
>
> Probably a prudent thing to do in order to save unnecessary cycles :-)
>
>> Stack switching pros: all this lockless allocation stuff is completely
>> unnecessary, and it's plausible that the stack switching code will be
>> added anyway.
>
> Yes.
>
> However, I'd like to be very sure this thing doesn't introduce any
> regressions to the MCA code. So even if Tony's testing passes, I'd like
> to be very conservative here and stress it more than usual. Because once
> this thing hits upstream and stuff starts breaking, it'll be a serious
> PITA reverting it.
>
> I hope you can understand my concerns.

I agree completely.

>
> Btw, which branch has your latest version - I'd like to take a look at
> it in detail.

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/paranoid

I'm not quite ready to send v3.  I want to do two things first:

1. Consider disabling the stack switch for double_fault.

2. Clean up the macros.  I'll validate this by ensuring that the
generated code is identical to the current version.

IOW, I don't expect the asm for machine_check to change.

--Andy
