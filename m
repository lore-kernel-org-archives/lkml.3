Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaHSIXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:23:30 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:33479 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbaHSIX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:23:27 -0400
Date: Tue, 19 Aug 2014 11:22:16 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140729.162635.638786990787878495.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1408191120390.27327@math.ut.ee>
References: <20140414184353.GA5630@drone.musicnaut.iki.fi> <20140416.145822.1317931249717152474.davem@davemloft.net> <alpine.SOC.1.00.1404170119550.20193@math.ut.ee> <20140729.162635.638786990787878495.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meanwhile, a Ultra 1 with overnight looping git clone got exit_mmap 
warning again with 3.17.0-rc1. Otherwise it is working good.

[11052.686935] ------------[ cut here ]------------
[11052.740486] WARNING: CPU: 0 PID: 2541 at mm/mmap.c:2766 exit_mmap+0x138/0x160()
[11052.827934] Modules linked in: osst snd_sun_cs4231 snd_pcm snd_timer snd soundcore parport_sunbpp parport st ch qlogicpti sunhme ipv6 sr_mod cdrom sg evdev
[11052.994500] CPU: 0 PID: 2541 Comm: git Not tainted 3.17.0-rc1 #49
[11053.067464] Call Trace:
[11053.096647]  [00000000004d1758] exit_mmap+0x138/0x160
[11053.157091]  [000000000044c1ec] mmput+0x2c/0xc0
[11053.211256]  [000000000044e168] exit_mm+0x108/0x180
[11053.269597]  [000000000044f908] do_exit+0x228/0x320
[11053.327935]  [000000000044fae4] do_group_exit+0x24/0xc0
[11053.390440]  [000000000044fb94] SyS_exit_group+0x14/0x20
[11053.454004]  [0000000000406074] linux_sparc_syscall32+0x34/0x60
[11053.524809] ---[ end trace 7b6188ceaeca01dd ]---
[11053.580132] BUG: Bad rss-counter state mm:ffffff0032c778c0 idx:0 val:7

-- 
Meelis Roos (mroos@linux.ee)
