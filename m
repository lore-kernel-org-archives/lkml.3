Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab3JRTK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 15:10:26 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:60079 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3JRTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 15:10:25 -0400
Message-ID: <5261879E.2020309@bjorling.me>
Date: Fri, 18 Oct 2013 21:10:22 +0200
From: =?ISO-8859-1?Q?Matias_Bj=F8rling?= <m@bjorling.me>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: axboe@kernel.dk, keith.busch@intel.com, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 0/3] Convert from bio-based to blk-mq v2
References: <1382102062-22270-1-git-send-email-m@bjorling.me> <20131018154801.GQ16716@linux.intel.com>
In-Reply-To: <20131018154801.GQ16716@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 05:48 PM, Matthew Wilcox wrote:
> On Fri, Oct 18, 2013 at 03:14:19PM +0200, Matias Bjorling wrote:
>> Performance study:
>>
>> System: HGST Research NVMe prototype, Haswell i7-4770 3.4Ghz, 32GB 1333Mhz
>
> I don't have one of these.  Can you provide more details about it,
> such as:
>   - How many I/O queues does it have?
>   - Are the interrupts correctly bound to the CPUs (for both sets of tests)?
>     The driver isn't allowed to set the irq affinity correctly itself;
>     it can only set a hint and userspace (eg irqbalance) has to set the
>     affinity correctly
>   - Does it support interrupt coalescing?  If so, have you managed to do any
>     testing using that feature?
>

Current impletation is an PCI-e Gen2x4 interface, two I/O queues. One 
for admin and one for all other I/Os. I'll check up on IRQ affinity when 
multiple queues are available. I haven't yet tested interrupt coalescing.
