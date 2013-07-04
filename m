Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552Ab3GDG4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 02:56:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:58108 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3GDG4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 02:56:48 -0400
Message-ID: <51D51BDA.7060900@huawei.com>
Date: Thu, 4 Jul 2013 14:53:14 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v5] tracing/uprobes: Support multibuffer and soft-mode
 disabling
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is fifth version of uprobes-based dynamic events
multibuffer and soft-mode disabling support work.

v4 -> v5 (suggested by Oleg and Masami):
- code simply in probe_event_enable
- use list_del to replace list_del_rcu in probe_event_enable
- don't remove is_trace_uprobe_enabled() checking in probe_event_disable
  (I will check this later to figure out is it safe to remove that checking)

v3 -> v4:
- use "bool enabled = is_trace_uprobe_enabled(tu);", suggested by Oleg.
- use list_add_tail_rcu instead of list_add_rcu, suggested by Masami.
- fix the error handling in probe_event_enable, found by Srikar.

v3:
- separate soft-mode disabling patch from multibuffer support patch.
- fix some comments
- coding style trivial
- fix flags race in probe_event_disable

zhangwei(Jovi) (2):
  tracing/uprobes: Support ftrace_event_file base multibuffer
  tracing/uprobes: Support soft-mode disabling

 kernel/trace/trace_uprobe.c |  122 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 103 insertions(+), 19 deletions(-)

-- 
1.7.9.7


