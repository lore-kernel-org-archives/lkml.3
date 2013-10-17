Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762698Ab3JQUmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:42:21 -0400
Received: from mout.gmx.net ([212.227.17.22]:53789 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756787Ab3JQUmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:42:19 -0400
Message-ID: <52604BA9.20104@gmx.de>
Date: Thu, 17 Oct 2013 22:42:17 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        NFS list <linux-nfs@vger.kernel.org>,
        list parisc-linux <parisc-linux@lists.parisc-linux.org>
Subject: 3.12-rcX - NFS regression - kswapd0 / kswapd1 stays using 100% CPU?
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ASGnyIePYdalaj/xNad2BeTGcC1rBWuX82/CPqHzseaaGTZVirw
 xmtgIeYlcJgwtY04v4Oj+4QPMeu3zGduezAqEg3H2Fq/CFNXHqOxAmLZiSlhHNJ5kitvSm5
 es8Os7a9E6JLnGfCUg0YDmRKw/QeQXPuhjVC5Q1mwzneQSTVomqejUp+a0pnEK17+pBg79u
 KhhggEazBTSrkF59KvAYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a regression with current kernel git head when using NFS-mounts.
Architecture in my case is parisc, although I don't think that this is relevant.
At least kernel 3.10 (and I think 3.11) didn't showed that problem.

The symtom is, that "top" shows high usage of either kswapd0 or kswapd1.
Here is an output with kswapd1:
  PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM     TIME+ COMMAND
   37 root      20   0     0    0    0 R  91.8  0.0  63:00.40 kswapd1
28448 root      20   0  3252 1428 1060 R  15.3  0.0   0:00.09 top
    1 root      20   0  2784  988  852 S   0.0  0.0   0:09.95 init

This is what ps shows:
lsXXXX:~# ps -ef |  grep mount
root      1181     1  0 14:51 ?        00:00:18 /usr/sbin/automount --pid-file /var/run/autofs.pid
root     25331  1181  0 21:25 ?        00:00:00 /bin/mount -n -t nfs -s -o nolock,rw,hard,intr homes:/unixhome1 /net/home1
root     25332 25331  0 21:25 ?        00:00:00 /sbin/mount.nfs homes:/unixhome1 /net/home1 -s -n -o rw,nolock,hard,intr

And using sysrq to show the blocked tasks I get in syslog:
SysRq : Show Blocked State
mount.nfs       D 00000000401040c0     0 25332  25331 0x00000010
Backtrace:
[<0000000040113a68>] __schedule+0x500/0x810

I know it's not a problem of the NFS server, since the same mount is still ok on other machines.
The NFS directory was already mounted and in use when this mount happened again (called by cron-job). 
 
Any ideas?

Helge
