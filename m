Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbaLLXFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:05:02 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:61373 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaLLXFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <548B60F4.6020903@sr71.net>
References: <20141212191213.579887D2@viggo.jf.intel.com> <548B4E75.5010507@amacapital.net>
 <548B4FBE.5090101@sr71.net> <CALCETrW4f3EUYGG_zyzb7sZBXaoW3eHMpTn3dd3WpDgJq2HjtA@mail.gmail.com>
 <548B60F4.6020903@sr71.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 15:04:38 -0800
Message-ID: <CALCETrVZcED1x+YV4V+c9nnieaz8DMbO4D455h2QYF__jX-DKg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] x86, mpx: Support 32-bit binaries on 64-bit kernels
To: Dave Hansen <dave@sr71.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Fri, Dec 12, 2014 at 1:41 PM, Dave Hansen <dave@sr71.net> wrote:
> On 12/12/2014 12:48 PM, Andy Lutomirski wrote:
>> On Fri, Dec 12, 2014 at 12:27 PM, Dave Hansen <dave@sr71.net> wrote:
>>> You want the same size structures with the same format for 32-bit and
>>> 64-bit modes?
>>
>> Yes.  Especially because programs can switch between 32-bit and 64-bit
>> mode entirely in userspace.  I don't know whether any do in practice,
>> but programs *can*.
>
> So, you want a 2GB of the 32-bit address space dedicated to a bounds
> directory, and half of the space for the bounds tables to be simply
> zero-filled unused address bits?  That seems, um, a bit unreasonable.

Fair enough.

>
>> Or better yet: Intel could have skipped supporting it at all in 32-bit
>> mode.
>
> So, we should not have this security feature for 32-bit apps... because
> it costs us 50 lines of code in the kernel to support?  Did you look at
> the diffstat?
>
>> Isn't mpx somewhat of an address space hog anyway?
>
> Yes, it will be troublesome for 32-bit apps that are already bumping up
> against the virtual address space size to support it.  But, really, how
> many of those *are* there these days?

I wonder how many 32-bit apps will end up using mpx regardless.

Anyway, do your patches handle the case where a 32-bit app maliciously
executes a 64-bit mpx insn with a very large address?  I think it's
okay, but I might have missed something.

--Andy
