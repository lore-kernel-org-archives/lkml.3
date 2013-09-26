Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3IZNqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:46:44 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60391 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3IZNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:46:39 -0400
Message-ID: <52443ABC.8020808@gmail.com>
Date: Thu, 26 Sep 2013 07:46:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v4)
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/26/13 2:58 AM, Namhyung Kim wrote:
> Hello,
>
> This is a new version of callchain improvement patchset.  I found and
> fixed bugs in the previous version.  I verified that it produced
> exactly same output before and after applying rbtree conversion patch
> (#1).  However after Frederic's new comm infrastructure patches are
> applied it'd be little different.
>
> The patches are on 'perf/callchain-v4' branch in my tree
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
>

Given recent breakage, has the patchset been run through any tests on 
older kernels that do not support sample_id_all? e.g., 2.6.34 (WRL4). 
What about tests with the other perf commands -- script to dump events, 
trace on a file with with multiple processes -- to verify no impact on 
comm output, especially multithreaded processes with named threads. I 
can certainly do those tests in time, but can't guarantee a timeframe 
and want to make sure it gets done before merging.

Thanks,
David

