Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3GMLTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:19:10 -0400
Received: from ns3.fnarfbargle.com ([103.4.17.7]:59442 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408Ab3GMLTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:19:08 -0400
X-Greylist: delayed 1877 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jul 2013 07:19:07 EDT
Message-ID: <51E13052.30101@fnarfbargle.com>
Date: Sat, 13 Jul 2013 18:47:46 +0800
From: Brad Campbell <brad@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 3.10: discard/trim support on md-raid1?
References: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
In-Reply-To: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/13 18:34, Justin Piszcz wrote:
> And possibly:
> discard_zeroes_data: 1

Does it though?

Here's my 6 x SSD RAID10 that definitely discards.

brad@srv:~$ grep . /sys/block/md2/queue/*
/sys/block/md2/queue/add_random:0
/sys/block/md2/queue/discard_granularity:33553920
/sys/block/md2/queue/discard_max_bytes:65536
/sys/block/md2/queue/discard_zeroes_data:0
/sys/block/md2/queue/hw_sector_size:512
/sys/block/md2/queue/iostats:0
/sys/block/md2/queue/logical_block_size:512
/sys/block/md2/queue/max_hw_sectors_kb:16383
/sys/block/md2/queue/max_integrity_segments:0
/sys/block/md2/queue/max_sectors_kb:512
/sys/block/md2/queue/max_segments:128
/sys/block/md2/queue/max_segment_size:65536
/sys/block/md2/queue/minimum_io_size:65536
/sys/block/md2/queue/nomerges:0
/sys/block/md2/queue/nr_requests:128
/sys/block/md2/queue/optimal_io_size:196608
/sys/block/md2/queue/physical_block_size:512
/sys/block/md2/queue/read_ahead_kb:384
/sys/block/md2/queue/rotational:1
/sys/block/md2/queue/rq_affinity:0
/sys/block/md2/queue/scheduler:none
/sys/block/md2/queue/write_same_max_bytes:0

Mine does not have discard_zeroes_data == 1 which is correct as 3 of the drives are Samsung 830's 
and they don't return deterministic after trim.

I can verify that discard gets passed down the stack as I get a non-zero mismatch count after 
running a trim on the filesystem. Checking the mirrors manually sees 0 returned from the Intel 
330's, and apparently random data returned from the 830's.

Regards,
Brad
