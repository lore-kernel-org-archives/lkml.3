Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaA3Q6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:58:48 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44635 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaA3Q6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:58:47 -0500
MIME-Version: 1.0
Reply-To: for.poige+linux@gmail.com
From: Igor Podlesny <for.poige+linux@gmail.com>
Date: Fri, 31 Jan 2014 00:58:16 +0800
X-Google-Sender-Auth: oOJ_x9ZYPF_AZ4lxLwwVAQuQXQQ
Message-ID: <CA+sTkh4fYZr-8vBuhA0c1BRt5D7oNiK=KrSF+kJ2KRW7e_LFaA@mail.gmail.com>
Subject: That greedy Linux VM cache
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello!

   Probably every Linux newcomer's going to have concerns regarding
low free memory and hear an explanation from Linux old fellows that's
actually there's plenty of -- it's just cached, but when it's needed
for applications it's gonna be used -- on demand. I also thought so
until recently I noticed that even when free memory's is almost
exhausted (~ 75 Mib), and processes are in sleep_on_page_killable, the
cache is somewhat like ~ 500 MiB and it's not going to return back
what it's gained. Naturally, vm.drop_caches 3 doesn't squeeze it as
well. That drama has been happening on rather
outdated-but-yet-still-has-2GiB-of-RAM notebook with kernel from 3.10
till 3.12.9 (3.13 is the first release for a long time which simply
freezes the notebook so cold, that SysRq_B's not working, but that's
another story). Everything RAM demanding just yet crawls, load average
is getting higher and there's no paging out, but on going disk mostly
_read_ and a bit write activity. If vm.swaPPineSS not 0, it's swapping
out, but not much, right now I ran Chromium (in addition to long-run
Firefox) and only 32 MiB went to swap, load avg. ~ 7

   Again: 25 % is told (by top, free and finally /proc/meminfo) to be
cached, but kinda greedy.

   I came across similar issue report:
http://www.spinics.net/lists/linux-btrfs/msg11723.html but still
questions remain:

   * How to analyze it? slabtop doesn't mention even 100 MiB of slab
   * Why that's possible?
   * The system is on Btrfs but /home is on XFS, so disk I/O might be
related to text segment paging? But anyway this leads us to question,
hey, there's 500 MiB free^Wcached.

   While I'm thinking about moving system back to XFS...

   P. S. While writing these, swapped ~ 100 MiB, and cache reduced(!)
to 377 MiB, Firefox is mostly in "D" -- sleep_on_page_killable, so is
Chrome, load avg. ~ 7. I had to close Skype to be able to finish that
letter, and cached mem. now is 439 MiB. :) I know it's time to
upgrade, but hey, cached memory is free memory, right?

-- 
End of message. Next message?
