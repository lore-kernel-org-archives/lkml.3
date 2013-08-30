Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3H3OD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 10:03:28 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:64225 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab3H3OD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 10:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <20130822105109.GI31370@twins.programming.kicks-ass.net>
References: <1377079825-19057-1-git-send-email-eranian@google.com>
	<1377079825-19057-3-git-send-email-eranian@google.com>
	<20130822105109.GI31370@twins.programming.kicks-ass.net>
Date: Fri, 30 Aug 2013 16:03:26 +0200
Message-ID: <CABPqkBQUqNX4W8UVzbJ6sB=JVbMY=ZJgYbRLRHX3DnvCz6SOsw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I realized I have forgotten to patch builtin-inject.c to repipe mmap2 records.
Will resubmit V3.


On Thu, Aug 22, 2013 at 12:51 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Aug 21, 2013 at 12:10:25PM +0200, Stephane Eranian wrote:
>> This patch adds support for the new PERF_RECORD_MMAP2
>> record type exposed by the kernel. This is an extended
>> PERF_RECORD_MMAP record. It adds for each file-backed
>> mapping the device major, minor number and the inode
>> number and generation. This triplet uniquely identifies
>> the source of a file-backed mapping. It can be used to
>> detect identical virtual mappings between processes, for
>> instance.
>>
>> The patch will prefer MMAP2 over MMAP.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Acme, ACK?
