Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3EUD5s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 23:57:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19656 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3EUD5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 23:57:46 -0400
Message-ID: <519AF05E.1050808@huawei.com>
Date: Tue, 21 May 2013 11:56:14 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] ktap 0.1 released
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear,

I'm pleased to announce that ktap release v0.1, this is the first official
release of ktap project, it is expected that this release is not fully
functional or very stable and we welcome bug reports and fixes for the issues.

= what's ktap?

   A New Scripting Dynamic Tracing Tool For Linux

   KTAP is a new scripting dynamic tracing tool for Linux, it uses a
   scripting language and lets users trace the Linux kernel dynamically.
   KTAP is designed to give operational insights with interoperability
   that allow users to tune, troubleshoot and extend kernel and application.

   KTAP have different design principles from Linux mainstream dynamic tracing
   language in that it's based on bytecode, so it doesn't depend upon GCC,
   doesn't require compiling a kernel module, safe to use in production
   environment, fulfilling the embedd ecosystem's tracing needs.

   KTAP also is designed for enabling great interoperability with Linux kernel,
   it gives user the power to modify and extend the system, and let users
   explore the system in an easy way.

   KTAP is released as GPL license.

   More information can be found at ktap/doc directory.

= Features

   Because this is the first release, so there wouldn't include too much features,
   just contain several basic features about tracing,  here are the summary:

   1) support x86-32 and x86-64 (other arch is not tested yet)
   2) support tracepoints, syscalls, kprobes, kretprobes
   3) timer
   4) dumpstack
   5) many built-in functions and library functions in there

   There have many features on the todo list, so it will support more
   features in future, and be more stable than this release.

= Planned Changes

   we are planning to enable more kernel ineroperability into ktap, implement more
   sample scripts, and performance boost.

= Code

   Please download code from:
   https://github.com/ktap/ktap.git

= Building & Running

   [root@jovi]# cd linux/kernel/trace/
   [root@jovi]# git clone https://github.com/ktap/ktap.git

   [root@jovi]# cd linux/kernel/trace/ktap
   [root@jovi]# make       #generate ktapvm kernel module
   [root@jovi]# make ktap  #generate userspace ktap tool

   [root@jovi]# insmod ./ktapvm.ko
   [root@jovi]# ./ktap scripts/syscalls.kp


= Simple syscall tracing example

        function eventfun (e) {
                printf("%d %d\t%s\t%s", cpu(), pid(), execname(), e.tostring())
        }

        kdebug.probe("tp:syscalls", eventfun)

        kdebug.probe_end(function () {
                printf("probe end\n")
        })


= Examples/Documentation

   Example is in ktap/scripts/
   Documentation is in ktap/doc/

= Mailing list

   ktap@freelists.org
   You can subscribe KTAP mailing list at link: http://www.freelists.org/list/ktap

= Contribution

   KTAP is still under active development, so contribution is welcome.
   You are encouraged to report bugs, provide feedback, send feature request, or hack on it.

.jovi


