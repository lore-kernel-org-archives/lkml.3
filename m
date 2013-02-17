Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab3BQWDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:03:07 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53202 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3BQWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:03:05 -0500
Message-ID: <51215393.1070409@suse.cz>
Date: Sun, 17 Feb 2013 23:02:59 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: linux-mm <linux-mm@kvack.org>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        LKML <linux-kernel@vger.kernel.org>, Rik van Riel <riel@redhat.com>
Subject: kswapd craziness round 2
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You still feel the sour taste of the "kswapd craziness in v3.7" thread,
right? Welcome to the hell, part two :{.

I believe this started happening after update from
3.8.0-rc4-next-20130125 to 3.8.0-rc7-next-20130211. The same as before,
many hours of uptime are needed and perhaps some suspend/resume cycles
too. Memory pressure is not high, plenty of I/O cache:
# free
             total       used       free     shared    buffers     cached
Mem:       6026692    5571184     455508          0     351252    2016648
-/+ buffers/cache:    3203284    2823408
Swap:            0          0          0

kswap is working very toughly though:
root       580  0.6  0.0      0     0 ?        S    úno12  46:21 [kswapd0]

This happens on I/O activity right now. For example by updatedb or find
/. This is what the stack trace of kswapd0 looks like:
[<ffffffff8113c431>] shrink_slab+0xa1/0x2d0
[<ffffffff8113ecd1>] kswapd+0x541/0x930
[<ffffffff810a3000>] kthread+0xc0/0xd0
[<ffffffff816beb5c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff

Any ideas?

thanks,
-- 
js
suse labs
