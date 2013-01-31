Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463Ab3AaQZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:25:57 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:57250 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3AaQZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:25:54 -0500
Message-ID: <510A9B0D.6000503@gmail.com>
Date: Thu, 31 Jan 2013 09:25:49 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: chenggang.qin@gmail.com
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chenggang Qin <chenggang.qcg@alibaba-inc.com>
Subject: Re: [PATCH] perf script: Add a python script to statistic direct
 io behavior
References: <y> <510a34c6.c750420a.037e.74c6@mx.google.com>
In-Reply-To: <510a34c6.c750420a.037e.74c6@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 1/31/13 2:08 AM, chenggang.qin@gmail.com wrote:
> From: chenggang.qin@gmail.com
>
> This patch depends on a prev patch: https://lkml.org/lkml/2013/1/29/47
>
> If the engineers want to analyze the direct io behavior of some applications
> without source code, perf tools with some appropriate tracepoints events in the
> VFS subsystem are excellent choice.
>
> Many database systems use their own page cache subsystems and use the direct IO
> to access the disks. Sometimes, the system engineers need to know the misses rate
> of the database system's page cache. This requirements can be satisfied by recording
> the database's file access behavior through the way of direct IO. So, we use 2
> tracepoint events to record the system wide's direct IO behavior. The 2 tracepoint
> events are:
> 1) vfs:direct_io_read
> 2) vfs:direct_io_write
> they were introduced by the patch: https://lkml.org/lkml/2013/1/29/47
> The script direct-io.py are introduced by this patch can record the 2 tracepoint
> events, analyse the sample data, and give a concise report.

What does this option provide that the I/O accounting with taskstats 
(e.g., iotop) does not provide?

David

