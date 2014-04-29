Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbaD2Qvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaD2Qvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:51:38 -0400
From: Bandan Das <bsd@redhat.com>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Emulate VMXON region correctly
References: <1398661204-4822-1-git-send-email-bsd@redhat.com>
	<535E3C10.9020403@siemens.com>
Date: Tue, 29 Apr 2014 12:51:33 -0400
In-Reply-To: <535E3C10.9020403@siemens.com> (Jan Kiszka's message of "Mon, 28
	Apr 2014 13:31:28 +0200")
Message-ID: <jpglhuoxene.fsf@nelium.bos.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka <jan.kiszka@siemens.com> writes:

> On 2014-04-28 07:00, Bandan Das wrote:
>> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=54521
>> 
>> The vmxon region is unused by nvmx, but adding these checks
>> are probably harmless and may detect buggy L1 hypervisors in 
>> the future!
>
> Nice and welcome! Will you provide unit tests for these cases as well?

Yeah, this and test cases for ACK_INTR_ON_EXIT are in my todo list :)
I will follow up soon..

> Jan
>
>> 
>> Bandan Das (3):
>>   KVM: nVMX: rearrange get_vmx_mem_address
>>   KVM: nVMX: additional checks on vmxon region
>>   KVM: nVMX: fail on invalid vmclear/vmptrld pointer
>> 
>>  arch/x86/kvm/vmx.c | 171 ++++++++++++++++++++++++++++++++++++-----------------
>>  1 file changed, 118 insertions(+), 53 deletions(-)
>> 
