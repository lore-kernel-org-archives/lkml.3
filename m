Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3LXT2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 14:28:09 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3LXT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 14:28:07 -0500
Message-ID: <52B9E037.1050606@oracle.com>
Date: Tue, 24 Dec 2013 14:27:51 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, khlebnikov@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Bob Liu <bob.liu@oracle.com>
Subject: Re: mm: kernel BUG at include/linux/swapops.h:131!
References: <52B1C143.8080301@oracle.com> <52B871B2.7040409@oracle.com> <20131224025127.GA2835@lge.com> <52B8F8F6.1080500@oracle.com> <20131224060705.GA16140@lge.com>
In-Reply-To: <20131224060705.GA16140@lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 01:07 AM, Joonsoo Kim wrote:
> On Mon, Dec 23, 2013 at 10:01:10PM -0500, Sasha Levin wrote:
>> On 12/23/2013 09:51 PM, Joonsoo Kim wrote:
>>> On Mon, Dec 23, 2013 at 12:24:02PM -0500, Sasha Levin wrote:
>>>>> Ping?
>>>>>
>>>>> I've also Cc'ed the "this page shouldn't be locked at all" team.
>>> Hello,
>>>
>>> I can't find the reason of this problem.
>>> If it is reproducible, how about bisecting?
>>
>> While it reproduces under fuzzing it's pretty hard to bisect it with
>> the amount of issues uncovered by trinity recently.
>>
>> I can add any debug code to the site of the BUG if that helps.
>
> Good!
> It will be helpful to add dump_page() in migration_entry_to_page().


[ 3800.520039] page:ffffea0000245800 count:12 mapcount:4 mapping:ffff88001d0c3668 index:0x7de
[ 3800.521404] page flags: 
0x1fffff8038003c(referenced|uptodate|dirty|lru|swapbacked|unevictable|mlocked)
[ 3800.522585] pc:ffff88001ed91600 pc->flags:2 pc->mem_cgroup:ffffc90000c0a000


Thanks,
Sasha
