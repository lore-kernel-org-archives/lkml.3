Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab3GMKeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:34:23 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:39279 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3GMKeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:34:21 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-raid@vger.kernel.org>
Subject: 3.10: discard/trim support on md-raid1?
Date: Sat, 13 Jul 2013 06:34:19 -0400
Message-ID: <001701ce7fb4$889bdd40$99d397c0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac5/tHNJ9Kkvdmi5QeedyI+cT7bdWg==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Running 3.10 and I see the following for an md-raid1 of two SSDs:

Checking /sys/block/md1/queue:
add_random: 0
discard_granularity: 512
discard_max_bytes: 2147450880
discard_zeroes_data: 0
hw_sector_size: 512
iostats: 0
logical_block_size: 512
max_hw_sectors_kb: 32767
max_integrity_segments: 0
max_sectors_kb: 512
max_segment_size: 65536
max_segments: 168
minimum_io_size: 512
nomerges: 0
nr_requests: 128
optimal_io_size: 0
physical_block_size: 512
read_ahead_kb: 8192
rotational: 1
rq_affinity: 0
scheduler: none
write_same_max_bytes: 0

What should be seen:
rotational: 0
And possibly:
discard_zeroes_data: 1

Can anyone confirm if there is a workaround to allow TRIM when using
md-raid1?

Some related discussion here:
http://us.generation-nt.com/answer/md-rotational-attribute-help-206571222.ht
ml
http://www.progtown.com/topic343938-ssd-strange-itself-conducts.html


Justin.


