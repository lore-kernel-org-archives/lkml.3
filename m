Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3IILQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:16:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37962 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3IILQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:16:13 -0400
MIME-Version: 1.0
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 16:45:32 +0530
Message-ID: <CALkWK0kjpMpMXHcwsHXDTY_SfM76TCK-O8Q1PTDH2bqD35n8rg@mail.gmail.com>
Subject: Segfault in running aarch64
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers appreciated.

% ./linux

Locating the bottom of the address space ... 0x1000
Locating the top of the address space ... 0xffffd000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm.../dev/shm...OK
Checking PROT_EXEC mmap in /dev/shm/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
Adding 21876736 bytes to physical memory to account for exec-shield gap
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.11.0-07890-ge5c832d (artagnon@kytes) (gcc version
4.8.1 20130725 (prerelease) (GCC) ) #1 Mon Sep 9 16:33:56 IST 2013
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 13427
Kernel command line: root=98:0
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Sorting __ex_table...
Memory: 28700K/54132K available (1755K kernel code, 549K rwdata, 584K
rodata, 77K init, 98K bss, 25432K reserved)
NR_IRQS:15
Calibrating delay loop... 8548.35 BogoMIPS (lpj=42741760)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
Checking for host processor cmov support...Yes
Checking that host ptys support output SIGIO...Yes
Checking that host ptys support SIGIO on close...No, enabling workaround
devtmpfs: initialized
Using 2.6 host AIO
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
Switched to clocksource itimer
NET: Registered protocol family 2
TCP established hash table entries: 512 (order: 0, 4096 bytes)
TCP bind hash table entries: 512 (order: -1, 2048 bytes)
TCP: Hash tables configured (established 512 bind 512)
TCP: reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
mconsole (version 2) initialized on /home/artagnon/.uml/WIiDlf/mconsole
Checking host MADV_REMOVE support...OK
Host TLS support detected
Detected host type: x86_64 (GDT indexes 12 to 15)
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 56
io scheduler noop registered
io scheduler deadline registered (default)
TCP: cubic registered
NET: Registered protocol family 17
Initialized stdio console driver
Console initialized on /dev/tty0
console [tty0] enabled
Initializing software serial port version 1
console [mc-1] enabled
Failed to initialize ubd device 0 :Couldn't determine size of device's file
VFS: Cannot open root device "98:0" or unknown-block(98,0): error -6
Please append a correct "root=" boot option; here are the available partitions:
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(98,0)
CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-07890-ge5c832d #1
0b069f20 08270a82 0b069f40 0820aae8 0b0853ec 0b069f70 0b10f000 fffffffa
       0b069f9c 080499b1 082502d8 0b069f70 08250287 08250254 082a6064 0b069f70
       fffffffa 06200000 0b069f70 0a0ce8e0 6e6b6e75 2d6e776f 636f6c62
3839286b 0b069ef8:  [<0805a0b0>] show_stack+0x54/0x8c
0b069f18:  [<0820c83d>] dump_stack+0x16/0x1b
0b069f2c:  [<0820aae8>] panic+0x67/0x149
0b069f44:  [<080499b1>] mount_block_root+0x199/0x1f7
0b069fa0:  [<08049a5d>] mount_root+0x4e/0x56
0b069fc4:  [<08049b78>] prepare_namespace+0x113/0x144
0b069fcc:  [<08049740>] kernel_init_freeable+0x18b/0x198
0b069fe4:  [<0820a5c3>] kernel_init+0x8/0xaf
0b069fec:  [<080592ab>] new_thread_handler+0x63/0x7c
0b069ffc:  [<00000000>] 0x0


EIP: 0023:[<f77a6430>] CPU: 0 Not tainted ESP: 002b:ff84584c EFLAGS: 00000296
    Not tainted
EAX: 00000000 EBX: 00001d6d ECX: 00000013 EDX: 00001d6d
ESI: 00001d69 EDI: 00000002 EBP: ff845878 DS: 002b ES: 002b
0b069ea4:  [<0806ad84>] show_regs+0xb4/0xbc
0b069ed0:  [<0805b1af>] panic_exit+0x20/0x36
0b069ee4:  [<08084f87>] notifier_call_chain+0x28/0x4b
0b069f0c:  [<08084fd8>] atomic_notifier_call_chain+0x15/0x17
0b069f1c:  [<0820ab00>] panic+0x7f/0x149
0b069f44:  [<080499b1>] mount_block_root+0x199/0x1f7
0b069fa0:  [<08049a5d>] mount_root+0x4e/0x56
0b069fc4:  [<08049b78>] prepare_namespace+0x113/0x144
0b069fcc:  [<08049740>] kernel_init_freeable+0x18b/0x198
0b069fe4:  [<0820a5c3>] kernel_init+0x8/0xaf
0b069fec:  [<080592ab>] new_thread_handler+0x63/0x7c
0b069ffc:  [<00000000>] 0x0

[1]    7529 abort (core dumped)  ./linux
                                        %
