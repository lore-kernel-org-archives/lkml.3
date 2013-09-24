Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3IXKdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:33:24 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:41454 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3IXKdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:33:23 -0400
MIME-Version: 1.0
In-Reply-To: <87fvsudfjy.fsf@tassilo.jf.intel.com>
References: <CACu8kRTN7XoTxvcFHQ=7N-rUGoUePS43EwRKax25mqBjzEXNVg@mail.gmail.com>
	<87fvsudfjy.fsf@tassilo.jf.intel.com>
Date: Tue, 24 Sep 2013 11:33:22 +0100
Message-ID: <CACu8kRR0+Z2_ip5N1Ois9U-NdmpbJ4=xn20cikNajhcL+DAvvw@mail.gmail.com>
Subject: Re: Lightweight type analysis for memory safety through verification
 of API uses
From: Marcelo Sousa <marceloabsousa@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, msousa@cs.ox.ac.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Andi,

Thanks for the reply.

On Tue, Sep 24, 2013 at 5:11 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Marcelo Sousa <marceloabsousa@gmail.com> writes:
>
>> I've designed and implemented a tool similar to sparse and CQUAL that
>> does type inference of user specified type qualifiers, e.g. iomem. It
>> receives an API specification with the type qualifiers and also a
>> partial order, e.g. IOAddr is not compatible with KernelAddr and
>> ioremap returns a pointer to IOAddr while __kmalloc returns a pointer
>> to a KernelAddr.
>
> Tracking iomem is ultimatively not very interesting, as in many common
> architectures it's just a normal pointer.

My motivation for tracking iomem was the fact that cmpxchg in x86 had
the side effect of always writing to the memory pointer even if the
comparison fails. Since the iomem pointer could be pointing to a
non-readable location performing a cmpxchg would always result in
memory corruption.

>
> __user is much more interesting, as that is real security bugs.
> You can probably find some in standard security advisories.

Yes, there has been research on user vs kernel pointer separation, and
I'm focusing on that at the moment. However, I can't really find any
recent bugs on this topic. If you can provide pointers that would be
great.

>
> Really interesting would be static lock set tracking for pointers
> and similar.

Is this to track that lock/unlock is correctly modelled (no double
lock, no unlock before lock, deadlock) or do you have a specific goal
in mind? Again, if you know of any existing bugs or a particular
pattern that you are interested in verifying that would be great.

Kind regards,
Marcelo

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
