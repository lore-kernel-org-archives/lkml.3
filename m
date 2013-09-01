Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3IAOCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 10:02:14 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:35585 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3IAOCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 10:02:13 -0400
Message-ID: <522348C0.3040405@gmail.com>
Date: Sun, 01 Sep 2013 16:01:36 +0200
From: =?UTF-8?B?TWFydGluIE1PS1JFSsWg?= <mmokrejs@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0 SeaMonkey/2.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Emulating ECC RAM in kernel or mirroring RAM to exclude HW issues
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  I am trying to find out why some applications crash on my laptop.
I mostly use python and have configured it via configure --with-pydebug
so that is wraps memory allocated regions with 0xfb. That helps to realize
something overwrote that memory region. So far, it twice reported
0xfb to 0xfa transition at some logical position 5. I was told python cannot
print physical hardware address but let's assume this is a memory error
and one bit was flipped. However, sometimes other apps crash as well and
I think I tried enough to run core dumps through gdb to find out where they
crashed and it does not to an answer.
  I tried for hours memtest86+ to find an error but is never found anything
wrong. From my experience, the errors appear when the CPU is loaded and that
is not under memtest86+ started from a boot CD. I think it another reason why
memtest86+ maybe does not find the problematic bit is that it would have to
fill whole RAM with e.g. 0xfb and scan those values all remaining hours whether
they still read as 0xfb. It seems all write&read tests done by memtest86+ happen
too quickly after each other. I lack tests where the data if written into memory
and kept there for a long while (hours, days).

  Finally, I got an idea that linux kernel could emulate ECC RAM and just keep
some checksums in another region of memory. This would to find not only flipped
memory bit but even other (larger) corrupted regions of memory. I don't need
speed (running apps under valgrind/DUMA is not fast either) and I don't need
memory hotplug. Let's say this is for diagnostic purpose. I don't mind if somebody
says I have to sacrifice 1/2 of my precious RAM to do software memory mirroring.
Even that would be cool trick! to get around and see where is the bug hiding.
I somewhat speculate it could be just a bit overheated memory controller after
high CPU usage or the CPU or its cache gets upset and has nothing to do with RAM.
When it is cold, it works. But, first I need a proof that RAM is not at fault.

  I think somebody must already thought about this so I am just asking what do
you think. Maybe this is already available in some linux source tree as a
proof-of-the-concept patch. ;) That would be great. 

https://www.usenix.org/legacy/event/atc10/tech/full_papers/Li.pdf

Thank you,
Martin
