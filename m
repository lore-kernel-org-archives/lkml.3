Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaH0Iup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:50:45 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:42577 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaH0Iun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:50:43 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: tracing: horrible read performance on host with many CPUs 
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
CC: rostedt@goodmis.org
Date: Wed, 27 Aug 2014 12:50:38 +0400
Message-ID: <8738ci9uzl.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have tried to use tracing on host with 32cpus, but it is appeared
that performance is horrible.
dd if=/sys/kernel/debug/tracing/trace_pipe of=tmpfs/t3.log  bs=1M 
0+21268 records in
0+21267 records out
85701248 bytes (86 MB) copied, 26.1424 s, 3.3 MB/s
0+25706 records in
0+25705 records out
103600749 bytes (104 MB) copied, 31.6595 s, 3.3 MB/s
0+59204 records in
0+59203 records out
238746128 bytes (239 MB) copied, 73.4347 s, 3.3 MB/s
Since I've collected ~3Gb of data this takes a lot of time to
simply copy from kernel to tmpfs. 

AFAIU this happen due to sub-optimal sorting procedure __find_next_entry
Each time it walks each cpu and pick the one with smallest timestamp.
This can be optimized simply by fetching N-entries at the time. Are
there any plans to implement that?

BTW:What is the most convenient way fetch big data from traces?
One of possible way is to dump per-cpu traces(20Mb/s in my case) and
then merge files according to timestamp


