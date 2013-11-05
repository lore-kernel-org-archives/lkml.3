Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab3KENP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:15:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:42911 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755084Ab3KENPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:15:24 -0500
Date: Tue, 5 Nov 2013 08:15:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jon Stanley <jonstanley@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [libtraceevent] hrtimer_expire_entry unknown op '{'
Message-ID: <20131105081522.1c8e2012@gandalf.local.home>
In-Reply-To: <20131105093755.GB2272@swordfish.minsk.epam.com>
References: <20131105093755.GB2272@swordfish.minsk.epam.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 12:37:55 +0300
Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> Hello,
> 
> libtraceevent reports ` unknown op '{' ' while processing hrtimer_expire_entry event

Yes, we need to port the plugin code from trace-cmd to handle this and
other cases. It's a known issue.

-- Steve

> 
> cat /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format
> 
> name: hrtimer_expire_entry
> ID: 91
> format:
> 	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
> 	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
> 	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
> 	field:int common_pid;	offset:4;	size:4;	signed:1;
> 
> 	field:void * hrtimer;	offset:8;	size:8;	signed:0;
> 	field:s64 now;	offset:16;	size:8;	signed:1;
> 	field:void * function;	offset:24;	size:8;	signed:0;
> 
> print fmt: "hrtimer=%p function=%pf now=%llu", REC->hrtimer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->now }).tv64)
> 
> 
> 	-ss

