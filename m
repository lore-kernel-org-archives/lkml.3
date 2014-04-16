Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaDPDGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 23:06:45 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:51986 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaDPDGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 23:06:42 -0400
Message-ID: <534DF3BC.8050803@hitachi.com>
Date: Wed, 16 Apr 2014 12:06:36 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>
Cc: vegard.nossum@oracle.com, penberg@kernel.org, jamie.iles@oracle.com,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: Move instruction decoder data into header
References: <1397497450-6440-1-git-send-email-sasha.levin@oracle.com> <1397497450-6440-2-git-send-email-sasha.levin@oracle.com> <534C8E2D.9020506@hitachi.com> <534C995F.9040101@oracle.com> <534CA33B.3040203@hitachi.com> <534D412A.30504@oracle.com>
In-Reply-To: <534D412A.30504@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 23:24), Sasha Levin wrote:
> On 04/14/2014 11:10 PM, Masami Hiramatsu wrote:
>> (2014/04/15 11:28), Sasha Levin wrote:
>>> On 04/14/2014 09:41 PM, Masami Hiramatsu wrote:
>>>> (2014/04/15 2:44), Sasha Levin wrote:
>>>>>> Right now we generate data for the instruction decoder and place it
>>>>>> as a code file which gets #included directly (yuck).
>>>>>>
>>>>>> Instead, make it a header which will also be usable by other code
>>>>>> that wants to use the data in there.
>>>> Hmm, making the generated data into a header file may clone
>>>> the data table instances for each object file. Since the inat
>>>> table is not so small, I think we'd better just export the tables.
>>>
>>> The tables are defined as static, so the compiler drops them
>>> once it detects they are not used.
>>
>> No, I meant that if the table is used in the different object files,
>> will the copies of the tables be compiled in several different
>> instances?
> 
> That's true, but there was and after this patchset there will still
> be only one user that touches the table. I also doubt that more users
> will appear since users of the table should be going through the API
> and not touching it directly, so I don't think it should be a concern
> at this point.

Agreed, so I don't like to expose it. If no one need them, then give
it to the owner. That must be the safest.

>> And I can't see the part which makes the tables static in this patch...
> 
> Right, it sneaked to the next patch in this patchset. I'll pull it
> into this one in the next version.
> 
>>> I feel it would be easier to let the compiler do it's job rather
>>> than do optimizations we don't need to do and which will complicate
>>> the code quite a bit.
>>
>> I haven't tend to optimize it, but just encapsulate it, to hide from other parts.
> 
> We could hide it under #ifdef, but that wouldn't change anything for
> the user or for the generated code itself.
> 
> Splitting code generation into two different files would complicate
> everything IMO.

No, mixing data (definitions) and declarations on one header should be
avoided, especially that is generated in the build path. I'd like to ask
you to split them into header and body. I know it will be harder to
implement, but worth to maintain.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


