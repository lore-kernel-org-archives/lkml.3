Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaJQDuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 23:50:00 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62734 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaJQDt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 23:49:59 -0400
Message-ID: <544091E3.8070403@martingkelly.com>
Date: Thu, 16 Oct 2014 20:49:55 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] xen/setup: add paranoid index check and warning
References: <1413249548-26415-1-git-send-email-martin@martingkelly.com>	<543CEB56.3080009@citrix.com>	<543D2D66.7040000@martingkelly.com>	<543D4AC7.7040409@citrix.com> <CAN8CM3zPphjm24LZKKFaGy3-6-u6Tu7bi_um_upC6W+4Oxe2DA@mail.gmail.com>
In-Reply-To: <CAN8CM3zPphjm24LZKKFaGy3-6-u6Tu7bi_um_upC6W+4Oxe2DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 09:28 AM, Martin Kelly wrote:
> On Tue, Oct 14, 2014 at 9:09 AM, David Vrabel <david.vrabel@citrix.com> wrote:
>> On 14/10/14 15:04, Martin Kelly wrote:
>>> On 10/14/2014 02:22 AM, David Vrabel wrote:
>>>> On 14/10/14 02:19, Martin Kelly wrote:
>>>>> In a call to set_phys_range_identity, i-1 is used without checking that
>>>>> i is non-zero. Although unlikely, a bug in the code before it could
>>>>> cause the value to be 0, leading to erroneous behavior. This patch adds
>>>>> a check against 0 value and a corresponding warning.
>>>>
>>>> This can only happen if the toolstack supplies a memory map with zero
>>>> entries.  I could see justification for adding a panic at the top of
>>>> this function in this case, but I can't see the usefulness of this warning.
>>>>
>>>
>>> Yes, a panic is probably appropriate. What do you think about the
>>> relative merits of panicing in the callers vs. in the
>>> sanitize_e820_map function itself (thus to avoid a bunch of similar
>>> error checks in the callers)?
>>
>> For Xen, it should panic immediately after getting the memory map.
>>
>> You will note that there is fallback code for the case when no memory
>> map is provided.  But I do not think this should be used in the case
>> where the toolstack provided an empty memory map.
>>
>> David
> 
> Sounds like the flow should be as follows:
> 1) Ask Xen for the memory map.
> 2) If no memory map is provided, use fallback code.
> 3) If the memory map has 0 entries, panic.
> 
> I will revise the patch to do that.
> 

I have sent a revision adding the panic:
"[PATCH] x86/xen: panic on bad Xen-provided memory map"
