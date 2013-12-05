Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab3LEClw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:41:52 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48023 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3LEClv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:41:51 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf trace fixes
Date: Wed,  4 Dec 2013 19:41:38 -0700
Message-Id: <1386211302-31303-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo:

As I mentioned on IRC perf-trace fails on older kernels -- like RHEL6. This
set of patches makes it at least usable - though still some problems I am
hoping you can fix.

Build perf with these patches and run:

  perf trace -- dd if=/dev/zero of=/tmp/zero bs=4096 count=16

you see something like this which is just wrong:

  3.684 ( 0.007 ms): write(buf: 2, count: 140737077958816  ) = 27

there is no fd (should be 1 for the write) and all the values are wrong.
Perhaps it is an artifact of the older way of doing system call tracing, but
I see something goofy with the 3.12 kernel as well:
  5.633 ( 0.004 ms): write(fd: 2, buf: 0x7fff9177fee0, count: 24 ) = 24

According to strace that should be a return of 4096.

David Ahern (4):
  perf trace: Add support for syscalls vs raw_syscalls
  perf trace: Fix crash on RHEL6
  perf trace: Fix summary percentage when processing files
  perf trace: Add option to specify machine type

 tools/perf/builtin-trace.c | 48 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

-- 
1.8.3.4 (Apple Git-47)

