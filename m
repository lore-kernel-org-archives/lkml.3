Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab3LIPtd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:49:33 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53617 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587Ab3LIPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:49:32 -0500
Message-ID: <52A5E682.3050609@gmail.com>
Date: Mon, 09 Dec 2013 23:49:22 +0800
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: ktap@freelists.org, linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] ktap 0.4 released
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear,

I'm pleased to announce that ktap released v0.4, the archive is 
available at:

         https://github.com/ktap/ktap/archive/v0.4.tar.gz

(Previous v0.3 release note is at: http://lwn.net/Articles/572052/)

= what's ktap?

    A New Script-based Dynamic Tracing Tool For Linux

    ktap have different design principles from Linux mainstream dynamic
    tracing language in that it's based on bytecode, so it doesn't
    depend upon GCC, doesn't require compiling kernel module for each
    script, safe to use in production environment, fulfilling the embedded
    ecosystem's tracing needs.

    ktap is released as GPL license.

    More information can be found at ktap/doc directory.

    Homepage: www.ktap.org

= Highlight features

    - support tracepoints, k(ret)probe, u(ret)probe, timer, function
      tracing, sdt, etc.
    - support x86, x86-64, powerpc, arm.
    - support kernel 3.1 and newer versions, include Linux mainline.
    - support FFI (call kernel function from script)

= Highlight changes from v0.3

    * kernel symbol read (syntax: `symbol_name`)

    * parse symbol on uprobe (need libelf link)
	trace probe:/lib64/libc.so.6:malloc {}
	trace probe:/lib64/libc.so.6:malloc%return {}
	trace probe:/lib64/libc.so.6:* {} # trace all function in glibc

    * support static marker(SDT)
	trace sdt:/lib64/libc.so.6:setjmp {}
	trace sdt:/lib64/libc.so.6:* {} # trace all sdt in glibc	

    * support kprobe wildcard
	trace probe:vfs* {}

    * support run multiple ktap instances concurrently

    * add command option for list available events and symbols
	-le [glob]     : list pre-defined events in system
	-lf DSO        : list available functions from DSO
	-lm DSO        : list available sdt notes from DSO

    * better annotation for output of argname

    * basic FFI support (depend on CONFIG_KTAP_FFI)
	FFI will allow call kernel function from ktap script

	cdef [[ int printk(char *fmt, ...); ]]
	C.printk("this is ffi printk from ktap\n")

	(currently only support basic C types, structure support is ongoing)

    * New sample scripts
	userspace/malloc_size_hist.kp
	userspace/malloc_free.kp
	userspace/gcc_unwind.kp
	userspace/glibc_sdt.kp        #trace all static marker in glibc
	userspace/glibc_trace.kp      #trace all functions in glibc
	userspace/glibc_func_hist.kp  #show glibc functions in histogram
	syscalls/syslatl.kp           #syscall latency linear aggregation
	syscalls/syslist.kp           #syscall latency as a list with counts
	syscalls/opensnoop.kp         #trace open() syscalls and print basic 
details
         ffi/ffi_kmalloc.kp
	ffi/printk.kp
	ffi/sched_clock.kp

    * use amalgamation build as default
	x86_64 build: ktap binary size is 98K, ktapvm.ko size is 983K

    * Big cleanups and lots of bugfix

= Source code

    Please get latest code from:
    https://github.com/ktap/ktap.git

= Building & Running

    [root@jovi]# git clone https://github.com/ktap/ktap.git

    [root@jovi]# cd ktap
    [root@jovi]# make    #generate ktapvm kernel module and ktap binary

    [root@jovi]# insmod ./ktapvm.ko
    [root@jovi]# ./ktap helloworld.kp

= Samples scripts

    There have many samples scripts in README and ktap/samples/.

    # ls samples/
    ansi   ffi   helloworld.kp  io   profiling  syscalls     userspace
    basic  game  interrupt      mem  schedule   tracepoints

    Totally 40 sample scripts.

= Documentation

    Documentation is in ktap/doc/, also can read from website:
    http://www.ktap.org/doc/tutorial.html

= Mailing list

    ktap@freelists.org
    You can subscribe ktap mailing list at link:
    http://www.freelists.org/list/ktap

= Feedback

    ktap is still under active development, so any feedback, bug
    reports, patches, feature requests, as always, is welcome.

= Contributors for this release

    Big special thanks for:

    - Qingping Hou and Yicheng Qin
	Qingping and Yicheng contributed the FFI feature, which
	make ktap extremely cool and interesting. ktap FFI would
	never come out so fast without contribution by them.

    - Brendan Gregg
	Brendan created some really useful ktap samples for us,
         and gave many value comments and feature request for ktap.
	There also have a ktap example page:
		http://www.brendangregg.com/ktap.html

    - Azat Khuzhin
	Azat contributed the userspace symbol resolve functionality,
	that make ktap be useful for userspace binary tracing. 	


    Thanks all contributors for this release.

    Anders Darander, Azat Khuzhin, Jovi Zhangwei, Qingping Hou,
    Yicheng Qin.


Jovi

