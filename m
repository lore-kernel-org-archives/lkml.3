Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835AbaGWVxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 17:53:17 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:62093 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543AbaGWVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 17:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <8738drrcxp.fsf@tassilo.jf.intel.com>
References: <CALCETrVx=cLZjgALizYKWATSjOvhmwPHQvOJRkMgdb=iNRNf8w@mail.gmail.com>
 <8738drrcxp.fsf@tassilo.jf.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Jul 2014 14:52:53 -0700
Message-ID: <CALCETrWKQgnZfNmcQcROc1rOuoks7=P6VjGvwoE3aP4jTTgC0A@mail.gmail.com>
Subject: Re: STI architectural question (and lretq -- I'm not even kidding)
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:18 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> I think an MCE just might be okay -- it's not
>> really recoverable anyway.
>
> That's wrong.

I think that, other than broadcast MCEs, #MC that hits in kernel mode
is non-recoverable, or at least can't safely be recovered.  (There's a
separate APIC interrupt for recoverable errors, I think, but that's a
much saner interface.)

Regardless, I put in a fixup in the patches I sent out -- they should
be just as safe as existing code if a #MC hits right after sti.  I
have no idea how to test that, though...

--Andy

>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only



-- 
Andy Lutomirski
AMA Capital Management, LLC
