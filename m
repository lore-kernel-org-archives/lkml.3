Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3EDHeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:34:12 -0400
Received: from vserver.eikelenboom.it ([84.200.39.61]:34245 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab3EDHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:34:10 -0400
Date: Sat, 4 May 2013 09:34:01 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <819995534.20130504093401@eikelenboom.it>
To: roger.pau@citrix.com
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, axboe@kernel.dk,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [GIT PULL] (xen) stable/for-jens-3.10 xenwatch: page allocation failure: order:7, mode:0x10c0d0
In-Reply-To: <1366146101.20130429180520@eikelenboom.it>
References: <20130419144401.GA14700@phenom.dumpdata.com> <1094538380.20130424201637@eikelenboom.it> <20130429154623.GB12754@phenom.dumpdata.com> <1366146101.20130429180520@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sander,

Monday, April 29, 2013, 6:05:20 PM, you wrote:


> Monday, April 29, 2013, 5:46:23 PM, you wrote:

>> On Wed, Apr 24, 2013 at 08:16:37PM +0200, Sander Eikelenboom wrote:
>>> Friday, April 19, 2013, 4:44:01 PM, you wrote:
>>> 
>>> > Hey Jens,
>>> 
>>> > Please in your spare time (if there is such a thing at a conference)
>>> > pull this branch:
>>> 
>>> >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.10
>>> 

>> .. snip..
>>> Hi Konrad / Roger,
>>> 
>>> I tried this pull on top of latest Linus latest linux-3.9 tree, but although it seems to boot and work fine at first, i seem to get trouble after running for about a day.
>>> Without this pull it runs fine for several days.
>> .. snipp.

>>> [18496.013743] xenwatch: page allocation failure: order:7, mode:0x10c0d0
>>> [18496.031948] Pid: 54, comm: xenwatch Not tainted 3.9.0-rc8-20130424-jens+ #1
>>> [18496.049897] Call Trace:
>>> [18496.067674]  [<ffffffff81100c51>] warn_alloc_failed+0xf1/0x140
>>> [18496.085453]  [<ffffffff810b25ed>] ? trace_hardirqs_on+0xd/0x10
>>> [18496.102951]  [<ffffffff810bdb24>] ? on_each_cpu_mask+0x94/0xd0
>>> [18496.120270]  [<ffffffff811028af>] __alloc_pages_nodemask+0x69f/0x960
>>> [18496.137306]  [<ffffffff8113a161>] alloc_pages_current+0xb1/0x160
>>> [18496.154051]  [<ffffffff81100679>] __get_free_pages+0x9/0x40
>>> [18496.170579]  [<ffffffff81142af4>] __kmalloc+0x134/0x160
>>> [18496.186921]  [<ffffffff815832d0>] xen_blkbk_probe+0x170/0x2f0
>>> [18496.202963]  [<ffffffff81474ce7>] xenbus_dev_probe+0x77/0x130
>>> [18496.218714]  [<ffffffff8156a390>] ? __driver_attach+0xa0/0xa0
>>> [18496.234237]  [<ffffffff8156a151>] driver_probe_device+0x81/0x220
>>> [18496.249605]  [<ffffffff8198198c>] ? klist_next+0x8c/0x110
>>> [18496.264681]  [<ffffffff8156a390>] ? __driver_attach+0xa0/0xa0
>>> [18496.279500]  [<ffffffff8156a3db>] __device_attach+0x4b/0x50
>>> [18496.294138]  [<ffffffff815684e8>] bus_for_each_drv+0x68/0x90
>>> [18496.308553]  [<ffffffff8156a0c9>] device_attach+0x89/0x90
>>> [18496.322694]  [<ffffffff81569258>] bus_probe_device+0xa8/0xd0
>>> [18496.336640]  [<ffffffff81567c80>] device_add+0x650/0x720

>> .. snip..

>> Jens,
>> I don't know if you had pulled this git tree yet (I don't see it in
>> your for-3.10/* branches).

>> But if you have, Sander has found a bug (and Roger has a fix for it).

>> Whether you would like to wait until v3.11 to pull it (and me sending
>> the git pull around a month) is OK. Or pull it now and we will fix the
>> bugs in the -rc's as they creep up.

> Roger's fix seems to work for me ..

Hmm although it takes longer, i still see my memory getting souped-up.
Will see what setting:

echo 384 > /sys/module/xen_blkback/parameters/max_persistent_grants
echo 256 >> /sys/module/xen_blkback/parameters/max_buffer_pages

will do this time around.

--
Sander


(XEN) [2013-05-03 23:00:21] grant_table.c:1250:d1 Expanding dom (1) grant table from (7) to (8) frames.
(XEN) [2013-05-03 23:00:41] grant_table.c:1250:d1 Expanding dom (1) grant table from (8) to (9) frames.
(XEN) [2013-05-03 23:01:01] grant_table.c:1250:d1 Expanding dom (1) grant table from (9) to (10) frames.
(XEN) [2013-05-03 23:01:01] grant_table.c:1250:d1 Expanding dom (1) grant table from (10) to (11) frames.
(XEN) [2013-05-04 03:15:32] grant_table.c:289:d0 Increased maptrack size to 10 frames
(XEN) [2013-05-04 03:15:34] grant_table.c:1250:d9 Expanding dom (9) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:34] grant_table.c:1250:d9 Expanding dom (9) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:34] grant_table.c:1250:d9 Expanding dom (9) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:34] grant_table.c:289:d0 Increased maptrack size to 11 frames
(XEN) [2013-05-04 03:15:36] grant_table.c:1250:d8 Expanding dom (8) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:36] grant_table.c:1250:d8 Expanding dom (8) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:36] grant_table.c:289:d0 Increased maptrack size to 12 frames
(XEN) [2013-05-04 03:15:36] grant_table.c:289:d0 Increased maptrack size to 13 frames
(XEN) [2013-05-04 03:15:37] grant_table.c:1250:d4 Expanding dom (4) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:37] grant_table.c:1250:d4 Expanding dom (4) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:37] grant_table.c:1250:d4 Expanding dom (4) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:37] grant_table.c:289:d0 Increased maptrack size to 14 frames
(XEN) [2013-05-04 03:15:37] grant_table.c:289:d0 Increased maptrack size to 15 frames
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d3 Expanding dom (3) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d3 Expanding dom (3) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:289:d0 Increased maptrack size to 16 frames
(XEN) [2013-05-04 03:15:39] grant_table.c:289:d0 Increased maptrack size to 17 frames
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d13 Expanding dom (13) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d13 Expanding dom (13) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d13 Expanding dom (13) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:289:d0 Increased maptrack size to 18 frames
(XEN) [2013-05-04 03:15:39] grant_table.c:1250:d3 Expanding dom (3) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:39] grant_table.c:289:d0 Increased maptrack size to 19 frames
(XEN) [2013-05-04 03:15:40] grant_table.c:1250:d8 Expanding dom (8) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:42] grant_table.c:1250:d2 Expanding dom (2) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:42] grant_table.c:1250:d2 Expanding dom (2) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:42] grant_table.c:289:d0 Increased maptrack size to 20 frames
(XEN) [2013-05-04 03:15:42] grant_table.c:289:d0 Increased maptrack size to 21 frames
(XEN) [2013-05-04 03:15:42] grant_table.c:1250:d2 Expanding dom (2) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:43] grant_table.c:1250:d10 Expanding dom (10) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:44] grant_table.c:1250:d10 Expanding dom (10) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:44] grant_table.c:289:d0 Increased maptrack size to 22 frames
(XEN) [2013-05-04 03:15:44] grant_table.c:1250:d10 Expanding dom (10) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:45] grant_table.c:1250:d5 Expanding dom (5) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:45] grant_table.c:1250:d5 Expanding dom (5) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:45] grant_table.c:1250:d5 Expanding dom (5) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:45] grant_table.c:289:d0 Increased maptrack size to 23 frames
(XEN) [2013-05-04 03:15:45] grant_table.c:289:d0 Increased maptrack size to 24 frames
(XEN) [2013-05-04 03:15:50] grant_table.c:1250:d7 Expanding dom (7) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:15:50] grant_table.c:1250:d7 Expanding dom (7) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:15:50] grant_table.c:1250:d7 Expanding dom (7) grant table from (6) to (7) frames.
(XEN) [2013-05-04 03:15:50] grant_table.c:289:d0 Increased maptrack size to 25 frames
(XEN) [2013-05-04 03:15:52] grant_table.c:289:d0 Increased maptrack size to 26 frames
(XEN) [2013-05-04 03:16:04] grant_table.c:1250:d12 Expanding dom (12) grant table from (4) to (5) frames.
(XEN) [2013-05-04 03:16:05] grant_table.c:1250:d12 Expanding dom (12) grant table from (5) to (6) frames.
(XEN) [2013-05-04 03:16:05] grant_table.c:289:d0 Increased maptrack size to 27 frames
(XEN) [2013-05-04 03:16:05] grant_table.c:1250:d12 Expanding dom (12) grant table from (6) to (7) frames.
(XEN) [2013-05-04 05:15:05] grant_table.c:289:d0 Increased maptrack size to 28 frames
(XEN) [2013-05-04 05:15:09] grant_table.c:1250:d6 Expanding dom (6) grant table from (4) to (5) frames.
(XEN) [2013-05-04 05:15:09] grant_table.c:1250:d6 Expanding dom (6) grant table from (5) to (6) frames.
(XEN) [2013-05-04 05:15:09] grant_table.c:1250:d6 Expanding dom (6) grant table from (6) to (7) frames.
(XEN) [2013-05-04 05:15:09] grant_table.c:289:d0 Increased maptrack size to 29 frames


> --
> Sander

>> Thanks!



