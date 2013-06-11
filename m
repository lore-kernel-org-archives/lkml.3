Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab3FKQUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:20:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26559 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3FKQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:20:02 -0400
Message-ID: <51B74E28.4070906@oracle.com>
Date: Tue, 11 Jun 2013 12:19:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@gentwo.org>, Pekka Enberg <penberg@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: prevent warnings when allocating with __GFP_NOWARN
References: <1370891880-2644-1-git-send-email-sasha.levin@oracle.com>  <CAOJsxLGDH2iwznRkP-iwiMZw7Ee3mirhjLvhShrWLHR0qguRxA@mail.gmail.com>  <51B62F6B.8040308@oracle.com>  <0000013f3075f90d-735942a8-b4b8-413f-a09e-57d1de0c4974-000000@email.amazonses.com>  <51B67553.6020205@oracle.com>  <CAOJsxLH56xqCoDikYYaY_guqCX=S4rcVfDJQ4ki=r-PkNQW9ug@mail.gmail.com>  <51B72323.8040207@oracle.com>  <0000013f33cdc631-eadb07d1-ef08-4e2c-a218-1997eb86cde9-000000@email.amazonses.com>  <51B73F38.6040802@kernel.org>  <0000013f33d58923-88767793-2187-476d-b500-dba3c22607aa-000000@email.amazonses.com>  <51B745F9.9080609@oracle.com> <1370967193.3252.47.camel@edumazet-glaptop>
In-Reply-To: <1370967193.3252.47.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:13 PM, Eric Dumazet wrote:
> On Tue, 2013-06-11 at 11:44 -0400, Sasha Levin wrote:
>> On 06/11/2013 11:23 AM, Christoph Lameter wrote:
>>> On Tue, 11 Jun 2013, Pekka Enberg wrote:
>>>
>>>> So you're OK with going forward with Sasha's patch? It's needed
>>>> because __GFP_NOWARN was specifically added there to fix this
>>>> issue earlier.
>>>
>>> Why dont we fix the call site to use vmalloc instead for larger allocs?
>>>
>>
>> We should probably be doing both.
>
> Allowing a pipe to store thousands of page refs seems quite useless and
> dangerous.

It might be, but you need CAP_SYS_RESOURCE to go into the dangerous
zone (>pipe_max_size).

So if root (or someone with that cap) wants to go there, as Rusty says:
"Root asked, we do."


Thanks,
Sasha
