Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaCMOsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:48:01 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:41627 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaCMOr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:47:59 -0400
MIME-Version: 1.0
X-Originating-IP: [67.83.169.196]
In-Reply-To: <20140313143456.GA2396@ghostprotocols.net>
References: <1394664051-6037-1-git-send-email-patrick@parcs.ath.cx>
	<20140313143456.GA2396@ghostprotocols.net>
Date: Thu, 13 Mar 2014 10:47:58 -0400
Message-ID: <CA+C-WL_2DrXFL6eMoyt2miwA53rZN=M0bNrirsra3oup-JdosA@mail.gmail.com>
Subject: Re: [PATCH] perf bench: Fix NULL pointer dereference in "perf bench all"
From: Patrick Palka <patrick@parcs.ath.cx>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 10:34 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Wed, Mar 12, 2014 at 06:40:51PM -0400, Patrick Palka escreveu:
>> for_each_bench() must check that the "benchmarks" field of a collection
>> is not NULL before dereferencing it because the "all" collection in
>> particular has a NULL "benchmarks" field (signifying that it has no
>> benchmarks to iterate over).
>>
>> This fixes a NULL pointer dereference when running "perf bench all".
>
> Can you please mention against which tree you're fixing things? I just
> tried to reproduce it here on perf/urgent and this problem is not
> reproducible by simply running:
>
>   perf bench all
>
> So now I'm going to try on perf/core, tip/master, etc :-\

I'm fixing this on top on Linus' tree, which is currently on ac9dc67b7.

Without the patch, the output of "./perf bench all" looks like:

# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.623 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 32.199 [sec]

      32.199419 usecs/op
          31056 ops/sec

# Running mem/memcpy benchmark...
# Copying 1MB Bytes ...

       1.247206 GB/Sec
       1.268263 GB/Sec (with prefault)

# Running mem/memset benchmark...
# Copying 1MB Bytes ...

       1.429813 GB/Sec
       8.418642 GB/Sec (with prefault)

zsh: segmentation fault  ./perf bench all


Patrick
