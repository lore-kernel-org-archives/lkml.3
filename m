Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3KFSlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 13:41:45 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35479 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab3KFSlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:41:44 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, jolsa@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH 0/4] perf record: Cleanups and mmap-based output
Date: Wed,  6 Nov 2013 11:41:33 -0700
Message-Id: <1383763297-27066-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know Jiri is working on cleanups of the output file, but had this
sitting around for a couple of weeks now. Might as well push it out
for the next baseline. The cleanups of perf-record can be taken
independently.

Ingo: I took a look at leveraging the copy_user_nocache and was not able
      to get it to work. I won't have time to come back to it for a while.
      Given that the mmap output already improves perf-trace a lot I would
      like to get the option into 3.13 and come back to the optimization
      later.

David Ahern (4):
  perf record: Refactor feature handling into a separate function
  perf record: Remove advance_output function
  perf record: Remove post_processing_offset variable
  perf record: mmap output file - v3

 tools/perf/Documentation/perf-record.txt |   5 ++
 tools/perf/builtin-record.c              | 137 ++++++++++++++++++++++++++-----
 2 files changed, 123 insertions(+), 19 deletions(-)

-- 
1.8.3.4 (Apple Git-47)

