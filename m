Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3BAB4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 20:56:47 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64437 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3BAB4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 20:56:44 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-e4-510b20daf096
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: chenggang.qin@gmail.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Subject: Re: [PATCH] perf script: Add a python script to statistic direct io behavior
References: <510a34c6.c750420a.037e.74c6@mx.google.com>
	<510A9B0D.6000503@gmail.com>
Date: Fri, 01 Feb 2013 10:56:42 +0900
In-Reply-To: <510A9B0D.6000503@gmail.com> (David Ahern's message of "Thu, 31
	Jan 2013 09:25:49 -0700")
Message-ID: <87halwu78l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 31 Jan 2013 09:25:49 -0700, David Ahern wrote:
> Hi
>
> On 1/31/13 2:08 AM, chenggang.qin@gmail.com wrote:
>> From: chenggang.qin@gmail.com
>>
>> This patch depends on a prev patch: https://lkml.org/lkml/2013/1/29/47
>>
>> If the engineers want to analyze the direct io behavior of some applications
>> without source code, perf tools with some appropriate tracepoints events in the
>> VFS subsystem are excellent choice.
>>
>> Many database systems use their own page cache subsystems and use the direct IO
>> to access the disks. Sometimes, the system engineers need to know the misses rate
>> of the database system's page cache. This requirements can be satisfied by recording
>> the database's file access behavior through the way of direct IO. So, we use 2
>> tracepoint events to record the system wide's direct IO behavior. The 2 tracepoint
>> events are:
>> 1) vfs:direct_io_read
>> 2) vfs:direct_io_write
>> they were introduced by the patch: https://lkml.org/lkml/2013/1/29/47
>> The script direct-io.py are introduced by this patch can record the 2 tracepoint
>> events, analyse the sample data, and give a concise report.
>
> What does this option provide that the I/O accounting with taskstats
> (e.g., iotop) does not provide?

Maybe it's better to put this into 'blktrace' tool once the TPs are
accepted.

Thanks,
Namhyung

