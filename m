Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaFRRdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaFRRdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:33:43 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <namit@cs.technion.ac.il>, gleb@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joro@8bytes.org
Subject: Re: [PATCH 3/3] KVM: x86: correct mwait and monitor emulation
References: <1403101176-23664-1-git-send-email-namit@cs.technion.ac.il>
	<1403101176-23664-4-git-send-email-namit@cs.technion.ac.il>
	<jpg7g4ew4m6.fsf@redhat.com> <53A1C1F2.4010909@redhat.com>
Date: Wed, 18 Jun 2014 13:33:27 -0400
In-Reply-To: <53A1C1F2.4010909@redhat.com> (Paolo Bonzini's message of "Wed,
	18 Jun 2014 18:44:34 +0200")
Message-ID: <jpgtx7iazrs.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 18/06/2014 18:43, Bandan Das ha scritto:
>>> > mwait and monitor are currently handled as nop. Considering this behavior, they
>>> > should still be handled correctly, i.e., check execution conditions and generate
>>> > exceptions when required. mwait and monitor may also be executed in real-mode
>> Is this necessary ? They are NOPs and kvm prints that out (correctly so) to dmesg.
>> Implementing them correctly is a different thing, but adding extra checks for NOPs
>> just seems like adding extra cycles.
>
> Raising the correct exception is a good thing, though.  The guest is
> going to busy wait anyway, it doesn't matter how fast it does that. :)

Thanks, makes sense. I was also thinking why to advertise it at all, but it's 
probably more common than I think it is.

> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
