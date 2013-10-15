Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190Ab3JOQQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:16:49 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41546 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab3JOQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:16:48 -0400
Message-ID: <525D6A6C.3090208@gmail.com>
Date: Tue, 15 Oct 2013 10:16:44 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/3] perf record: mmap output file
References: <1381289214-24885-1-git-send-email-dsahern@gmail.com> <1381289214-24885-4-git-send-email-dsahern@gmail.com> <20131009055957.GA7664@gmail.com> <525D4B5F.4090005@gmail.com> <20131015143245.GB9828@ghostprotocols.net> <20131015143819.GM10651@twins.programming.kicks-ass.net> <20131015152747.GA15979@gmail.com> <525D5FA1.7060404@gmail.com> <20131015160646.GC16003@gmail.com>
In-Reply-To: <20131015160646.GC16003@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 10:06 AM, Ingo Molnar wrote:
> splice() is very fast and should be able to process a lot of pages in one
> go, so the feedback loop should be pretty weak. mmap() triggers kernel
> code as well, every time we run out of the 64 MB window we got to remap
> it, right?


Yes, 1 mmap, 1 munmap for every 64MB. Compare to the write() case which 
calls write() for each mmap each time through the mmap_read loop.

I am conjecturing that splice would follow the write model in the sense 
of a ring buffer has N bytes, call splice to copy the data from the ring 
buffer to the file. So, splice saves on the memcpy, but not the syscalls.

David
