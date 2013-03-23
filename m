Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab3CWSn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 14:43:58 -0400
Received: from mout.gmx.net ([212.227.15.19]:52603 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab3CWSn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 14:43:57 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX192NogLUUh2cmtj+iiqOoPuWQ7Yz9lRSAaCfhPi15
	cwqJNQe5D5z2Z1
Message-ID: <514DF7E9.9050900@gmx.de>
Date: Sat, 23 Mar 2013 19:43:53 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: user-mode-linux-user@lists.sourceforge.net
Subject: kernel version 3.8.4 crashed while fuzzying with trinity
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That kernel crashed today at a stable 32 bit Gentoo Linux.
The screen shot (just a photo, b/c nothing was in the syslog) can be downloaded here [1].

The last action before I left the machine for a while was to start a user mode linux
(stale 32 bit Gentoo, kernel v3.9-rc3-324-g5da273) and run trinity within that system.

Please note that the host kernel crashed (UML probably too).

To feed trinity with victim files I NFSv4 mounted a directory located at the host system
under /tmp onto a mount point of the UML system (all file systems are EXT4).
That directory contained 100 files and 100 directory.
The trinity command line I used in the UML was :

$> trinity --children 4 --victims /mnt/nfs/n22/forT -x mremap -x clock_nanosleep

FWIW :	mremap gives within an UML guest with kernel 3.9-rcX this [2] using SLAB
	and with SLUB this [3];
	clock_nanosleep only slows down the tests

[1] http://ompldr.org/vaHV6YQ
[2] http://thread.gmane.org/gmane.linux.kernel/1462272
[3] http://sourceforge.net/mailarchive/forum.php?thread_name=5140E36D.2080606%40gmx.de&forum_name=user-mode-linux-user

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
