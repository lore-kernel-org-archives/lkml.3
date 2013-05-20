Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab3ETXal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:30:41 -0400
Received: from ishtar.tlinx.org ([173.164.175.65]:41410 "EHLO Ishtar.hs"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755549Ab3ETXaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:30:39 -0400
Message-ID: <519AB20D.7030503@tlinx.org>
Date: Mon, 20 May 2013 16:30:21 -0700
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>
CC: util-linux@vger.kernel.org, Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mount --no-canonical seems broken.
References: <5175BA15.9060803@tlinx.org> <20130423123648.GB24501@x2.net.home> <517729C7.2030806@tlinx.org> <20130520074001.GE16493@x2.net.home>
In-Reply-To: <20130520074001.GE16493@x2.net.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




Karel Zak wrote:
>
> The problem is that "mount" (without options) prints always canonicalized 
> paths (and in this case --no-canonicalize has no effect, this option
> is used for mounting only). It means if you have non-canonical paths
> in /etc/mtab then "mount" still prints canonical paths. I can fix it
> and make the output sensitive to --no-canonicalize option too.
>
> Anyway, use findmnt, it provides but complete control on the output.
>
>     Karel
>   
----
    Sure give better control, but not as widely known as "df" or "mount".

I might point out that by default,
> findmnt /

TARGET SOURCE    FSTYPE OPTIONS
/      /dev/root xfs    rw,nodiratime,relatime,attr2,inode64,noquota
> > l /dev/root
ls: cannot access /dev/root: No such file or directory

-----
It's not a device in /dev/ nor is it in /proc/devices.

Conversely, 

klogd 1.4.1, log source = ksyslog started.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-Isht-Van (law@Ishtar) (gcc version
4.7.2 20130205 [gcc-4_7-branch revision 195759] (SUSE Linux) ) #6 SMP
PREEMPT Wed May 8 17:28:40 PDT 2013
[    0.000000] Command line: BOOT_IMAGE=390-Isht-Van rw root=/dev/sdc1
root=/dev/sdc1 showopts console=ttyS0,115200n8 console=tty0 elevator=cfq
pcie_aspm=force pcie_ports=native reboot=bios

The kernel seems to know the root image at boot (even told twice from
this output!)

Not to mention, there is some comment in the kernel-related code of using
/dev/root because there is no writable storage available... even though
the command line
shows that root is mounted 'rw'...



