Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaISJw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:52:56 -0400
Received: from mx5-phx2.redhat.com ([209.132.183.37]:56870 "EHLO
	mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaISJwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:52:55 -0400
Date: Fri, 19 Sep 2014 05:52:25 -0400 (EDT)
From: CAI Qian <caiqian@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
        kexec <kexec@lists.infradead.org>,
        kexec kdump redhat mailing list 
	<kexec-kdump-list@redhat.com>,
        crash-utility <crash-utility@redhat.com>
Message-ID: <293476264.25264480.1411120345360.JavaMail.zimbra@redhat.com>
In-Reply-To: <145412866.25258463.1411119061796.JavaMail.zimbra@redhat.com>
Subject: [RFC] autokdump - automated kdump testsuite
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF17 (Linux)/8.0.6_GA_5922)
Thread-Topic: autokdump - automated kdump testsuite
Thread-Index: RbAmCGvNHKC2ziK50iQqdLu2RkxxQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I plan to release an automated kdump testsuite that will be
focus on testing kernel and the crash utility. It should work
for all major distros since it will use none of distro-specific
stuff, and also support different arches including x86, ARM,
PPC64 and s390x.

It does the following:
1) check if there is a memory reserved for kdump. If not,
   reserve the memory and reboot the system.
2) once the system is back, load kexec on panic and
   prepare a separate initramfs that including needed
   modules to load a local filesystem and necessary utilities
   in order to analyse /proc/vmcore in the 2nd kernel.
3) trigger the system crash using methods like sysrq-c, NMI,
   and panic_on_hung_task etc.
4) in the 2nd kernel, mount a filesystem and use the crash
   utility to analyse /proc/vmcore. Then, gather the analyse
   logs, serial console output, dmesg etc into the filesystem.
5) reboot back into the 1st kernel.

implementation:
It will setup a daemon to handle reboots.

plan:
I might also to test the makedumpfile all together later.
   CAI Qian
