Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030725Ab3HISvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:51:23 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:62719 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030610Ab3HISvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:51:22 -0400
MIME-Version: 1.0
X-Originating-IP: [217.132.161.31]
In-Reply-To: <5203FF48.7000903@caviumnetworks.com>
References: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com>
	<000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com>
	<5203FF48.7000903@caviumnetworks.com>
Date: Fri, 9 Aug 2013 21:51:20 +0300
Message-ID: <CAOtvUMcR2Hx2jMy6Y0QQv5h7dM2a5fAC_M7BpgnaLa0VUieEHg@mail.gmail.com>
Subject: Re: [PATCH] smp.c: Quit unconditionally enabling irqs in on_each_cpu_mask().
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 11:27 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>
> On 08/08/2013 12:25 PM, Christoph Lameter wrote:
>>
>> On Thu, 8 Aug 2013, David Daney wrote:
>>
>>> I don't know of any bugs currently caused by this unconditional
>>> local_irq_enable(), but I want to use this function in MIPS/OCTEON
>>> early boot (when we have early_boot_irqs_disabled).  This also makes
>>> this function have similar semantics to on_each_cpu() which is good in
>>> itself.
>>
>>
>> smp_call_function_many() wants interrupts enabled.
>
>
> That's what the comments say, but it isn't actually true.
>
> The usage introduced by the patch is no different than the existing usage in on_each_cpu() 30 line up in the file.
>

Regardless of the question of how smp_call_function_many() should be
called, the IRQ disable/enable pair is actually there to make sure the
provided function runs on the current CPU at the same conditions as it
would get called via the IPI.

I would at least consider putting a test there to make sure IRQs
really are disabled when entering the function, otherwise the bugs
stemming from incorrect use can be tricky to catch.

Just my 0.00002 BTC
Gilad



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
