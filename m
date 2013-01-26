Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3AZBFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:05:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48420 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496Ab3AZBFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:05:41 -0500
Message-ID: <51032BCB.5070506@zytor.com>
Date: Fri, 25 Jan 2013 17:05:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [tip:x86/asm] x86/xor: Make virtualization friendly
References: <5093E4F302000078000A6162@nat28.tlf.novell.com> <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org> <510302FD.3090009@zytor.com> <510303F8.1080105@zytor.com>
In-Reply-To: <510303F8.1080105@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 02:15 PM, H. Peter Anvin wrote:
> On 01/25/2013 02:11 PM, H. Peter Anvin wrote:
>> On 01/25/2013 02:43 AM, tip-bot for Jan Beulich wrote:
>>> Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>>> Gitweb:     http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>>> Author:     Jan Beulich <JBeulich@suse.com>
>>> AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
>>> Committer:  Ingo Molnar <mingo@kernel.org>
>>> CommitDate: Fri, 25 Jan 2013 09:23:51 +0100
>>>
>>> x86/xor: Make virtualization friendly
>>>
>>> In virtualized environments, the CR0.TS management needed here
>>> can be a lot slower than anticipated by the original authors of
>>> this code, which particularly means that in such cases forcing
>>> the use of SSE- (or MMX-) based implementations is not desirable
>>> - actual measurements should always be done in that case.
>>>
>>> For consistency, pull into the shared (32- and 64-bit) header
>>> not only the inclusion of the generic code, but also that of the
>>> AVX variants.
>>>
>>
>> This patch is wrong and should be dropped.  I verified it with the KVM
>> people that they do NOT want this change.  It is a Xen-specific problem.
>>
>
> FWIW: I have dropped this patch from tip:x86/asm.
>

The bottom line, I guess, is that we need something like 
cpu_has_slow_kernel_fpu or something like that, and set it for 
specifically affected hypervisors?

Do we know if Hyper-V has performance issues with CR0.TS?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

