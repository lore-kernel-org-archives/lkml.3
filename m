Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAXSN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:13:56 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:65125 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaAXSNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:13:55 -0500
MIME-Version: 1.0
In-Reply-To: <52E2AC5A.3000005@intel.com>
References: <52E19C7D.7050603@intel.com>
	<CAE9FiQX9kTxnaqpWNgg3dUzr7+60YCrEx3q3xxO-G1n6z64xVQ@mail.gmail.com>
	<52E28067.1060507@intel.com>
	<CAE9FiQVy+8CF5qwnyL8YGzqwKOJF+y7N_+reAXWw7p8-BaVQPg@mail.gmail.com>
	<52E2AC5A.3000005@intel.com>
Date: Fri, 24 Jan 2014 10:13:54 -0800
X-Google-Sender-Auth: VmYj4wr9-v_uiMlK9AK3cm-RFYc
Message-ID: <CAE9FiQW3DrGjKHLhwBgcK076g7z-6_-0EN2HwtVBLSpKO4m6-Q@mail.gmail.com>
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

On Fri, Jan 24, 2014 at 10:09 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 01/24/2014 09:45 AM, Yinghai Lu wrote:
>> On Fri, Jan 24, 2014 at 7:01 AM, Dave Hansen <dave.hansen@intel.com> wrote:
>>> There are two failure modes I'm seeing: one when (failing to) allocate
>>> the first node's mem_map[], and a second where it oopses accessing the
>>> numa_distance[] table.  This is the numa_distance[] one, and it happens
>>> even with the patch you suggested applied.
>>>
>>>> [    0.000000] memblock_find_in_range_node():239
>>>> [    0.000000] __memblock_find_range_top_down():150
>>>> [    0.000000] __memblock_find_range_top_down():152 i: 600000001
>>>> [    0.000000] memblock_find_in_range_node():241 ret: 2147479552
>>>> [    0.000000] memblock_reserve: [0x0000007ffff000-0x0000007ffff03f] flags 0x0 numa_set_distance+0xd2/0x252
>>
>> that address is wrong.
>>
>> Can you post whole log with current linus' tree + two patches that I
>> sent out yesterday?
>
> Here you go.  It's still spitting out memblock_reserve messages to the
> console.  I'm not sure if it's making _some_ progress or not.
>
>         https://www.sr71.net/~dave/intel/3.13/dmesg.with-2-patches
>
> But, it's certainly not booting.  Do you want to see it without
> memblock=debug?

that looks like different problem. and it can not set memory mapping properly.

can you send me .config ?

Thanks

Yinghai
