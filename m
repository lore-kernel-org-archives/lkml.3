Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab3JROZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:25:19 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36509 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab3JROZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:25:17 -0400
Message-ID: <526144C9.4080004@gmail.com>
Date: Fri, 18 Oct 2013 08:25:13 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 19/19] perf tools: allow non-matching sample types
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com> <1382099356-4918-20-git-send-email-adrian.hunter@intel.com>
In-Reply-To: <1382099356-4918-20-git-send-email-adrian.hunter@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/13 6:29 AM, Adrian Hunter wrote:
> For kernels that do not support PERF_SAMPLE_IDENTIFIER,
> sample types need not be identical to determine
> the sample id from the event.  Only the position
> of the sample id needs to be the same.
>
> Compatible sample types are ones in which the bits
> defined by PERF_COMPAT_MASK are the same.
> 'perf_evlist__config()' forces sample types to be
> compatible on that basis.

Arnaldo and I have discussed adding callchain handling to perf-trace. To 
do that we only need stack data (including IP) for one event -- eg, 
raw_syscalls:sys_enter. That means raw_syscalls:sys_enter and 
raw_syscalls:sys_exit will have different attributes set - including 
ones in the MASK.

David

