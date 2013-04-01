Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3DARTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:19:12 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39135 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab3DARTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:19:10 -0400
MIME-Version: 1.0
Date: Mon, 1 Apr 2013 21:19:10 +0400
Message-ID: <CAMo8BfLusS_vT4LWU93iCXpVSgN_Uvi1mBvLUVx+892V67X1JQ@mail.gmail.com>
Subject: mkfs.f2fs gets stuck with "blk_update_request: bio idx 0 >= vcnt 0"
 on 3.8
From: Max Filippov <jcmvbkbc@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to create f2fs filesystem on SD card on pandaboard using
f2fs-tools v1.0.0.
It works fine on Linus' v3.6, but fails on both v3.8 and stable v3.8.5:

# mkfs.f2fs /dev/mmcblk0p3
Info: sector size = 512
Info: total sectors = 11370496 (in 512bytes)
Info: zone aligned segment0 blkaddr: 512
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0

mkfs process gets stuck in D state and I see the following in the dmesg:

[  257.789733] __end_that: dev mmcblk0: type=1, flags=122c8081
[  257.789764]   sector 4194304, nr/cnr 2981888/4294959104
[  257.789764]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656
[  257.789764] blk_update_request: bio idx 0 >= vcnt 0
[  257.794921] request botched: dev mmcblk0: type=1, flags=122c8081
[  257.794921]   sector 4194304, nr/cnr 2981888/4294959104
[  257.794921]   bio df3840c0, biotail df3848c0, buffer   (null), len 1526726656

I'd appreciate any suggestion on what to try before I try to bisect it.

-- 
Thanks.
-- Max
