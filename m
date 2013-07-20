Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3GTBfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 21:35:10 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39401 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3GTBfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 21:35:08 -0400
Date: Fri, 19 Jul 2013 21:35:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [3.11-rc1 regression] ext4_evict_inode triggers
 warn_slowpath_common on sparc64
Message-ID: <20130720013500.GC12042@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
References: <20969.30581.961878.138915@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20969.30581.961878.138915@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 07:29:25PM +0200, Mikael Pettersson wrote:
> I keep getting the following warning with 3.11-rc1 on sparc64:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 8174 at fs/ext4/inode.c:230 ext4_evict_inode+0x1f0/0x448()
> Modules linked in: sunrpc af_packet ipv6 hid_generic snd_ali5451 snd_ac97_codec snd_seq snd_seq_device snd_pcm tg3 snd_timer flash ohci_pci hwmon snd soundcore ptp evdev sg i2c_ali1535 ohci_hcd pps_core snd_page_alloc i2c_core ac97_bus sr_mod cdrom pata_ali libata
> CPU: 1 PID: 8174 Comm: xgcc Not tainted 3.11.0-rc1 #1
> Call Trace:
>  [00000000004537b0] warn_slowpath_common+0x4c/0x64
>  [0000000000540d78] ext4_evict_inode+0x1f0/0x448
>  [00000000004f3938] evict+0xb8/0x190
>  [00000000004e99bc] do_unlinkat+0xf4/0x160
>  [0000000000406174] linux_sparc_syscall32+0x34/0x40
> ---[ end trace cd72b9e3e68d89e4 ]---
> 
> The Comm varies, but the call trace always looks like that.  Happens a couple
> of times per day, so far.  No other ill effects observed.  Didn't happen in 3.10
> or older kernels.

The fix, commit 822dbba33458cd6ad is already in Linus's tree, and will
be included in -rc2.

Note that this can cause memory corruption caused by a use-after-free.
I've not noticed a problem in my personal testing, but it's been
reported to me that with stress testing (using memory cgroups amonng
other things) and the system wedged when the machine was rebooted
after the tests were completed, and it only came back after the
watchdog timer fired.  The fix up was one of the first things which
Linus pulled after releasing -rc1, so you can merge 47188d39b5de to
get the fixes.


Cheers,

					- Ted
