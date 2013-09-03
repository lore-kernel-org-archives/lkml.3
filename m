Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3ICPM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:12:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab3ICPMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:12:55 -0400
Subject: Re: [RFC PATCH 0/2] Perf support to SDT markers
From: Mark Wielaard <mjw@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Hemant <hkshaw@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, mingo@redhat.com,
        anton@redhat.com, systemtap@sourceware.org
In-Reply-To: <20130903142159.GA27740@gmail.com>
References: <20130903072944.4793.93584.stgit@hemant-fedora>
	 <20130903082503.GA20732@gmail.com> <5225A937.2050507@hitachi.com>
	 <5225E2C5.3080001@linux.vnet.ibm.com>  <20130903142159.GA27740@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Sep 2013 17:11:02 +0200
Message-ID: <1378221062.3948.86.camel@bordewijk.wildebeest.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 16:21 +0200, Ingo Molnar wrote:
> * Hemant <hkshaw@linux.vnet.ibm.com> wrote:
> 
> > Here is an overview and a high-level-description:
> 
> Thanks, looks like a pretty useful feature - especially if SDT probes are 
> already widely present in various server binaries on a typical Linux 
> distro (are they?).

They are becoming fairly common, especially now that glibc has adopted
them. And they were designed to be source compatible with DTRACE markers
[*]. So any program that has probes for dtrace can just be recompiled on
with sys/sdt.h to get them.

My Fedora 19 box already has a couple of applications and libraries
installed that support them:

$ stap -l 'process("/usr/*/*").mark("*")' | cut -f2 -d\" | uniq -c
      9 /usr/bin/Xorg
      9 /usr/bin/Xvfb
      4 /usr/bin/c++
      4 /usr/bin/cpp
      4 /usr/bin/g++
      4 /usr/bin/gcc
      1 /usr/bin/gcov
      4 /usr/bin/gfortran
      3 /usr/bin/qemu-ga
     75 /usr/bin/qemu-img
     75 /usr/bin/qemu-io
     75 /usr/bin/qemu-nbd
    575 /usr/bin/qemu-system-i386
    575 /usr/bin/qemu-system-x86_64
     29 /usr/bin/stap
      3 /usr/bin/stapdyn
      3 /usr/bin/virtfs-proxy-helper
      4 /usr/bin/x86_64-redhat-linux-c++
      4 /usr/bin/x86_64-redhat-linux-g++
      4 /usr/bin/x86_64-redhat-linux-gcc
     13 /usr/lib/ld-2.17.so
      1 /usr/lib/libanl-2.17.so
      5 /usr/lib/libc-2.17.so
      1 /usr/lib/libgcc_s-4.8.1-20130603.so.1
     22 /usr/lib/libpthread-2.17.so
      1 /usr/lib/librt-2.17.so
      3 /usr/lib/libstdc++.so.6.0.18
     13 /usr/lib64/ld-2.17.so
      1 /usr/lib64/libanl-2.17.so
      5 /usr/lib64/libc-2.17.so
      3 /usr/lib64/libcacard.so.0.0.0
      1 /usr/lib64/libgcc_s-4.8.1-20130603.so.1
      6 /usr/lib64/libglib-2.0.so.0.3600.3
     11 /usr/lib64/libgobject-2.0.so.0.3600.3
      4 /usr/lib64/libm-2.17.so
     23 /usr/lib64/libpthread-2.17.so
      2 /usr/lib64/libpython2.7.so.1.0
      2 /usr/lib64/libpython3.3m.so.1.0
      1 /usr/lib64/librt-2.17.so
      3 /usr/lib64/libstdc++.so.6.0.18
     15 /usr/lib64/libtcl8.5.so
     41 /usr/lib64/libvirt.so.0.1000.5
     37 /usr/libexec/libvirt_lxc
     12 /usr/sbin/ldconfig
      3 /usr/sbin/libvirtd
     34 /usr/sbin/prelink
     12 /usr/sbin/sln
     37 /usr/sbin/virtlockd

[*] http://tromey.com/blog/?p=687

