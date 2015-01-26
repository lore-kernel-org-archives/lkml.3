Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbbAZKol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:44:41 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18499 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbbAZKog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:44:36 -0500
From: Wang Nan <wangnan0@huawei.com>
To: <jolsa@redhat.com>, <jeremie.galarneau@efficios.com>,
        <rostedt@goodmis.org>, <alexmonthy@voxpopuli.im>,
        <bigeasy@linutronix.de>
CC: <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] perf: convert to ctf: support converting syscalls:* tracepoints.
Date: Mon, 26 Jan 2015 18:38:22 +0800
Message-ID: <1422268705-32084-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.54C61A8F.0017,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 35257ccc5b4c1b0f7239a412b3543e5d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Babeltrace now support bt_ctf_validate_identifier() to allow us detect
keyword confliction before real add it. I update patch 2/3 to use that
new interface. Also, I group all 3 patches I made during converting
syscalls:* tracepoints samples together for review.

Wang Nan (3):
  tools lib traceevent: add priv field to truct format_field.
  perf: convert: fix duplicate field names and avoid reserved keywords.
  perf: convert: fix signess of value.

 tools/lib/traceevent/event-parse.c |   2 +
 tools/lib/traceevent/event-parse.h |   2 +
 tools/perf/util/data-convert-bt.c  | 161 +++++++++++++++++++++++++++++++++----
 3 files changed, 149 insertions(+), 16 deletions(-)

-- 
1.8.4

