Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaGTTWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 15:22:11 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:41097 "EHLO
	Ishtar.hs.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaGTTWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 15:22:10 -0400
X-Greylist: delayed 2100 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Jul 2014 15:22:10 EDT
Message-ID: <53CC0EAA.2010202@tlinx.org>
Date: Sun, 20 Jul 2014 11:47:06 -0700
From: "Linda A. Walsh" <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Howto tell kernel to use 4096 as granularity & minimum size?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a hard disk with a "512e" sector size: emulated 512, really 4096.

The disk returns a 512-byte size to drivers for compatibility.

I can partition the disk and setup the allocation size
to 4096, but I'd like to tell the kernel to use a
virtual-size of 4096 for the sector as an additional
performance 'hint', so nothing will even try to use
smaller i/o's than that.

However, this doesn't seem to work ("# prompt" does mean root):

/sys/block/sdd/queue#   echo 4096 >minimum_io_size    
bash: minimum_io_size: Permission denied

I realize this is probably implemented as a R-O value,
but it there a reason it needs to be if an admin
wants to increase it to a multiple of an emulated
I/O size so as to have it represent the physical
sector size?

I.e. if the "/sys" code was patched to allow modification
of this variable, would it work for the purpose
I am describing (i.e. ignoring emulated 512 size and
using the real 4096 size as a minimum (I wouldn't
intend or want this to affect the sector# addressing,
which would still be done using 512B sector blocks.

Thanks!


