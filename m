Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3J2UMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:12:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab3J2UMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:12:18 -0400
Date: Tue, 29 Oct 2013 21:12:15 +0100
From: Jan Kara <jack@suse.cz>
To: John Twideldum <twideldums_throwaway@gmx.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.12-rc5 and overwritten partition table
Message-ID: <20131029201215.GD9568@quack.suse.cz>
References: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-ee0bd2b5-ce28-4895-8c2a-2f60f40e49f4-1383046621263@3capp-gmx-bs07>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-10-13 12:37:01, John Twideldum wrote:
> Hi...
> 
> I have a shiny new Haswell notebook (Lenovo T440s), where with 3.11 processor power
> management didn't work, so I got 3.12-rc5 installed.
> Worked fine for a few days, then today it no longer boots and inspection yields...
> 
> # dd if=/dev/sda count=1 |od -t c |tr -d " "
> 512 bytes (512 B) copied, 0.00115806 s, 442 kB/s
> 0000000 13.00000\nalsa:hw
> 0000020 C0D0\t99.00000\nal
> 0000040 sa:hwC0D3\t99.000
> 0000060 00\nbacklight:acp
> 0000100 i_video0\t73.0000
> 0000120 0\nbacklight:acpi
> 0000140 _video0-power\t10
> 0000160 0.00000\nbackligh
> 0000200 t:intel_backligh
> 0000220 t\t0.00000\nbackli
> 0000240 ght:intel_backli
> 0000260 ght-power\t0.0000
> 0000300 0\ncpu-consumptio
> 0000320 n\t0.00000\ncpu-wa
> 0000340 keups\t875.00000\n
> 0000360 disk-operations\t
> 0000400 0.00000\ndisk-ope
> 0000420 rations-hard\t0.0
> 0000440 0000\neth0-link-1
> 0000460 00\t0.00000\neth0-
> 0000500 link-1000\t0.0000
> 0000520 0\neth0-link-high
> 0000540 \t0.00000\neth0-pa
> 0000560 ckets\t0.00000\net
> 0000600 h0-powerunsave\t0
> 0000620 .00000\neth0-up\t0
> 0000640 .00000\ngpu-opera
> 0000660 tions\t134.00000\n
> 0000700radio:hci0\t100.0
> 00007200000\nradio:phy0\t
> 0000740100.00000\nradio:
> 0000760tpacpi_bluetooth
> 0001000
> 
> :-(
> 
> In order to figure out the reason for this, can you kernel guys maybe
> a) tell me what is that datastructure?
> b) can power management be buggy to cause this - I played with powertop tuneables
>  approximately while this happened?
> 
> ...and point me to a recovery tool/doc for finding the partitions again,
> "testdisk" tool only found 1 of 3, the least important one at the beginning of
> disk but not the rest :-(
  You can always look for fs-specific magic numbers in the superblock. What
filesystems did you use?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
