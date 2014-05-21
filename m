Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaEUWVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:21:13 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:40409 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbaEUWVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:21:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140521221728.GM25130@pd.tnic>
References: <CALCETrU34B6XMmxcN2ix1bhnPFVRp5vNjyjxXMGYiOERZD483A@mail.gmail.com>
 <alpine.LRH.2.00.1405211450410.27739@twin.jikos.cz> <CALCETrXO9EyWs5hykkAO2wU8udW0WE9AHfvjGog7s9ydPf4iEw@mail.gmail.com>
 <20140521163315.GJ21205@pd.tnic> <alpine.LNX.2.00.1405212323190.12047@pobox.suse.cz>
 <CALCETrVPVcyTd8FYV90DPhKvGW1GhHxkUPObpXK69AhwwqLi1w@mail.gmail.com>
 <20140521214845.GG25130@pd.tnic> <CALCETrUr75gGj3E5cSZdGRpX-wd6pDzDruMGave+GbnpWaptRA@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F328116D8@ORSMSX114.amr.corp.intel.com>
 <CALCETrWA1X-X7W7MZn5eYEO-hxWWYk3APORmH-1dw=5ua1dG+A@mail.gmail.com> <20140521221728.GM25130@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 21 May 2014 15:20:50 -0700
Message-ID: <CALCETrWY4OW0FF3vsS+ntALU_kmmcEB9wf0RMg-H5kSO7jQ-wQ@mail.gmail.com>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
To: Borislav Petkov <bp@alien8.de>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <jkosina@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 3:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, May 21, 2014 at 03:13:16PM -0700, Andy Lutomirski wrote:
>> Why is this necessary?
>>
>> If the MCE hit kernel code, then we're going to die anyway.  If the
>> MCE hit user code, then we should be in a completely sensible context
>> and we can just send the signal.
>
> Are we guaranteed that the first thing the process will execute when
> scheduled back in are the signal handlers?

It's not even scheduled out, right?  This should be just like a signal
from a failed page fault, I think.

>
> And besides, maybe we don't even want to allow to do the switch_to() but
> kill it while it is sleeping.

What switch_to?

--Andy
