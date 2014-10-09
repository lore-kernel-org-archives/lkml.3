Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193AbaJIPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:35:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaJIPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:35:40 -0400
Message-ID: <5436AB4A.1080900@redhat.com>
Date: Thu, 09 Oct 2014 11:35:38 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org
Subject: Lockdep warning with init_espfix_ap()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Non-fatal warning seen with latest kernel tree during kernel boot.

 WARNING: CPU: 64 PID: 0 at kernel/locking/lockdep.c:2744
lockdep_trace_alloc+0xdd/0xe0()
 DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags))
 Modules linked in:

 CPU: 64 PID: 0 Comm: swapper/64 Not tainted 3.17.0+ #10
 Hardware name: Intel Corporation BRICKLAND/BRICKLAND, BIOS
BIVTSDP1.86B.0049.R00.1403081207 03/08/2014
  0000000000000000 d27b9ea0e3821f35 ffff88084edc3ce0 ffffffff8171cbd8
  ffff88084edc3d28 ffff88084edc3d18 ffffffff8108424d 0000000000000046
  0000000000000000 00000000000000d0 0000000000000002 0000000000000000
 Call Trace:
  [<ffffffff8171cbd8>] dump_stack+0x4d/0x66
  [<ffffffff8108424d>] warn_slowpath_common+0x7d/0xa0
  [<ffffffff810842cc>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff810e3e2d>] lockdep_trace_alloc+0xdd/0xe0
  [<ffffffff811c0aaf>] __alloc_pages_nodemask+0x9f/0x4b0
  [<ffffffff81025365>] ? native_sched_clock+0x35/0xa0
  [<ffffffff810253d9>] ? sched_clock+0x9/0x10
  [<ffffffff8120981a>] alloc_page_interleave+0x3a/0x90
  [<ffffffff8120ae8d>] alloc_pages_current+0x17d/0x1f0
  [<ffffffff811bab24>] ? __get_free_pages+0x14/0x50
  [<ffffffff811bab24>] __get_free_pages+0x14/0x50
  [<ffffffff8102225d>] init_espfix_ap+0x17d/0x320
  [<ffffffff8105254e>] start_secondary+0x19e/0x350
 ---[ end trace 2b62d796aa7ae001 ]---

 Debugging ... but sorta hoping someone else may have already seen it ;)

 P.
