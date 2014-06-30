Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbaF3SBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 14:01:20 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:9192 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754731AbaF3SBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 14:01:19 -0400
Date: Mon, 30 Jun 2014 14:01:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] tracing/uprobes: Fix the usage of
 uprobe_buffer_enable() in probe_event_enable()
Message-ID: <20140630140117.39a505ee@gandalf.local.home>
In-Reply-To: <20140630175025.GA21918@redhat.com>
References: <20140627170116.GA18298@redhat.com>
	<20140627170146.GA18332@redhat.com>
	<20140630170409.GD5619@linux.vnet.ibm.com>
	<20140630175025.GA21918@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014 19:50:25 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

 
> Well, I do not really mind. But to me it looks more consistent this way,
> if-something-fail-goto-err_label.
> 
> IOW, I think that the code should either not use err-labels, or always
> use them like above.

Ah I missed the other error labels. Yeah, we should keep the patch as
is to be consistent (also it means I don't need to restart a test
that's already been running for hours).

-- Steve

> 
> Besides, perhaps we will add "if (file) uprobe_apply()" after _register()
> to mix perf/ftrace, then we will need to change this "if (!ret)" code again.
> 
> Oleg.

