Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3EFJIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:08:19 -0400
Received: from kamaji.grokhost.net ([87.117.218.43]:42907 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3EFJIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:08:18 -0400
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 05:08:18 EDT
Message-ID: <518770DC.10608@bootc.net>
Date: Mon, 06 May 2013 09:59:08 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lars Ellenberg <lars.ellenberg@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org
Subject: drbd: kernels 3.7 => 3.8 broken userspace compatibility
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I upgraded from a 3.7.x kernel to a 3.8.x kernel on a test machine
running DRBD, and found myself unable to bring up my DRBD devices. I'm
using the 8.3.13 userspace tools as shipped in Debian Wheezy, which work
fine on the 3.7 kernel, but they appear to hang when using the 3.8
kernel and cannot set up the device.

The 3.8 kernel appears to introduce drbd 8.4.2 rather than the 8.3.13
available in 3.7.

The hang seems to be caused by lots of the following:

[pid  7631] socket(PF_NETLINK, SOCK_DGRAM, 11) = 8
[pid  7631] getpid()                    = 7631
[pid  7631] bind(8, {sa_family=AF_NETLINK, pid=7631, groups=ffffffff},
12) = 0
[pid  7631] sendto(8,
"4\0\0\0\3\0\0\0\1\0\0\0\317\35\0\0\4\0\0\0\1\0\0\0\1\0\0\0\317\35\0\0"...,
52, 0, NULL, 0) = 52
[pid  7631] poll([{fd=8, events=POLLIN}], 1, 120000 <unfinished ...>
[pid  7630] <... read resumed> 0x7fff6d011a30, 1024) = ? ERESTARTSYS (To
be restarted)
[pid  7630] --- SIGALRM (Alarm clock) @ 0 (0) ---
[pid  7630] rt_sigreturn(0xe)           = -1 EINTR (Interrupted system call)
[pid  7630] close(8)                    = 0
[pid  7630] wait4(7631, Process 7630 suspended

I asked for help on the #drbd channel on FreeNode, and the only remark I
got there was that I should upgrade the userspace tools. Somehow, that
doesn't feel right to me - can a newer kernel require new userspace
tools to still be able to use a certain kernel functionality at all?
Doesn't this fall under not breaking userspace with new kernel versions?

Even if the kernel did require new userspace tools, should there not be
some better mechanism to notify the user they must upgrade them before
things will work? At the moment all I see without strace is:

# drbdadm attach r0
DRBD module version: 8.4.2
   userland version: 8.3.13
you should upgrade your drbd tools!
[hang]

There is nothing in dmesg during this time, either.

Cheers,
Chris

PS: Please ensure you CC me as I'm no longer an LKML subscriber.

-- 
Chris Boot
bootc@bootc.net

