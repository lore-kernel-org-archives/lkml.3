Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751091AbaHME4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:56:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:17040 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750765AbaHME4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:56:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,318,1406563200"; 
   d="scan'208";a="34547254"
Message-ID: <53EAF01C.3090404@cn.fujitsu.com>
Date: Wed, 13 Aug 2014 12:57:00 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <santosh.shilimkar@ti.com>, <grygorii.strashko@ti.com>,
        <phacht@linux.vnet.ibm.com>, <yinghai@kernel.org>, <fabf@skynet.be>,
        <Emilian.Medve@freescale.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().
References: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com> <20140812150304.74a7da3f2491f3d8f8a30107@linux-foundation.org>
In-Reply-To: <20140812150304.74a7da3f2491f3d8f8a30107@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/13/2014 06:03 AM, Andrew Morton wrote:
> On Sun, 10 Aug 2014 14:12:03 +0800 Tang Chen <tangchen@cn.fujitsu.com> wrote:
>
>> In memblock_find_in_range_node(), we defeind ret as int. But it shoule
>> be phys_addr_t because it is used to store the return value from
>> __memblock_find_range_bottom_up().
>>
>> The bug has not been triggered because when allocating low memory near
>> the kernel end, the "int ret" won't turn out to be minus. When we started
>> to allocate memory on other nodes, and the "int ret" could be minus.
>> Then the kernel will panic.
>>
>> A simple way to reproduce this: comment out the following code in numa_init(),
>>
>>          memblock_set_bottom_up(false);
>>
>> and the kernel won't boot.
> Which kernel versions need this fix?

This bug has been in the kernel since v3.13-rc1.

Thanks.
