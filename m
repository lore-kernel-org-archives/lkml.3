Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934909AbaGPSc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:32:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53186 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934637AbaGPScW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:32:22 -0400
Date: Wed, 16 Jul 2014 14:32:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] tracing: change apply_subsystem_event_filter()
 paths to check file->system == dir
Message-ID: <20140716143219.4fa2b72e@gandalf.local.home>
In-Reply-To: <20140715184829.GA20516@redhat.com>
References: <20140715184753.GA20470@redhat.com>
	<20140715184829.GA20516@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 20:48:29 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> filter_free_subsystem_preds(), filter_free_subsystem_filters() and
> replace_system_preds() can simply check file->system->subsystem and
> avoid strcmp(call->class->system).
> 
> Better yet, we can pass "struct ftrace_subsystem_dir *dir" instead of
> event_subsystem and just check file->system == dir.
> 
> Thanks to Namhyung Kim who pointed out that replace_system_preds() can
> be changed too.

What? No thanks to me for suggesting the file->system == dir idea?

/me pouts like a baby

-- Steve

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
