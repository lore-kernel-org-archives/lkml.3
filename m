Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbaHHQkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:40:42 -0400
Received: from mail.aswsp.com ([193.34.35.150]:37225 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbaHHQkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:40:41 -0400
Date: Fri, 8 Aug 2014 18:40:49 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: <linux-kernel@vger.kernel.org>
Subject: perf on biarch
Message-ID: <20140808184049.65e7d32b@parrot.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a 64 bits kernel running with 32 bits binaries.
If I run 32 bits perf on this 64 bits kernel 3.14, I got weird result :

- perf trace doesn't work [1]
- perf record with dwarf call-graph doesn't work [2]


Matthieu


[1]
$ sudo perf trace ls
     0.009 ( 0.000 ms):  ... [continued]: close()) = 1
     0.040 ( 0.000 ms):  ... [continued]: munmap()) = -1 ENOENT No such file or directory
     0.046 ( 0.005 ms): munmap(arg0: -2632121, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = -1 ENOENT No such file or directory
     0.052 ( 0.004 ms): munmap(arg0: -2632120, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = -1 ENOENT No such file or directory
     0.058 ( 0.004 ms): munmap(arg0: -2632115, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = -1 ENOENT No such file or directory
     0.064 ( 0.004 ms): munmap(arg0: -2632114, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = -1 ENOENT No such file or directory
     0.069 ( 0.004 ms): munmap(arg0: -2632111, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = -1 ENOENT No such file or directory
     4.570 ( 4.498 ms): munmap(arg0: -2632110, arg1: 0, arg2: -2621656, arg3: 0, arg4: 159334824, arg5: 0) = 0
     4.603 ( 4.532 ms):  ... [continued]: recvfrom()) = 145719296
     4.635 ( 4.564 ms):  ... [continued]: dup2()) = -1 ENOENT No such file or directory
     4.643 ( 4.572 ms):  ... [continued]: lgetxattr()) = -143216640
     4.658 ( 0.004 ms): dup2(arg0: 1303966526, arg1: 0, arg2: 4, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     4.678 ( 0.023 ms):  ... [continued]: fstat()) = 3
     4.682 ( 0.028 ms):  ... [continued]: removexattr()) = 0
     4.689 ( 0.005 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 164475, arg3: 0, arg4: 1, arg5: 0   ) = -143384576
     4.693 ( 0.009 ms):  ... [continued]: lstat()) = 0
     4.702 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     4.721 ( 0.005 ms): fstat(arg0: -143294523, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
     4.725 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4714640, arg3: 0, arg4: 512, arg5: 0   ) = 512
     4.736 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4714864, arg3: 0, arg4: 1303994368, arg5: 0) = 0
     4.747 ( 0.006 ms): lgetxattr(arg0: 1096056832, arg1: 0, arg2: 142540, arg3: 0, arg4: 5, arg5: 0) = 1096056832
     4.760 ( 0.010 ms): lgetxattr(arg0: 1096187904, arg1: 0, arg2: 8192, arg3: 0, arg4: 3, arg5: 0) = 1096187904
     4.777 ( 0.005 ms): lgetxattr(arg0: 1096196096, arg1: 0, arg2: 3276, arg3: 0, arg4: 3, arg5: 0) = 1096196096
     4.783 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
     4.794 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     4.813 ( 0.007 ms): fstat(arg0: -143227586, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
     4.817 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4714672, arg3: 0, arg4: 512, arg5: 0   ) = 512
     4.822 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4714896, arg3: 0, arg4: 1303994368, arg5: 0) = 0
     4.830 ( 0.005 ms): lgetxattr(arg0: 1325760512, arg1: 0, arg2: 33148, arg3: 0, arg4: 5, arg5: 0) = 1325760512
     4.839 ( 0.006 ms): lgetxattr(arg0: 1325789184, arg1: 0, arg2: 8192, arg3: 0, arg4: 3, arg5: 0) = 1325789184
     4.851 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
     4.859 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     4.872 ( 0.007 ms): fstat(arg0: -143237622, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
     4.876 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4714704, arg3: 0, arg4: 512, arg5: 0   ) = 512
     4.881 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4714928, arg3: 0, arg4: 1303994368, arg5: 0) = 0
     4.887 ( 0.004 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0     ) = -143388672
     4.899 ( 0.006 ms): lgetxattr(arg0: 1304006656, arg1: 0, arg2: 1747580, arg3: 0, arg4: 5, arg5: 0) = 1304006656
     4.911 ( 0.010 ms): lgetxattr(arg0: 1305731072, arg1: 0, arg2: 12288, arg3: 0, arg4: 3, arg5: 0) = 1305731072
     4.927 ( 0.006 ms): lgetxattr(arg0: 1305743360, arg1: 0, arg2: 10876, arg3: 0, arg4: 3, arg5: 0) = 1305743360
     4.933 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
     4.943 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     4.959 ( 0.006 ms): fstat(arg0: -143285411, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
     6.218 ( 1.251 ms): close(arg0: 3, arg1: 0, arg2: -4714880, arg3: 0, arg4: 512, arg5: 0   ) = 512
     6.229 ( 0.003 ms): removexattr(arg0: 3, arg1: 0, arg2: -4715104, arg3: 0, arg4: 1303994368, arg5: 0) = 0
     6.240 ( 0.008 ms): lgetxattr(arg0: 1096454144, arg1: 0, arg2: 457912, arg3: 0, arg4: 5, arg5: 0) = 1096454144
ABOUT-NLS        delpart        lib           mkfs.minix        setsid
     6.251 ( 0.008 ms): lgetxattr(arg0: 1096908800, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0) = 1096908800
aclocal.m4       disk-utils     libblkid      mkswap            setterm
addpart          dmesg          libblkid.la   more              sfdisk
     6.267 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
agetty           Documentation  libcommon.la  mount             stamp-h1
     6.281 ( 0.005 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
     6.298 ( 0.008 ms): fstat(arg0: -143245964, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
AUTHORS          eject          libfdisk      mount-deprecated  su
     6.302 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4714912, arg3: 0, arg4: 512, arg5: 0   ) = 512
autogen.sh       fallocate      libfdisk.la   mountpoint        sulogin
     6.307 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4715136, arg3: 0, arg4: 1303994368, arg5: 0) = 0
bash-completion  fdformat       libmount      namei             swaplabel
     6.317 ( 0.007 ms): lgetxattr(arg0: 1305763840, arg1: 0, arg2: 16512, arg3: 0, arg4: 5, arg5: 0) = 1305763840
     6.330 ( 0.010 ms): lgetxattr(arg0: 1305776128, arg1: 0, arg2: 8192, arg3: 0, arg4: 3, arg5: 0) = 1305776128
     6.342 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
blkdiscard       fdisk          libmount.la   NEWS              swapoff
     6.353 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
blkid            fdisks         libtool       nologin           swapon
     6.362 ( 0.006 ms): fstat(arg0: -143230570, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
blockdev         findfs         libuuid       nsenter           switch_root
     6.366 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4714976, arg3: 0, arg4: 512, arg5: 0   ) = 512
cal              findmnt        libuuid.la    partx             sys-utils
     6.371 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4715200, arg3: 0, arg4: 1303994368, arg5: 0) = 0
cfdisk           flock          logger        pg                tailf
     6.379 ( 0.006 ms): lgetxattr(arg0: 1325576192, arg1: 0, arg2: 20656, arg3: 0, arg4: 5, arg5: 0) = 1325576192
ChangeLog        fsck           login         pivot_root        taskset
     6.389 ( 0.008 ms): lgetxattr(arg0: 1325592576, arg1: 0, arg2: 8192, arg3: 0, arg4: 3, arg5: 0) = 1325592576
chcpu            fsck.cramfs    login-utils   po                term-utils
     6.401 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
chrt             fsck.minix     look          prlimit           tests
     6.411 ( 0.003 ms): dup2(arg0: 1303967744, arg1: 0, arg2: 0, arg3: 0, arg4: 1303994368, arg5: 0) = -1 ENOENT No such file or directory
col              fsfreeze       losetup       raw               text-utils
     6.421 ( 0.006 ms): fstat(arg0: -143288370, arg1: 0, arg2: 524288, arg3: 0, arg4: 0, arg5: 0) = 3
colcrt           fstrim         lsblk         README            tools
     6.425 ( 0.003 ms): close(arg0: 3, arg1: 0, arg2: -4715008, arg3: 0, arg4: 512, arg5: 0   ) = 512
colrm            getopt         lscpu         README.licensing  ul
     6.430 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4715232, arg3: 0, arg4: 1303994368, arg5: 0) = 0
column           hexdump        lslocks       readprofile       umount
     6.439 ( 0.006 ms): lgetxattr(arg0: 1306087424, arg1: 0, arg2: 111276, arg3: 0, arg4: 5, arg5: 0) = 1306087424
config           hwclock        m4            rename            unshare
     6.453 ( 0.011 ms): lgetxattr(arg0: 1306185728, arg1: 0, arg2: 8192, arg3: 0, arg4: 3, arg5: 0) = 1306185728
config.h         include        Makefile      renice            utmpdump
     6.468 ( 0.005 ms): lgetxattr(arg0: 1306193920, arg1: 0, arg2: 4780, arg3: 0, arg4: 3, arg5: 0) = 1306193920
config.h.in      ionice         Makefile.am   resizepart        uuidd
     6.474 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 10, arg3: 0, arg4: 1303994368, arg5: 0  ) = 0
config.log       ipcmk          Makefile.in   rev               uuidgen
     6.501 ( 0.005 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0     ) = -143392768
config.status    ipcrm          mcookie       rtcwake           wall
     6.526 ( 0.003 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0     ) = -143396864
configure        ipcs           mesg          runuser           wdctl
     6.534 ( 0.010 ms):  ... [continued]: mq_timedreceive()) = 0
configure.ac     isosize        misc-utils    schedutils        whereis
     6.589 ( 0.066 ms):  ... [continued]: capget()) = 0
COPYING          kill           mkfs          script            wipefs
     6.598 ( 0.007 ms): capget(arg0: 1096187904, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
ctrlaltdel       last           mkfs.bfs      scriptreplay
     6.606 ( 0.005 ms): capget(arg0: 1325789184, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
cytune           ldattach       mkfs.cramfs   setarch
     6.615 ( 0.007 ms): capget(arg0: 1305731072, arg1: 0, arg2: 8192, arg3: 0, arg4: 1, arg5: 0) = 0
     6.621 ( 0.004 ms): capget(arg0: 1305776128, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
     6.631 ( 0.008 ms): capget(arg0: 1303990272, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
     6.638 ( 0.005 ms): capget(arg0: 1325592576, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
     6.645 ( 0.005 ms): capget(arg0: 1306185728, arg1: 0, arg2: 4096, arg3: 0, arg4: 1, arg5: 0) = 0
     6.664 ( 0.023 ms):  ... [continued]: fchmod()) = 0
     6.676 ( 0.035 ms):  ... [continued]: mkdirat()) = 12496
     6.679 ( 0.039 ms):  ... [continued]: process_vm_writev()) = 0
     6.690 ( 0.049 ms):  ... [continued]: create_module()) = 0
     6.693 ( 0.002 ms): create_module(arg0: 33, arg1: 0, arg2: -4714396, arg3: 0, arg4: 0, arg5: 0) = 0
     6.698 ( 0.006 ms):  ... [continued]: init_module()) = 0
     6.704 ( 0.013 ms):  ... [continued]: getxattr()) = 0
     6.717 ( 0.025 ms):  ... [continued]: setfsuid()) = 0
     6.768 ( 0.076 ms):  ... [continued]: fchmodat()) = -1 ENOENT No such file or directory
     6.774 ( 0.002 ms): fchmodat(arg0: 1096156682, arg1: 0, arg2: 84, arg3: 0, arg4: -4713636, arg5: 0) = -1 ENOENT No such file or directory
     6.870 ( 0.002 ms): recvfrom(arg0: 0, arg1: 0, arg2: 4095, arg3: 0, arg4: 1305739264, arg5: 0) = 145719296
     6.876 ( 0.004 ms): recvfrom(arg0: 145854464, arg1: 0, arg2: 145719296, arg3: 0, arg4: 1305739264, arg5: 0) = 145854464
     6.902 ( 0.012 ms): fstat(arg0: 1096156647, arg1: 0, arg2: 32768, arg3: 0, arg4: 438, arg5: 0) = 3
     6.914 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: -4713824, arg3: 0, arg4: 1305739264, arg5: 0) = 0
     6.922 ( 0.004 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0     ) = -143220736
     6.950 ( 0.025 ms): close(arg0: 3, arg1: 0, arg2: -143220736, arg3: 0, arg4: 1024, arg5: 0) = 399
     6.965 ( 0.002 ms): close(arg0: 3, arg1: 0, arg2: -143220736, arg3: 0, arg4: 1024, arg5: 0) = 0
     6.975 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 0, arg3: 0, arg4: 1305739264, arg5: 0   ) = 0
     6.987 ( 0.007 ms): fchmod(arg0: -143220736, arg1: 0, arg2: 4096, arg3: 0, arg4: 1305739264, arg5: 0) = 0
     7.027 ( 0.008 ms): fstat(arg0: 1305457212, arg1: 0, arg2: 557056, arg3: 0, arg4: 1303886029, arg5: 0) = 3
     7.031 ( 0.002 ms): removexattr(arg0: 3, arg1: 0, arg2: 1305743392, arg3: 0, arg4: 1305739264, arg5: 0) = 0
     7.039 ( 0.006 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 1854032, arg3: 0, arg4: 1, arg5: 0  ) = -145252352
     7.048 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 1305739264, arg3: 0, arg4: -145252352, arg5: 0) = 0
     7.097 ( 0.051 ms):  ... [continued]: setsockopt()) = 0
     7.102 ( 0.002 ms): setsockopt(arg0: 1, arg1: 0, arg2: 21523, arg3: 0, arg4: -4714188, arg5: 0) = 0
     7.137 ( 0.038 ms):  ... [continued]: preadv()) = 3
     7.170 ( 0.070 ms):  ... [continued]: semtimedop()) = 4600
     7.235 ( 0.003 ms): semtimedop(arg0: 3, arg1: 0, arg2: 145734428, arg3: 0, arg4: 32768, arg5: 0) = 0
     7.240 ( 0.002 ms): lstat(arg0: 3, arg1: 0, arg2: 1305740320, arg3: 0, arg4: 145739015, arg5: 0) = 0
     7.602 ( 0.004 ms): removexattr(arg0: 1, arg1: 0, arg2: -4723712, arg3: 0, arg4: 1305739264, arg5: 0) = 0
     7.611 ( 0.006 ms): lgetxattr(arg0: 0, arg1: 0, arg2: 4096, arg3: 0, arg4: 3, arg5: 0     ) = -143220736
     7.670 ( 0.066 ms):  ... [continued]: stat()) = 47
     7.688 ( 0.011 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 53, arg5: 0   ) = 53
     7.733 ( 0.039 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 44, arg5: 0   ) = 44
     7.775 ( 0.036 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 53, arg5: 0   ) = 53
     7.876 ( 0.095 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 51, arg5: 0   ) = 51
     7.914 ( 0.031 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 55, arg5: 0   ) = 55
     7.946 ( 0.026 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 57, arg5: 0   ) = 57
     8.079 ( 0.050 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 47, arg5: 0   ) = 47
     8.124 ( 0.039 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 46, arg5: 0   ) = 46
     8.165 ( 0.035 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 53, arg5: 0   ) = 53
     8.206 ( 0.035 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 45, arg5: 0   ) = 45
     8.255 ( 0.044 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 39, arg5: 0   ) = 39
     8.299 ( 0.038 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 48, arg5: 0   ) = 48
     8.340 ( 0.035 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 49, arg5: 0   ) = 49
     8.387 ( 0.041 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 44, arg5: 0   ) = 44
     8.428 ( 0.035 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 45, arg5: 0   ) = 45
     8.477 ( 0.044 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 43, arg5: 0   ) = 43
     8.524 ( 0.041 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 48, arg5: 0   ) = 48
     8.562 ( 0.033 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 50, arg5: 0   ) = 50
     8.609 ( 0.041 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 42, arg5: 0   ) = 42
     8.647 ( 0.033 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 49, arg5: 0   ) = 49
     8.686 ( 0.032 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 52, arg5: 0   ) = 52
     8.727 ( 0.035 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 46, arg5: 0   ) = 46
     8.768 ( 0.036 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 50, arg5: 0   ) = 50
     8.813 ( 0.039 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 43, arg5: 0   ) = 43
     8.849 ( 0.030 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 55, arg5: 0   ) = 55
     8.897 ( 0.043 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 42, arg5: 0   ) = 42
     8.929 ( 0.026 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 45, arg5: 0   ) = 45
     8.960 ( 0.026 ms): stat(arg0: 1, arg1: 0, arg2: -143220736, arg3: 0, arg4: 40, arg5: 0   ) = 40
     8.976 ( 0.002 ms): lstat(arg0: 1, arg1: 0, arg2: 0, arg3: 0, arg4: 1305739264, arg5: 0   ) = 0
     8.989 ( 0.011 ms): fchmod(arg0: -143220736, arg1: 0, arg2: 4096, arg3: 0, arg4: 1305739264, arg5: 0) = 0
     8.994 ( 0.002 ms): lstat(arg0: 2, arg1: 0, arg2: 0, arg3: 0, arg4: 1305739264, arg5: 0   ) = 0

[2]
$ perf record  --call-graph dwarf  ls
Error:
The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (cycles).  
/bin/dmesg may provide additional information.
No CONFIG_PERF_EVENTS=y kernel support configured?

ls: Terminated
