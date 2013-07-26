Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab3GZJ44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:56:56 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:62502 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab3GZJ4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:56:53 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: "'NeilBrown'" <neilb@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
References: <000501ce85fc$d3a60a10$7af21e30$@lucidpixels.com> <20130722090257.2faa0874@notabene.brown> <009801ce898c$34b83fc0$9e28bf40$@lucidpixels.com> <20130726103549.1e6b0b92@notabene.brown>
In-Reply-To: <20130726103549.1e6b0b92@notabene.brown>
Subject: RE: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x SSD)
Date: Fri, 26 Jul 2013 05:56:51 -0400
Message-ID: <001e01ce89e6$73f93b80$5bebb280$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQH8I1r+BgG/efe2pSqBd5Z4Tixg2AHT8x2TAb2IeWUC3a+m2Zjn7z7A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: NeilBrown [mailto:neilb@suse.de] 
Sent: Thursday, July 25, 2013 8:36 PM
To: Justin Piszcz
Cc: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
Subject: Re: 3.10.1: echo repair > sync_action causes hang on RAID-1 (2 x
SSD)

On Thu, 25 Jul 2013 19:10:50 -0400 "Justin Piszcz" <jpiszcz@lucidpixels.com>
wrote:

> Did the fix by chance make it into 3.10.3?

No, it looks like it missed again.  I gather there was a large inflow of
patches for -stable in the 3.11-rc1 merge window and Greg has been
processing
them in batches.  Hopefully in 3.10.4.

The relevant patch is commit 30bc9b53878a9921b02e3 in mainline.

NeilBrown

--

Method to get patch via git and patch kernel:

$ git clone
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
$ git log |grep 30bc9b53878a9921b02e3
commit 30bc9b53878a9921b02e3b5bc4283ac1c6de102a
$ git show 30bc9b53878a9921b02e3b5bc4283ac1c6de102a > /tmp/a
# patch -p1 < /tmp/a
patching file drivers/md/raid1.c
Hunk #1 succeeded at 1848 (offset -1 lines).
Hunk #2 succeeded at 1886 (offset -1 lines).
Hunk #3 succeeded at 1915 (offset -1 lines).

Reboot- tested, success, thanks..!

One follow-up question:
$ cat /sys/block/md1/md/mismatch_cnt
314112
-> On a live RAID-1 (root filesystem) without swap, is it normal to have
such a high mismatch_cnt even after a repair?

First repair:
Fri Jul 26 05:30:47 EDT 2013: The meta-device /dev/md1 has mismatch_cnt
314112 sectors.
Second repair:
Fri Jul 26 05:30:47 EDT 2013: The meta-device /dev/md1 has mismatch_cnt
313600 sectors.

Should I be concerned?


Testing the patch:

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [>....................]  check =  0.3% (838976/233381376)
finish=9.2min speed=419488K/sec

md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [===============>.....]  check = 77.5% (180889856/233381376)
finish=2.5min speed=342654K/sec

md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]

md0 : active raid1 sdc1[0] sdb1[1]
      1048512 blocks [2/2] [UU]


Justin.


