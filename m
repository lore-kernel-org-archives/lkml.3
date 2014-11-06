Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaKFQs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:48:59 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48101 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKFQs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:48:56 -0500
Message-ID: <545BA625.40308@windriver.com>
Date: Thu, 6 Nov 2014 10:47:33 -0600
From: Chris Friesen <chris.friesen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>
Subject: absurdly high "optimal_io_size" on Seagate SAS disk
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.119.46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running a modified 3.4-stable on relatively recent X86 server-class 
hardware.

I recently installed a Seagate ST900MM0026 (900GB 2.5in 10K SAS drive) 
and it's reporting a value of 4294966784 for optimal_io_size.  The other 
parameters look normal though:

/sys/block/sda/queue/hw_sector_size:512
/sys/block/sda/queue/logical_block_size:512
/sys/block/sda/queue/max_segment_size:65536
/sys/block/sda/queue/minimum_io_size:512
/sys/block/sda/queue/optimal_io_size:4294966784

The other drives in the system look more like what I'd expect:

/sys/block/sdb/queue/hw_sector_size:512
/sys/block/sdb/queue/logical_block_size:512
/sys/block/sdb/queue/max_segment_size:65536
/sys/block/sdb/queue/minimum_io_size:4096
/sys/block/sdb/queue/optimal_io_size:0
/sys/block/sdb/queue/physical_block_size:4096

/sys/block/sdc/queue/hw_sector_size:512
/sys/block/sdc/queue/logical_block_size:512
/sys/block/sdc/queue/max_segment_size:65536
/sys/block/sdc/queue/minimum_io_size:4096
/sys/block/sdc/queue/optimal_io_size:0
/sys/block/sdc/queue/physical_block_size:4096

According to the manual, the ST900MM0026 has a 512 byte physical sector 
size.

Is this a drive firmware bug?  Or a bug in the SAS driver?  Or is there 
a valid reason for a single drive to report such a huge value?

Would it make sense for the kernel to do some sort of sanity checking on 
this value?

Chris
