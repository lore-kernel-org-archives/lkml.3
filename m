Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbaAXRpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:45:23 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54653 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAXRpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <52E28067.1060507@intel.com>
References: <52E19C7D.7050603@intel.com>
	<CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com>
	<52E28067.1060507@intel.com>
Date: Fri, 24 Jan 2014 09:45:17 -0800
X-Google-Sender-Auth: yxhOjQX5nJ2rPt9mrL6NX1lCaYI
Message-ID: <CAE9FiQVy+8CF5qwnyL8YGzqwKOJF+y7N_+reAXWw7p8-BaVQPg@mail.gmail.com>
Subject: Re: Panic on 8-node system in memblock_virt_alloc_try_nid()
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 7:01 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> There are two failure modes I'm seeing: one when (failing to) allocate
> the first node's mem_map[], and a second where it oopses accessing the
> numa_distance[] table.  This is the numa_distance[] one, and it happens
> even with the patch you suggested applied.
>
>> [    0.000000] memblock_find_in_range_node():239
>> [    0.000000] __memblock_find_range_top_down():150
>> [    0.000000] __memblock_find_range_top_down():152 i: 600000001
>> [    0.000000] memblock_find_in_range_node():241 ret: 2147479552
>> [    0.000000] memblock_reserve: [0x0000007ffff000-0x0000007ffff03f] flags 0x0 numa_set_distance+0xd2/0x252

that address is wrong.

Can you post whole log with current linus' tree + two patches that I
sent out yesterday?

>> [    0.000000] numa_distance phys: 7ffff000
>> [    0.000000] numa_distance virt: ffff88007ffff000
>> [    0.000000] numa_distance size: 64
>> [    0.000000] numa_alloc_distance() accessing numa_distance[] at byte: 0
>> [    0.000000] BUG: unable to handle kernel paging request at ffff88007ffff000
