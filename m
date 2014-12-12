Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031058AbaLLRR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:17:29 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:63319 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030596AbaLLRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:17:26 -0500
MIME-Version: 1.0
In-Reply-To: <548B18AC.9@upv.es>
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Dec 2014 09:17:05 -0800
Message-ID: <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
To: Hector Marco <hecmargi@upv.es>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
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

On Dec 12, 2014 8:33 AM, "Hector Marco" <hecmargi@upv.es> wrote:
>
> Hello,
>
> I agree. I don't think a new randomization mode will be needed, just fix
> the current randomize_va_space=2. Said other way: fixing the offset2lib
> will not break any current program and so, no need to add additional
> configuration options. May be we shall wait for some inputs
> from the list (may be we are missing something).
>
>
> Regarding to VDSO, definitively, is not randomized enough in 64bits.
> Brute force attacks would be pretty fast even from the network.
> I have identified the bug and seems quite easy to fix it.
>
> On 32bit systems, this is not a issue because it is mapped in the
> mmap area. In order to fix the VDSO on 64bit, the following
> considerations shall
> be discussed:
>
>
> Performance:
>     It seems (reading the kernel comments) that the random allocation
>     algorithm tries to place the VDSO in the same PTE than the stack.

The comment is wrong.  It means PTE table.

>     But since the permissions of the stack and the VDSO are different
>     it seems that are getting right the opposite.

Permissions have page granularity, so this isn't a problem.

>
>     Effectively VDSO shall be correctly randomized because it contains
>     enough useful exploitable stuff.
>
>     I think that the possible solution is follow the x86_32 approach
>     which consist on map the VDSO in the mmap area.
>
>     It would be better fix VDSO in a different patch ? I can send a
>     patch which fixes the VDSO on 64 bit.
>

What are the considerations for 64-bit memory layout?  I haven't
touched it because I don't want to break userspace, but I don't know
what to be careful about.

--Andy

>
>
> Regards,
> Hector Marco.
