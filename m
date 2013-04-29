Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab3D2P0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 11:26:45 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54796 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753464Ab3D2P0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 11:26:44 -0400
Date: Mon, 29 Apr 2013 17:26:39 +0200
From: Florian Westphal <fw@strlen.de>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Subject: "WRITE SAME failed. Manually zeroing" with 3w-xxxx driver
Message-ID: <20130429152639.GG32324@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After update to 3.8 dmesg is spammed with:

kernel: [ 280.272094] 3w-xxxx: scsi8: Unknown scsi opcode: 0x41
kernel: [ 280.272107] sd 8:0:0:0: [sda] Unhandled error code
kernel: [ 280.272110] sd 8:0:0:0: [sda]
kernel: [ 280.272112] Result: hostbyte=0x04 driverbyte=0x00
kernel: [ 280.272114] sd 8:0:0:0: [sda] CDB:
kernel: [ 280.272116] cdb[0]=0x41: 41 00 10 09 aa 22 00 00 08 00
kernel: [ 280.272123] end_request: I/O error, dev sda, sector 269068834
kernel: [ 280.272130] sda6: WRITE SAME failed. Manually zeroing.
[..]

This goes on and on.

I am not familiar with block layer or scsi drivers, so I don't know if this
is an issue with the 3w-xxxx driver or the block layer.

I've hacked around this by reverting "block: Make blkdev_issue_zeroout use WRITE SAME"
(579e8f3c7b2ecf7db91398d942d76457a3ddba21), as this hw doesn't support
write_same anyway.
