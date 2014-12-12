Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968207AbaLLQec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:34:32 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:47486 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S968139AbaLLQeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:34:31 -0500
Message-ID: <548B18AC.9@upv.es>
Date: Fri, 12 Dec 2014 17:32:44 +0100
From: Hector Marco <hecmargi@upv.es>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Arun Chandran <achandran@mvista.com>,
        =?ISO-8859-1?Q?Hanno_B=F6ck?= <hanno@hboeck.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Oleg Nesterov <oleg@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Reno Robert <renorobert@gmail.com>,
        Ismael Ripoll <iripoll@disca.upv.es>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es> <20141211221158.GS18807@outflux.net>
In-Reply-To: <20141211221158.GS18807@outflux.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I agree. I don't think a new randomization mode will be needed, just fix
the current randomize_va_space=2. Said other way: fixing the offset2lib
will not break any current program and so, no need to add additional
configuration options. May be we shall wait for some inputs
from the list (may be we are missing something).


Regarding to VDSO, definitively, is not randomized enough in 64bits.
Brute force attacks would be pretty fast even from the network.
I have identified the bug and seems quite easy to fix it.

On 32bit systems, this is not a issue because it is mapped in the
mmap area. In order to fix the VDSO on 64bit, the following
considerations shall
be discussed:


Performance:
    It seems (reading the kernel comments) that the random allocation
    algorithm tries to place the VDSO in the same PTE than the stack.
    But since the permissions of the stack and the VDSO are different
    it seems that are getting right the opposite.

    Effectively VDSO shall be correctly randomized because it contains
    enough useful exploitable stuff.

    I think that the possible solution is follow the x86_32 approach
    which consist on map the VDSO in the mmap area.

    It would be better fix VDSO in a different patch ? I can send a
    patch which fixes the VDSO on 64 bit.



Regards,
Hector Marco.
