Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab3BUNQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 08:16:51 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:46038 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab3BUNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 08:16:49 -0500
Message-ID: <51261E30.9040907@gmail.com>
Date: Thu, 21 Feb 2013 08:16:32 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v4 00/32] ldisc patchset
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com> <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 03:02 PM, Peter Hurley wrote:
> Sasha and Dave, my trinity testbeds die in other areas right now;
> I would really appreciate if you would please re-test this series.

Hi Peter,

I saw this twice in overnight fuzzing:

[ 1473.912280] =================================
[ 1473.913180] [ BUG: bad contention detected! ]
[ 1473.914071] 3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8 Tainted: G        W
[ 1473.915684] ---------------------------------
[ 1473.916549] kworker/1:1/361 is trying to contend lock (&tty->ldisc_sem) at:
[ 1473.918031] [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
[ 1473.919060] but there are no locks held!
[ 1473.919813]
[ 1473.919813] other info that might help us debug this:
[ 1473.920044] 2 locks held by kworker/1:1/361:
[ 1473.920044]  #0:  (events){.+.+.+}, at: [<ffffffff811328a8>] process_one_work+0x228/0x6a0
[ 1473.920044]  #1:  ((&buf->work)){+.+...}, at: [<ffffffff811328a8>] process_one_work+0x228/0x6a0
[ 1473.920044]
[ 1473.920044] stack backtrace:
[ 1473.920044] Pid: 361, comm: kworker/1:1 Tainted: G        W    3.8.0-next-20130220-sasha-00038-g1ad55df-dirty #8
[ 1473.920044] Call Trace:
[ 1473.920044]  [<ffffffff81c493df>] ? tty_ldisc_ref+0x1f/0x60
[ 1473.920044]  [<ffffffff81182026>] print_lock_contention_bug+0xf6/0x110
[ 1473.920044]  [<ffffffff81184973>] lock_contended+0x213/0x4e0
[ 1473.920044]  [<ffffffff81c4bb41>] ldsem_down_read_trylock+0xb1/0xc0
[ 1473.920044]  [<ffffffff81c493df>] tty_ldisc_ref+0x1f/0x60
[ 1473.920044]  [<ffffffff81c4a687>] flush_to_ldisc+0x37/0x1a0
[ 1473.920044]  [<ffffffff811329e6>] process_one_work+0x366/0x6a0
[ 1473.920044]  [<ffffffff811328a8>] ? process_one_work+0x228/0x6a0
[ 1473.920044]  [<ffffffff811332a8>] worker_thread+0x238/0x370
[ 1473.920044]  [<ffffffff81133070>] ? rescuer_thread+0x310/0x310
[ 1473.920044]  [<ffffffff8113d873>] kthread+0xe3/0xf0
[ 1473.920044]  [<ffffffff8113d790>] ? flush_kthread_work+0x1f0/0x1f0
[ 1473.920044]  [<ffffffff83dab4fc>] ret_from_fork+0x7c/0xb0
[ 1473.920044]  [<ffffffff8113d790>] ? flush_kthread_work+0x1f0/0x1f0


Thanks,
Sasha
