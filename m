Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbaJNQ2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 12:28:37 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48055 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846AbaJNQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 12:28:36 -0400
MIME-Version: 1.0
In-Reply-To: <543D4AC7.7040409@citrix.com>
References: <1413249548-26415-1-git-send-email-martin@martingkelly.com>
	<543CEB56.3080009@citrix.com>
	<543D2D66.7040000@martingkelly.com>
	<543D4AC7.7040409@citrix.com>
Date: Tue, 14 Oct 2014 09:28:34 -0700
Message-ID: <CAN8CM3zPphjm24LZKKFaGy3-6-u6Tu7bi_um_upC6W+4Oxe2DA@mail.gmail.com>
Subject: Re: [PATCH] xen/setup: add paranoid index check and warning
From: Martin Kelly <martin@martingkelly.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        Martin Kelly <martkell@amazon.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 9:09 AM, David Vrabel <david.vrabel@citrix.com> wrote:
> On 14/10/14 15:04, Martin Kelly wrote:
>> On 10/14/2014 02:22 AM, David Vrabel wrote:
>>> On 14/10/14 02:19, Martin Kelly wrote:
>>>> In a call to set_phys_range_identity, i-1 is used without checking that
>>>> i is non-zero. Although unlikely, a bug in the code before it could
>>>> cause the value to be 0, leading to erroneous behavior. This patch adds
>>>> a check against 0 value and a corresponding warning.
>>>
>>> This can only happen if the toolstack supplies a memory map with zero
>>> entries.  I could see justification for adding a panic at the top of
>>> this function in this case, but I can't see the usefulness of this warning.
>>>
>>
>> Yes, a panic is probably appropriate. What do you think about the
>> relative merits of panicing in the callers vs. in the
>> sanitize_e820_map function itself (thus to avoid a bunch of similar
>> error checks in the callers)?
>
> For Xen, it should panic immediately after getting the memory map.
>
> You will note that there is fallback code for the case when no memory
> map is provided.  But I do not think this should be used in the case
> where the toolstack provided an empty memory map.
>
> David

Sounds like the flow should be as follows:
1) Ask Xen for the memory map.
2) If no memory map is provided, use fallback code.
3) If the memory map has 0 entries, panic.

I will revise the patch to do that.
