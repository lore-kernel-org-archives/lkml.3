Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3FYP4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:56:41 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63980 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3FYP4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:56:38 -0400
Message-ID: <51C9BDB2.7060905@gmail.com>
Date: Tue, 25 Jun 2013 09:56:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1372079772-20803-13-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/24/13 7:16 AM, Adrian Hunter wrote:
> Sample types need not be identical to determine
> the sample id from the event.  Only the position
> of the sample id needs to be the same.
>
> Compatible sample types are ones in which the bits
> defined by PERF_COMPAT_MASK are the same.
> 'perf_evlist__config()' forces sample types to be
> compatible on that basis.

Something is still missing to support different sample_types for events. 
Consider the case (S/W event + tracepoint):
   perf record -e cs -c1 -e sched:sched_switch -a -- sleep 1
   perf script

This patch addresses the sample_type mismatch error message, but I get 
no event samples in the output. Besides the usual header I get:

   No trace sample to read. Did you call 'perf record -R'?

It's a 16-cpu box with 5 VMs running. I know there should be at least a 
few samples in 1 second.

Stephane: are you looking at allowing sample_types per event?

David
