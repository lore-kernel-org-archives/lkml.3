Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbbA1Uzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:51 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36331 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbbA1Uzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:46 -0500
Message-ID: <54C8CCA0.8080806@huawei.com>
Date: Wed, 28 Jan 2015 19:48:48 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nadav Amit <namit@cs.technion.ac.il>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: Re: [PATCH 3.4 081/177] KVM: x86: Emulator fixes for eip canonical
 checks on near branches
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-161-git-send-email-lizf@kernel.org> <A7FCAD0F-53C8-4B5F-9ABA-1EB4858AB289@gmail.com>
In-Reply-To: <A7FCAD0F-53C8-4B5F-9ABA-1EB4858AB289@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/28 16:49, Nadav Amit wrote:
> There is a bug in this patch, so please include
> 7e46dddd6f6cd5dbf3c7bd04a7e75d19475ac9f2 ("KVM: x86: Fix far-jump to
> non-canonical check”) as well.

Applied. Thanks!

> 
> Regards,
> Nadav
> 
> lizf@kernel.org wrote:
> 
>> From: Nadav Amit <namit@cs.technion.ac.il>
>>
>> 3.4.106-rc1 review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>>
>> commit 234f3ce485d54017f15cf5e0699cff4100121601 upstream.
>>
>> Before changing rip (during jmp, call, ret, etc.) the target should be asserted
>> to be canonical one, as real CPUs do.  During sysret, both target rsp and rip
>> should be canonical. If any of these values is noncanonical, a #GP exception
>> should occur.  The exception to this rule are syscall and sysenter instructions
>> in which the assigned rip is checked during the assignment to the relevant
>> MSRs.
>>
>> This patch fixes the emulator to behave as real CPUs do for near branches.
>> Far branches are handled by the next patch.
>>
>> This fixes CVE-2014-3647.
>>
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> [lizf: Backported to 3.4:
>> - adjust context
>> - use ctxt->regs rather than reg_read() and reg_write()]
>> Signed-off-by: Zefan Li <lizefan@huawei.com>


