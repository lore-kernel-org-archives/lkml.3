Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751227AbaALPmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 10:42:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51101 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaALPmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 10:42:43 -0500
Message-ID: <52D2B7C8.4060103@ti.com>
Date: Sun, 12 Jan 2014 10:42:00 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] mm: nobootmem: avoid type warning about alignment value
References: <1385249326-9089-1-git-send-email-santosh.shilimkar@ti.com> <529217C7.6030304@cogentembedded.com> <52935762.1080409@ti.com> <20131209165044.cf7de2edb8f4205d5ac02ab0@linux-foundation.org> <20131210005454.GX4360@n2100.arm.linux.org.uk> <52A66826.7060204@ti.com> <20140112105958.GA9791@n2100.arm.linux.org.uk>
In-Reply-To: <20140112105958.GA9791@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 January 2014 05:59 AM, Russell King - ARM Linux wrote:
> On Mon, Dec 09, 2013 at 08:02:30PM -0500, Santosh Shilimkar wrote:
>> On Monday 09 December 2013 07:54 PM, Russell King - ARM Linux wrote:
>>> The underlying reason is that - as I've already explained - ARM's __ffs()
>>> differs from other architectures in that it ends up being an int, whereas
>>> almost everyone else is unsigned long.
>>>
>>> The fix is to fix ARMs __ffs() to conform to other architectures.
>>>
>> I was just about to cross-post your reply here. Obviously I didn't think
>> this far when I made  $subject fix.
>>
>> So lets ignore the $subject patch which is not correct. Sorry for noise
> 
> Well, here we are, a month on, and this still remains unfixed despite
> my comments pointing to what the problem is.  So, here's a patch to fix
> this problem the correct way.  I took the time to add some comments to
> these functions as I find that I wonder about their return values, and
> these comments make the patch a little larger than it otherwise would be.
> 
The $subject warning fix [1] is already picked by Andrew with your ack
and its in his queue [2]

> This patch makes their types match exactly with x86's definitions of
> the same, which is the basic problem: on ARM, they all took "int" values
> and returned "int"s, which leads to min() in nobootmem.c complaining.
> 
Not sure if you missed the thread but the right fix was picked. Ofcourse
you do have additional clz optimisation in updated patch and some comments
on those functions.

Regards,
Santosh

[1] https://lkml.org/lkml/2013/12/9/811
[2] http://ozlabs.org/~akpm/mmotm/broken-out/mm-arm-fix-arms-__ffs-to-conform-to-avoid-warning-with-no_bootmem.patch

