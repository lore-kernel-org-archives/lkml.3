Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab3KDUXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:16 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:56120 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3KDUXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:08 -0500
MIME-Version: 1.0
In-Reply-To: <87wqkovvzs.fsf@tassilo.jf.intel.com>
References: <CAOMFOmWzERR7MDe65YHo--GdbO+QfnxZK=uWd7d3vCZ6ca97fw@mail.gmail.com>
	<87wqkovvzs.fsf@tassilo.jf.intel.com>
Date: Mon, 4 Nov 2013 12:23:06 -0800
Message-ID: <CAOMFOmVrBB5Pj9hXaooQF1XNkLqUW-LBux5jbsrYArnpQh5iCg@mail.gmail.com>
Subject: Re: Solving M produces N consumers scalability problem
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks for your reply

On Mon, Nov 4, 2013 at 10:53 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Anatol Pomozov <anatol.pomozov@gmail.com> writes:
>>
>> One idea is not to use the spin_lock. It is the 'fair spin_lock' that
>> has scalability problems
>> http://pdos.csail.mit.edu/papers/linux:lock.pdf Maybe lockless
>> datastructures can help here?
>
> The standard spin lock is already improved.
> But better locks just give you a small advantage, they don't
> solve the real scaling problem.

Do you know in what version the improvement happened? I use kernel 3.3
and I can backport the changes to my custom kernel to make the
situation better.

>> Another idea is avoid global datasctructures but I have a few
>> questions here. Let's say we want to use per-CPU lists. But the
>> problem is that producers/consumers are not distributed across all
>> CPUs. Some CPU might have too many producers, some other might not
>> have consumers at all. So we need some kind of migration from hot CPU
>> to the cold one. What is the best way to achieve it? Are there any
>> examples how to do this? Any other ideas?
>
> per cpu is the standard approach, but usually overkill. Also
> requires complex code to drain etc.
>
> Some older patches also use per node, but that works very poorly
> these days (nodes are far too big)
>
> One way I like is to simply use a global (allocated) array of queues,
> sized by total number of possible cpus (but significantly smaller) and
> use the cpu number as a hash into the array.

This solution pretty-much equivalent to per-CPU data structures. And
in this case there also will be "hot" nodes and "cold" nodes. So my
question remains - what is the best way to implement data migration
between nodes, is there a standard solution for this? examples?
