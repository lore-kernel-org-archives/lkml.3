Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbaFDKED (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 06:04:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59405 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbaFDKEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 06:04:01 -0400
Date: Wed, 4 Jun 2014 12:03:58 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: BFQ speed tests [was Re: [PATCH RFC - TAKE TWO - 00/12] New
 version of the BFQ I/O Scheduler]
Message-ID: <20140604100358.GA4799@amd.pavel.ucw.cz>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it>
 <20140530232804.GA5057@htj.dyndns.org>
 <20140602111432.GA3737@amd.pavel.ucw.cz>
 <20140602130226.GA14654@amd.pavel.ucw.cz>
 <FCFE0106-A4DD-4DEF-AAAE-040F3823A447@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FCFE0106-A4DD-4DEF-AAAE-040F3823A447@unimore.it>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Should this attempt be useless as well, I will, if you do not mind, try by asking you more details about your system and reproducing your configuration as much as I can.
> 

Try making BFQ the default scheduler. That seems to break it for me,
when selected at runtime, it looks stable.

Anyway, here are some speed tests. Background load:

root@duo:/data/tmp# echo cfq > /sys/block/sda/queue/scheduler 
root@duo:/data/tmp# echo 3 > /proc/sys/vm/drop_caches
root@duo:/data/tmp# cat /dev/zero > delme; cat /dev/zero > delme;cat
/dev/zero > delme;cat /dev/zero > delme;cat /dev/zero > delme;cat
/dev/zero > delme

(Machine was running out of disk space.)

(I alternate between cfq and bfq).

Benchmark. I chose git describe because it is part of kernel build
sometimes .. and I actually wait for that.

pavel@duo:/data/l/linux-good$ time git describe
warning: refname 'HEAD' is ambiguous.
v3.15-rc8-144-g405dedd

Unfortunately, results are not too good for BFQ. (Can you replicate
the results?)

# BFQ
10.24user 1.62system 467.02 (7m47.028s) elapsed 2.54%CPU
# CFQ
8.55user 1.26system 69.57 (1m9.577s) elapsed 14.11%CPU
# BFQ
11.70user 3.18system 1491.59 (24m51.599s) elapsed 0.99%CPU
# CFQ, no background load
8.51user 0.75system 30.99 (0m30.994s) elapsed 29.91%CPU
# CFQ
8.70user 1.36system 74.72 (1m14.720s) elapsed 13.48%CPU

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
