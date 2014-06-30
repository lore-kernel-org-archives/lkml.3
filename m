Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaF3Scy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbaF3Scv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:32:51 -0400
From: Bandan Das <bsd@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, Nadav Amit <namit@cs.technion.ac.il>,
        gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Fix lapic.c debug prints
References: <1404034131-2392-1-git-send-email-namit@cs.technion.ac.il>
	<jpgr427kys6.fsf@redhat.com> <53B0B773.3030107@gmail.com>
	<53B1541E.4080008@redhat.com>
Date: Mon, 30 Jun 2014 13:39:48 -0400
In-Reply-To: <53B1541E.4080008@redhat.com> (Paolo Bonzini's message of "Mon,
	30 Jun 2014 14:12:14 +0200")
Message-ID: <jpgsimmuwij.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Il 30/06/2014 03:03, Nadav Amit ha scritto:
>>>>
>>>>           sipi_vector = apic->sipi_vector;
>>>> -        pr_debug("vcpu %d received sipi with vector # %x\n",
>>>> +        apic_debug("vcpu %d received sipi with vector # %x\n",
>>>
>>> Why don't we just use pr_debug all throughout ?
>>>
>> I don't know. I just tried to make it consistent, since it really bugged
>> me while I was debugging the local-apic.
>> If you prefer the other way around (which does seem to be better), I can
>> do the search-and-replace.
>
> vcpu number probably could be moved inside apic_debug, at which point
> apic_debug becomes preferrable.

I am not sure, I think all that could be achieved with a file private 
debug define can be done with pr_debug which is generic.
Nadav didn't introduce apic_debug to this file, so I am
fine either way.

> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
