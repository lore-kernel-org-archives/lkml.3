Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaLVUAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:00:40 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43528 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbaLVUAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:00:39 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1412222047090.1680@pobox.suse.cz>
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es> <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es> <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
 <20141222183615.4193722q3opf4uj3@webmail.upv.es> <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
 <alpine.LNX.2.00.1412222047090.1680@pobox.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 12:00:17 -0800
Message-ID: <CALCETrU0BjPJjG8ohm6-KA-wR+DGjmoFOd4MkNqEQRtXxz6iqw@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
To: Jiri Kosina <jkosina@suse.cz>
Cc: Hector Marco Gisbert <hecmargi@upv.es>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:49 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 22 Dec 2014, Andy Lutomirski wrote:
>
>> a. With PIE executables, the offset from the executable to the
>> libraries is constant.  This is unfortunate when your threat model
>> allows you to learn the executable base address and all your gadgets
>> are in shared libraries.
>
> When I was originally pushing PIE executable randomization, I have been
> thinking about ways to solve this.
>
> In theory, we could start playing games with load_addr in
> load_elf_interp() and randomizing it completely independently from mmap()
> base randomization, but the question is whether it's really worth the
> hassle and binfmt_elf code complication. I am not convinced.

It could be worth having a mode that goes all out: randomize every
single allocation independently in, say, a 45 or 46-byte range.  That
would be about as strong ASLR as we could possibly have, it would
result in guard intervals around mmap data allocations (which has real
value), and it would still leave plenty of space for big address space
hogs like the Chromium sandbox.

The main downside would be lots of memory used for page tables.

--Andy

>
> --
> Jiri Kosina
> SUSE Labs



-- 
Andy Lutomirski
AMA Capital Management, LLC
