Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3JQPyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 11:54:14 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:65367 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab3JQPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 11:54:13 -0400
Message-ID: <52600821.9010304@gmail.com>
Date: Thu, 17 Oct 2013 09:54:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
CC: mingo@elte.hu, peterz@infradead.org, ak@linux.intel.com, jolsa@redhat.com,
        acme@redhat.com, hughd@google.com
Subject: Re: [PATCH v2] perf: disable PERF_RECORD_MMAP2 support
References: <20131017142839.GA8482@quad>
In-Reply-To: <20131017142839.GA8482@quad>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/13 8:28 AM, Stephane Eranian wrote:
>
> For now, we disable the extended MMAP record support (MMAP2).
> We have identified cases where it would not report the correct
> mapping information, clone(VM_CLONE) but with separate pids.
> We will revisit the support once we find a solution for this case.
>
> The patch changes the kernel to return EINVAL if attr->mmap2
> is set. The patch also modifies the perf tool to use regular PERF_RECORD_MMAP
> for synthetic events and it also prevents the tool from requesting attr->mmap2
> mode because the kernel would reject it.
>
> The support will be revisited once the kenrel interface is updated.

Why not disable mmap2 as well:

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0ce9febf1ba0..289f34dbe970 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -678,7 +678,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
         attr->sample_type   |= PERF_SAMPLE_WEIGHT;

     attr->mmap  = track;
-   attr->mmap2 = track && !perf_missing_features.mmap2;
+   /* attr->mmap2 = track && !perf_missing_features.mmap2; */
     attr->comm  = track;


David
