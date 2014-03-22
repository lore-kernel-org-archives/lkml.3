Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279AbaCVFPB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 01:15:01 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:22295 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaCVFO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 01:14:57 -0400
Message-ID: <532D1C43.4070206@huawei.com>
Date: Sat, 22 Mar 2014 13:14:43 +0800
From: Liu hua <sdu.liu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: <wangnan0@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <peifeiyue@huawei.com>
Subject: Re: [PATCH] ARM: kdump: Avoid overflow when converting pfn to physaddr
References: <1395138042-62364-1-git-send-email-sdu.liu@huawei.com> <20140318104855.GU21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140318104855.GU21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.58.238]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/18 18:48, Russell King - ARM Linux wrote:
> On Tue, Mar 18, 2014 at 06:20:42PM +0800, Liu Hua wrote:
>> When we configure CONFIG_LPAE=y, pfn << PAGE_SHIFT will
>> overflow if pfn >= 0x100000 in copy_oldmem_page.
>>
>> So use __pfn_to_phys for converting.
> 
> Yes.  The sad thing is that if you grep the kernel for similar things,
> it's littered with this problem.  I'm not sure whether anyone
> particularly "owns" the crash_dump.c file - Mika Westerberg and
> Olaf Hering were the last two to touch it... I guess put this in my
> patch system please.
> 
> Thanks.
> 

Yes, I found this problem in serval places after a quick review. I will
do a check on this.

