Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936514Ab3DHXAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 19:00:07 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:58219 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936202Ab3DHXAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 19:00:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.03.1304082350540.25182@linux-mips.org>
References: <20130408224328.GA17641@www.outflux.net>
	<alpine.LFD.2.03.1304082350540.25182@linux-mips.org>
Date: Mon, 8 Apr 2013 16:00:04 -0700
X-Google-Sender-Auth: txWKUZzv6qYzTO1m4ENagqpGk6M
Message-ID: <CAGXu5jJCZh6JeFBOH5nn0uqWOic9BCBnJ5CEhAEkvesZ7BguqA@mail.gmail.com>
Subject: Re: [PATCH] x86: make IDT read-only
From: Kees Cook <keescook@chromium.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 3:56 PM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
> On Mon, 8 Apr 2013, Kees Cook wrote:
>
>> This makes the IDT unconditionally read-only. This primarily removes
>> the IDT from being a target for arbitrary memory write attacks. It has
>> an added benefit of also not leaking (via the "sidt" instruction) the
>> kernel base offset, if it has been relocated.
> [...]
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -215,7 +201,6 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>>
>>               c->f00f_bug = 1;
>>               if (!f00f_workaround_enabled) {
>> -                     trap_init_f00f_bug();
>>                       printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
>>                       f00f_workaround_enabled = 1;
>>               }
>
>  FWIW the change looks reasonable to me, however given that that it makes
> the arrangement unconditional and there is no longer a workaround to
> enable I think it would make sense to remove the conditional block quoted
> above altogether, along with the f00f_workaround_enabled variable itself
> (alternatively "Intel Pentium with F0 0F bug" alone could be printed
> instead and the name of the variable adjusted to make sense with the new
> meaning -- up to you to decide).

Ah, yes, I misread this and didn't see that the ifdef ended 2 lines
further down. :) I'll just remove the entire section of code.

-Kees

--
Kees Cook
Chrome OS Security
