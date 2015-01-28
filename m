Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbbA1Uzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:55:55 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:36386 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbbA1Uzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:53 -0500
Message-ID: <54C8CC7C.6080005@huawei.com>
Date: Wed, 28 Jan 2015 19:48:12 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: <lizf@kernel.org>, <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Subject: Re: [PATCH 3.4 152/177] KVM: x86: Fix uninitialized op->type for
 some immediate values
References: <1422418050-12581-1-git-send-email-lizf@kernel.org> <1422418236-12852-243-git-send-email-lizf@kernel.org> <861C01D3-25A0-4411-9FBF-C72128CF3EBC@gmail.com>
In-Reply-To: <861C01D3-25A0-4411-9FBF-C72128CF3EBC@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/28 16:47, Nadav Amit wrote:
> This bug should have no effect on Linux 3.4. It shouldn’t hurt, but the
> problem it fixes was introduced in 3.16 or 3.17.

Dropped. Thanks!

> 
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
>> commit d29b9d7ed76c0b961603ca692b8a562556a20212 upstream.
>>
>> The emulator could reuse an op->type from a previous instruction for some
>> immediate values.  If it mistakenly considers the operands as memory
>> operands, it will performs a memory read and overwrite op->val.
>>
>> Consider for instance the ROR instruction - src2 (the number of times)
>> would be read from memory instead of being used as immediate.
>>
>> Mark every immediate operand as such to avoid this problem.
>>
>> Fixes: c44b4c6ab80eef3a9c52c7b3f0c632942e6489aa
>> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Zefan Li <lizefan@huawei.com>


