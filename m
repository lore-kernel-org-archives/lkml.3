Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaGHIAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:00:41 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:46794 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaGHIAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:00:40 -0400
Message-ID: <53BBA523.4080006@redhat.com>
Date: Tue, 08 Jul 2014 10:00:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, Bandan Das <bsd@redhat.com>,
        kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH] KVM: x86: Check for nested events if there is an injectable
 interrupt
References: <jpgd2dgfp5s.fsf@redhat.com> <53BB86C2.9040805@redhat.com> <53BB9638.6040803@siemens.com>
In-Reply-To: <53BB9638.6040803@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/07/2014 08:56, Jan Kiszka ha scritto:
> I don't think arch.nmi_pending can flip asynchronously, only in the
> context of the VCPU thread - in contrast to pending IRQ states.

Right, only nmi_queued is changed from other threads.  /me should really 
look at the code instead of going from memory.

>> Jan, what do you think?  Can you run Jailhouse through this patch?
>
> Jailhouse seems fine with it, and it resolves the lockup of nested KVM
> here as well.

Thinking more about it, I think this is the right fix.  Not setting 
KVM_REQ_EVENT in some cases can be an optimization, but it's not 
necessary.  Definitely there are other cases in which KVM_REQ_EVENT is 
set even though no event is pending---most notably during emulation of 
invalid guest state.

Paolo
