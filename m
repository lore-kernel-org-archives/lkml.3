Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab3DSQ2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:28:32 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:56309 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab3DSQ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:28:31 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com, rostedt@goodmis.org
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v4 0/7] f2fs: Add tracepoints support in f2fs filesystem
Date: Sat, 20 Apr 2013 01:28:11 +0900
Message-Id: <1366388891-18778-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Add tracepoints in f2fs filesystem for tracing the filesystem
operations for information/debugging purpose if needed. All the
tracepoints are clubbed with respect to functionalities.

Change Log:
v4: Modified the tracepoints as per the review comments of
Jaegeuk Kim. Following tracepoints are added newly:

trace_f2fs_truncate_blocks_enter
trace_f2fs_truncate_blocks_exit
trace_f2fs_truncate_inode_blocks_enter 
trace_f2fs_truncate_inode_blocks_exit
trace_f2fs_truncate_node
trace_f2fs_submit_write_page
trace_f2fs_do_submit_bio
trace_f2fs_write_checkpoint

While some of the tracepoints are modified to add new 
parameters.

v3: Introduced TRACE_EVENT_CONDITION() macro for checking the
condition page->mapping inside the trace point function call as
per Steve's review comment for the patch

v2: Added DECLARE_EVENT_CLASS() macro for combining the similar
type of trace function calls which has same type of arguments.

v1: Introduced the tracepoint functions in f2fs filesystem.

Namjae Jeon (7):
  f2fs: add tracepoints for sync & Inode operations
  f2fs: add tracepoints for truncate operation
  f2fs: add tracepoint for tracing the page i/o operations
  f2fs: add tracepoints for GC threads
  f2fs: add tracepoints to debug the block allocation & fallocate
  f2fs: add tracepoints for write page operations
  f2fs: add tracepoints to debug checkpoint request
-- 
1.7.9.5

