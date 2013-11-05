Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3KEJkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 04:40:04 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54248 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3KEJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 04:40:01 -0500
Date: Tue, 5 Nov 2013 12:37:55 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jon Stanley <jonstanley@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Subject: [libtraceevent] hrtimer_expire_entry unknown op '{'
Message-ID: <20131105093755.GB2272@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

libtraceevent reports ` unknown op '{' ' while processing hrtimer_expire_entry event

cat /sys/kernel/debug/tracing/events/timer/hrtimer_expire_entry/format

name: hrtimer_expire_entry
ID: 91
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:void * hrtimer;	offset:8;	size:8;	signed:0;
	field:s64 now;	offset:16;	size:8;	signed:1;
	field:void * function;	offset:24;	size:8;	signed:0;

print fmt: "hrtimer=%p function=%pf now=%llu", REC->hrtimer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->now }).tv64)


	-ss
