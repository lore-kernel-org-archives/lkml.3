Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaLVJwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:52:41 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40150 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbaLVJwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:52:37 -0500
Subject: [PATCH trace-cmd V5 1/6] trace-cmd: Support -N option for trace-cmd
 extract
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Aaron Fabbri <aaronx.j.fabbri@intel.com>, linux-kernel@vger.kernel.org,
        Divya Vyas <edivya.vyas@gmail.com>
Date: Mon, 22 Dec 2014 12:47:43 -0500
Message-ID: <20141222174743.10068.49746.stgit@localhost.localdomain>
In-Reply-To: <20141222174736.10068.90306.stgit@localhost.localdomain>
References: <20141222174736.10068.90306.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to prohibit supporting -N command in extract
mode, since both record and extract read trace logs from ftrace
and save it.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 trace-record.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/trace-record.c b/trace-record.c
index 3e5def2..a3a07e1 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -390,6 +390,7 @@ static void stop_threads(void)
 	}
 }
 
+static void setup_network(void);
 static int create_recorder(struct buffer_instance *instance, int cpu, int extract);
 
 static void flush_threads(void)
@@ -400,6 +401,9 @@ static void flush_threads(void)
 	if (!cpu_count)
 		return;
 
+	if (host)
+		setup_network();
+
 	for (i = 0; i < cpu_count; i++) {
 		/* Extract doesn't support sub buffers yet */
 		ret = create_recorder(&top_instance, i, 1);
@@ -2987,8 +2991,8 @@ void trace_record (int argc, char **argv)
 			rt_prio = atoi(optarg);
 			break;
 		case 'N':
-			if (!record)
-				die("-N only available with record");
+			if (!record && !extract)
+				die("-N only available with record or extract");
 			if (output)
 				die("-N incompatible with -o");
 			host = optarg;


