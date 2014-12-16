Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbaLPFz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 00:55:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaLPFzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 00:55:55 -0500
Message-ID: <548FC95E.70903@suse.com>
Date: Tue, 16 Dec 2014 06:55:42 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 4/4] xen: use generated hypercall symbols
 in arch/x86/xen/xen-head.S
References: <1418321065-10212-1-git-send-email-jgross@suse.com> <1418321065-10212-5-git-send-email-jgross@suse.com> <548ECE9B.3040105@citrix.com>
In-Reply-To: <548ECE9B.3040105@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 01:05 PM, David Vrabel wrote:
> On 11/12/14 18:04, Juergen Gross wrote:
>> Instead of manually list each hypercall in arch/x86/xen/xen-head.S
>> use the auto generated symbol list.
>>
>> This also corrects the wrong address of xen_hypercall_mca which was
>> located 32 bytes higher than it should.
>>
>> Symbol addresses have been verified to match the correct ones via
>> objdump output.
> [...]
>> +
>> +#define HYPERCALL(n) \
>> +	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
>> +	.type xen_hypercall_##n, function; .size xen_hypercall_##n, 32
>> +#include <asm/xen-hypercalls.h>
>> +#undef HYPERCALL
>
> The gas manual[1] suggests the syntax you've used for .type is invalid
> and suggest using .type <name>, STT_FUNC

Really? In the link below I see:

The types supported are:

STT_FUNC
function
     Mark the symbol as being a function name.
...

So "function" seems to be okay.

>
>> +
>>   	.balign PAGE_SIZE
>
> You can remove this .balign.

Indeed.


Juergen

