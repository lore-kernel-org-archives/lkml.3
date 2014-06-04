Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaFDJJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 05:09:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57806 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaFDJI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 05:08:59 -0400
Date: Wed, 4 Jun 2014 11:08:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140604090856.GA1196@amd.pavel.ucw.cz>
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

> Should this attempt be useless as well, I will, if you do not mind,
>try by asking you more details about your system and reproducing your
>configuration as much as I can.

It fails during boot or shortly after that when clicking in gnome2
desktop. I had BFQ as a default scheduler.

Now I set CFQ as a default and it boots (as expected).

root@duo:~# cat /sys/block/sda/queue/scheduler 
noop deadline [cfq] bfq 
root@duo:~# echo bfq > /sys/block/sda/queue/scheduler
root@duo:~# dmesg | grep WARN
WARNING: CPU: 1 PID: 1 at net/wireless/reg.c:479
regulatory_init+0x88/0xf5()
root@duo:~# 

Hmm, and I seem to have pretty much functional system.

I'll try to do some benchmarks now.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
