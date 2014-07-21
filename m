Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaGUVaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:30:24 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:58126 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaGUVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:30:22 -0400
Message-ID: <53CD866A.9020704@gmail.com>
Date: Tue, 22 Jul 2014 00:30:18 +0300
From: Nadav Amit <nadav.amit@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Nadav Amit <namit@cs.technion.ac.il>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: x86: Function for determining exception type
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il> <1405942650-22589-3-git-send-email-namit@cs.technion.ac.il> <53CD0514.8040308@redhat.com>
In-Reply-To: <53CD0514.8040308@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few comments to see we are on the same page:

On 7/21/14, 3:18 PM, Paolo Bonzini wrote:
> Il 21/07/2014 13:37, Nadav Amit ha scritto:
>> +int kvm_exception_type(unsigned int nr)
>
> The manual calls this the exception class.
Yes, but it also calls it exception "type" (see table 6-1 
"Protected-Mode Exceptions and Interrupts" on the SDM).
I called it exception type, since there is a function exception_class 
that is used to handle nested exceptions.

>> +	case VE_VECTOR:
>> +		return EXCPT_FAULT;
>> +	case DB_VECTOR:
>> +		return EXCPT_FAULT_OR_TRAP;
>
> It is only a fault for instruction fetch breakpoints.  You can modify
> kvm_vcpu_check_breakpoint to set RF, add a comment here that fault
> handling is done elsewhere, and return EXCPT_TRAP.
Unless I am mistaken, kvm_vcpu_check_breakpoint checks only for 
instruction breakpoint. Since instruction breakpoint should not cause RF 
to be set, this function should not be changed.

Anyhow, I would return EXCPT_TRAP on DB_VECTOR.

Nadav

