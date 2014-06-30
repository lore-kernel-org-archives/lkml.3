Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaF3BxW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 21:53:22 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:49564 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaF3BxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 21:53:19 -0400
MIME-Version: 1.0
In-Reply-To: <53B075EB.6020301@kernel.org>
References: <1403928469-9452-1-git-send-email-xerofoify@gmail.com>
	<53AF1D25.10406@kernel.org>
	<CAPDOMVgRDos+UQ_hxGSt3Gph-hqd=Vri4i=JXm9h-2ekmK6bvg@mail.gmail.com>
	<53B075EB.6020301@kernel.org>
Date: Sun, 29 Jun 2014 21:53:18 -0400
Message-ID: <CAPDOMVjNqk5B0Aby8xnAtCYy0mkeXgQjwyhJCGsA5FhQhjR-LQ@mail.gmail.com>
Subject: Re: [PATCH] FIXME of file toploogy.h for alpha cpus
From: Nick Krause <xerofoify@gmail.com>
To: Sasha Levin <sashal@kernel.org>
Cc: rth@twiddle.net, ink@jurassic.park.msu.ru,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Sasha ,
I will rewrite and test this patch before I send it in.
Cheers Nick

On Sun, Jun 29, 2014 at 4:24 PM, Sasha Levin <sashal@kernel.org> wrote:
> On 06/28/2014 11:03 PM, Nick Krause wrote:
>> I thought I compiled tested it maybe not. I thought M= would work for
>> alpha directory but maybe I have to enable in on x86.
>> I don't known if there is a way to do this.
>> Cheers Nick
>>
>> On Sat, Jun 28, 2014 at 3:53 PM, Sasha Levin <sashal@kernel.org> wrote:
>>> On 06/28/2014 12:07 AM, Nicholas Krause wrote:
>>>> This patch fixs the FIXME message in the function *cpumask_of_node
>>>> for using this function multiple times and the issue with recaluting
>>>> the cpu node mask when reusing this function.
>>>>
>>>> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>>>> ---
>>>>  arch/alpha/include/asm/topology.h | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
>>>> index 9251e13..d301f66 100644
>>>> --- a/arch/alpha/include/asm/topology.h
>>>> +++ b/arch/alpha/include/asm/topology.h
>>>> @@ -31,6 +31,9 @@ static const struct cpumask *cpumask_of_node(int node)
>>>>       if (node == -1)
>>>>               return cpu_all_mask;
>>>>
>>>> +     else if (node == &node_to_cpumask_map[node])
>>>> +             return &node_to_cpumask_map[node];
>>>> +
>>>>       cpumask_clear(&node_to_cpumask_map[node]);
>>>>
>>>>       for_each_online_cpu(cpu) {
>>>>
>>>
>>> Since this patch doesn't even compile, care to tell us how you tested it?
>>>
>>>
>>> Thanks,
>>> Sasha
>
> Please stop top posting.
>
> Your explanation is missing the part about actually making sure that your patch
> works is missing, how did you intend to make sure that your patch doesn't
> break things?
>
>
> Thanks,
> Sasha
