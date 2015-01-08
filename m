Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbbAHMcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 07:32:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbbAHMcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 07:32:18 -0500
Message-ID: <54AE78C9.9010308@redhat.com>
Date: Thu, 08 Jan 2015 13:32:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrej Manduch <amanduch@gmail.com>, Nicholas Krause <xerofoify@gmail.com>,
        gleb@kernel.org
CC: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] arch:x86:kvm:Add function for setting pending timer
 on virtual cpu in x86.c
References: <1420167918-2190-1-git-send-email-xerofoify@gmail.com> <54AE709B.2040605@redhat.com> <54AE74F2.7050700@gmail.com>
In-Reply-To: <54AE74F2.7050700@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/01/2015 13:15, Andrej Manduch wrote:
>>> >> -	/* FIXME: this code should not know anything about vcpus */
> I don't want to sounds like I'm nitpicking. But I need to ask. Why is
> this comment removed?

Because the real point of the comment was that the code should not know
anything about VCPU requests.  But it's okay to call a function to tell
the VCPU "we want you to call us back at kvm_inject_apic_timer_irqs".

Paolo

>>> >> -	kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
>>> >> +	kvm_set_pending_timer(vcpu);
