Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaJAQfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 12:35:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63697 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaJAQfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 12:35:17 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-24-542c2d42fb5f
Message-id: <542C2BA2.2020206@samsung.com>
Date: Wed, 01 Oct 2014 20:28:18 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.8.0
MIME-version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Vegard Nossum <vegard.nossum@gmail.com>, x86@kernel.org,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC/PATCH v2 02/10] x86_64: add KASan support
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-1-git-send-email-a.ryabinin@samsung.com>
 <1410359487-31938-3-git-send-email-a.ryabinin@samsung.com>
 <54111E99.7080309@zytor.com> <5411339E.8080007@samsung.com>
 <542C1E5A.4000202@zytor.com>
In-reply-to: <542C1E5A.4000202@zytor.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t/xy7pOujohBg93CFn83juT1WLO+jVs
	FkeufWe3uP7tDaPFp5cPGC2eP3zIbjHhYRu7xbSN4hYru5vZLLY/e8tksbLzAavF5V1z2Czu
	rfnPanHpwAImi8VHbjNbvHs2mdli86apzBZXVx1kt/ix4TGrg7DH/J0fGT12zrrL7rFgU6nH
	4j0vmTw2repk89j0aRK7R9fbK0we786dY/c4MeM3i8eTK9OZPD4+vcXi8X7fVTaPz5vkPE60
	fGEN4IvisklJzcksSy3St0vgyuhqesBW8IK7YtaLRvYGxvOcXYwcHBICJhJHerS6GDmBTDGJ
	C/fWs3UxcnEICSxllFh17hIrhNPMJHHz5C9GkCpeAS2J/T3T2EBsFgFViadf3rOD2GwCehL/
	Zm0Hi4sKREhM2b+UFaJeUOLH5HssILaIgJPEoSNPmUGGMgu8ZZG482YvM0hCWMBaYuPefVDb
	5jBJ7Px5EqybU0BTYsnGKWBTmQXUJSbNW8QMYctLbF7zlnkCo8AsJEtmISmbhaRsASPzKkbR
	1NLkguKk9FwjveLE3OLSvHS95PzcTYyQuP26g3HpMatDjAIcjEo8vBrp2iFCrIllxZW5hxgl
	OJiVRHhXaeqECPGmJFZWpRblxxeV5qQWH2Jk4uCUamDcyMve5fwsqo1VKr69+WDur0dx03hL
	j98S/uiXW3n7w0X/a2qlwS88fAoltj1cxWqzYe3x2G8GExhOp927PLtPJtXkG3fdpMvm3a0m
	67foukz70L6U2/rC4dLX+79yl+cuWMV/S6lkxfnYk+euN5a8X/516teMns/TXkZ4ed+Yned0
	9dmFyjA7JZbijERDLeai4kQAoyEJArkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 07:31 PM, H. Peter Anvin wrote:
> On 09/10/2014 10:31 PM, Andrey Ryabinin wrote:
>> On 09/11/2014 08:01 AM, H. Peter Anvin wrote:
>>> On 09/10/2014 07:31 AM, Andrey Ryabinin wrote:
>>>> This patch add arch specific code for kernel address sanitizer.
>>>>
>>>> 16TB of virtual addressed used for shadow memory.
>>>> It's located in range [0xffff800000000000 - 0xffff900000000000]
>>>> Therefore PAGE_OFFSET has to be changed from 0xffff880000000000
>>>> to 0xffff900000000000.
>>>
>>> NAK on this.
>>>
>>> 0xffff880000000000 is the lowest usable address because we have agreed
>>> to leave 0xffff800000000000-0xffff880000000000 for the hypervisor or
>>> other non-OS uses.
>>>
>>> Bumping PAGE_OFFSET seems needlessly messy, why not just designate a
>>> zone higher up in memory?
>>>
>>
>> I already answered to Dave why I choose to place shadow bellow PAGE_OFFSET (answer copied bellow).
>> In short - yes, shadow could be higher. But for some sort of kernel bugs we could have confusing oopses in kasan kernel.
>>
> 
> Confusing how?  I presume you are talking about something trying to
> touch a non-canonical address, which is usually a very blatant type of bug.
> 
> 	-hpa
> 

For those kinds of bugs we normally get general protection fault.

With inline instrumented kasan we could get either general protection fault,
or unhandled page fault on "kasan_mem_to_shadow(non_canonical_address)" address.
I assume that the last case could be a bit confusing.

