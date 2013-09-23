Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3IWBpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:45:09 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55798 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3IWBpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:45:07 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/5] perf tool: Various fixes and version 2 on clock_gettime
Date: Sun, 22 Sep 2013 19:44:55 -0600
Message-Id: <1379900700-5186-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo:

Various bug fixes hit working on the mmap write change and version 2 on the
clock_gettime beautifier. One other problem I was not able to resolve is 
with perf-trace not displaying comms when processing files. eg.,

     0.025 ( 0.000 ms): :7137/7137  ... [continued]: ioctl()) = 0
     0.045 ( 0.014 ms): :7137/7137 ioctl(fd: 14, cmd: 44672                                              ) = 0
     0.055 ( 0.008 ms): :7137/7137 ioctl(fd: 14, cmd: 44672

Other commands like perf-script display comms just fine, so it is something
about perf-trace.

David Ahern (5):
  perf trace: Handle MSG_WAITFORONE not defined
  perf tool: Explicitly add libdl dependency
  perf trace: Add mmap2 handler
  perf tool: Add default handler for mmap2 events
  perf trace: Add beautifier for clock_gettime's clk_id argument - v2

 tools/perf/builtin-trace.c |   11 +++++++++++
 tools/perf/config/Makefile |    2 +-
 tools/perf/util/session.c  |    2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

-- 
1.7.10.1

