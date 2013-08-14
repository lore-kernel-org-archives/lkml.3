Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711Ab3HNOo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:44:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48641 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3HNOoz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <CACQ1gAjDWvFENTieOy45T2LD7uzaJGyd5nvxWFFavoij-sAfLA@mail.gmail.com>
References: <CACQ1gAjDWvFENTieOy45T2LD7uzaJGyd5nvxWFFavoij-sAfLA@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 14 Aug 2013 16:44:34 +0200
Message-ID: <CACQ1gAhGKB0SLemMHSYVMmLSyLNqj3FgT9Se-8t3YBSWfLsx1g@mail.gmail.com>
Subject: Re: Regression V3.11-rc1 bisected: [readdir] convert procfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/12 Richard Genoud <richard.genoud@gmail.com>:
> Hi,
>
> I've found something peculiar while I was testing v3.11:
> There's a lot of directory missing (actually hiding) in /proc :
>
> /proc/sys/, /proc/fs/, /proc/bus/ etc...
> all the directories that are not PIDs are in "stealth mode":
> they don't appear with an ls (nor a find), but I can list their contents.
>
> I've bisecting that to the commit
> f0c3b5093addc8bfe9fe3a5b01acb7ec7969eafa ( [readdir] convert procfs )
>
> This happens on nfsroot, but also on UBIFS.
>
> Here are my platform details:
> - arm (at91sam9g35-ek)
> - defconfig attached
> - using uImage and at91sam9g35ek.dtb
> - libuClibc-0.9.33.2.so
>
>
> # ls -l /proc/
> total 0
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 1/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 121/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 123/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 125/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:15 1306/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:15 1307/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 2/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 236/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 237/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 242/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 243/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 244/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 245/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 3/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 313/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 314/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 326/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 328/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 331/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 361/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 362/
> dr-xr-xr-x    7 dbus     dbus             0 Dec 31 17:00 364/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 372/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 376/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 378/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 389/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 390/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 5/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 6/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 7/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 8/
> dr-xr-xr-x    7 root     root             0 Dec 31 17:00 9/
> -r--r--r--    1 root     root             0 Dec 31 17:15 buddyinfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 cmdline
> -r--r--r--    1 root     root          8478 Dec 31 17:15 config.gz
> -r--r--r--    1 root     root             0 Dec 31 17:15 consoles
> -r--r--r--    1 root     root             0 Dec 31 17:15 cpuinfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 crypto
> -r--r--r--    1 root     root             0 Dec 31 17:15 devices
> -r--r--r--    1 root     root             0 Dec 31 17:15 diskstats
> -r--r--r--    1 root     root             0 Dec 31 17:15 filesystems
> -r--r--r--    1 root     root             0 Dec 31 17:15 interrupts
> -r--r--r--    1 root     root             0 Dec 31 17:15 kallsyms
> -r--r--r--    1 root     root             0 Dec 31 17:15 key-users
> -r--------    1 root     root             0 Dec 31 17:15 kmsg
> -r--------    1 root     root             0 Dec 31 17:15 kpagecount
> -r--------    1 root     root             0 Dec 31 17:15 kpageflags
> -r--r--r--    1 root     root             0 Dec 31 17:15 loadavg
> -r--r--r--    1 root     root             0 Dec 31 17:15 locks
> -r--r--r--    1 root     root             0 Dec 31 17:15 meminfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 pagetypeinfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 partitions
> lrwxrwxrwx    1 root     root             0 Dec 31 17:00 self -> 1307/
> -r--------    1 root     root             0 Dec 31 17:15 slabinfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 softirqs
> -r--r--r--    1 root     root             0 Dec 31 17:15 stat
> --w-------    1 root     root             0 Dec 31 17:15 sysrq-trigger
> -r--r--r--    1 root     root             0 Dec 31 17:15 timer_list
> -r--r--r--    1 root     root             0 Dec 31 17:15 uptime
> -r--r--r--    1 root     root             0 Dec 31 17:15 version
> -r--------    1 root     root             0 Dec 31 17:15 vmallocinfo
> -r--r--r--    1 root     root             0 Dec 31 17:15 vmstat
> -r--r--r--    1 root     root             0 Dec 31 17:15 zoneinfo
> # ls -ld /proc/sy*
> --w-------    1 root     root             0 Dec 31 17:15 /proc/sysrq-trigger
> # ls -ld /proc/sys
> dr-xr-xr-x    1 root     root             0 Dec 31 17:00 /proc/sys/
> # ls -l /proc/sys/
> total 0
> dr-xr-xr-x    1 root     root             0 Dec 31 17:16 debug/
> dr-xr-xr-x    1 root     root             0 Dec 31 17:16 dev/
> dr-xr-xr-x    1 root     root             0 Dec 31 17:16 fs/
> dr-xr-xr-x    1 root     root             0 Dec 31 17:00 kernel/
> dr-xr-xr-x    1 root     root             0 Dec 31 17:00 net/
> dr-xr-xr-x    1 root     root             0 Dec 31 17:16 vm/
> # uname -a
> Linux LNS 3.10.0-rc6-00032-gf0c3b50 #34 Mon Aug 12 15:30:14 CEST 2013
> armv5tejl GNU/Linux
> # cat /proc/cmdline
> console=ttyS0,115200 loglevel=8 ip=dhcp root=/dev/nfs
> nfsroot=10.128.0.9:/nfsroot,v3
>

I did some research, and the problem appears when the readdir64
function of µClibc is used.
i.e. when I compile this c file :
#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>

int main(int argc, char **argv)
{
    struct dirent *entry;
    DIR *dir;

    dir = opendir("/proc");
    if (!dir) {
        return -1;
    }
    while ((entry = readdir(dir))) {
        printf("|%s|\n", entry->d_name);
    }
    closedir(dir);
    return 0;
}

with:
arm-none-linux-gnueabi-gcc -Wall -D_LARGEFILE_SOURCE
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
it uses the readdir64 function, and some dirs in /proc are not listed.
but without the flags, /proc listing is ok.

NB: with a code sourcery pre-compiled toolchain, the listing of /proc is ok.

So it must be a problem in the uClibc implementation of readdir64.


Richard.
