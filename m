Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968Ab3JPB6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:58:39 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:54522 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143Ab3JPB6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:58:38 -0400
Message-ID: <525DF2CA.1060102@gmail.com>
Date: Tue, 15 Oct 2013 19:58:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf record: mmap output file - v2
References: <1381805731-10398-1-git-send-email-dsahern@gmail.com>	<87txgj9eir.fsf@sejong.aot.lge.com> <525D44B9.7060901@gmail.com> <87haci9e31.fsf@sejong.aot.lge.com>
In-Reply-To: <87haci9e31.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/13 7:52 PM, Namhyung Kim wrote:
> Aha, okay.  So it mostly matters to syscall tracing, right?  For a
> normal record session, it seems that the effect is not that large:

Yes, that's in the description "When recording raw_syscalls for the 
entire system"

There is a small benefit to all record sessions -- mmap+memcpy has less 
overhead than write(). I still need to look at Ingo's suggestion to use 
non-temporal stores which might reduce the overhead of the memcpy.

Try a workload that generates a HUGE data file -- say a full kernel 
build (e.g., perf record -g -- make O=/tmp/kbuild -j 16). You should see 
a much larger benefit from the mmap route. Be sure to use your callchain 
enhancements to look at that 1+G file. ;-)

David
