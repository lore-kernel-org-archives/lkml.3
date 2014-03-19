Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965129AbaCSOd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:33:59 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:37215 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933874AbaCSOd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:33:58 -0400
Date: Wed, 19 Mar 2014 10:33:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC PATCH v5 1/3] Tracepoint cleanup: remove unused API
 functions
Message-ID: <20140319103355.5fb39ef6@gandalf.local.home>
In-Reply-To: <1395151546-20445-2-git-send-email-mathieu.desnoyers@efficios.com>
References: <1395151546-20445-1-git-send-email-mathieu.desnoyers@efficios.com>
	<1395151546-20445-2-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014 10:05:44 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> After the following commit:
> 
> commit b75ef8b44b1cb95f5a26484b0e2fe37a63b12b44
> Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Date:   Wed Aug 10 15:18:39 2011 -0400
> 
>     Tracepoint: Dissociate from module mutex
> 
> The following functions became unnecessary:
> 
> - tracepoint_probe_register_noupdate,
> - tracepoint_probe_unregister_noupdate,
> - tracepoint_probe_update_all.
> 
> In fact, none of the in-kernel tracers, nor LTTng, nor SystemTAP use
> them. Remove those.
> 
> Moreover, the functions:
> 
> - tracepoint_iter_start,
> - tracepoint_iter_next,
> - tracepoint_iter_stop,
> - tracepoint_iter_reset.
> 
> are unused by in-kernel tracers, LTTng and SystemTAP. Remove those too.
> 

New warning caused by this patch:

tracepoint.c:446:13: warning: 'tracepoint_add_old_probes' defined but not used [-Wunused-function]
    struct tp_probes, probes[0]);

--  Steve
