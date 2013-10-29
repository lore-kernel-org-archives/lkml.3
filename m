Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab3J2QpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:45:18 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:60060 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758291Ab3J2QpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:45:15 -0400
MIME-Version: 1.0
In-Reply-To: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
References: <1383059634-55512-1-git-send-email-tim.gardner@canonical.com>
Date: Tue, 29 Oct 2013 09:45:11 -0700
X-Google-Sender-Auth: YrlZOhty_TJzqRs-X2-4HM6vh2I
Message-ID: <CA+55aFwUdXp4412F5LdmCRrGZCYiFpiPk7oksGi30CzP6i5O+w@mail.gmail.com>
Subject: Re: [PATCH 3.12-rc7] KVM: Fix modprobe failure for kvm_intel/kvm_amd
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Gleb Natapov <gleb@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh. I won't comment on the actual kvm part of this patch, somebody
who knows that code should do so.

But I reacted to this:

On Tue, Oct 29, 2013 at 8:13 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
>
> sudo modprobe kvm_amd
> modprobe: ERROR: could not insert 'kvm_amd': Bad address

"Bad address"? Christ people, are you guys making up error numbers
with some kind of dice-roll? I can just see it now, somebody sitting
there with a D20, playing some kind of kernel-specific D&D, and
rolling a ten means that you get to slay the orc, and pick an error
number of EFAULT for some random kernel function. Because quite
frankly, "random dice roll" is the _only_ thing that explains "Bad
address" sufficiently.

Please, whoever wrote virt/kvm/kvm_main.c:: kvm_init_debug(), WTF?
EFAULT means "user passed in an invalid virtual address pointer",
which is why the error string is "Bad address". It makes absolutely NO
SENSE here. Perhaps EEXIST or EBUSY.

                  Linus
