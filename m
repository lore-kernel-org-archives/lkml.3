Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbaIRUVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:21:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44898 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbaIRUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:21:41 -0400
Message-ID: <541B3ECD.8000706@gmail.com>
Date: Thu, 18 Sep 2014 14:21:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/2] perf session: Add option to copy events when queueing
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com> <1411060059-23589-2-git-send-email-yarygin@linux.vnet.ibm.com> <20140918185345.GJ2770@kernel.org>
In-Reply-To: <20140918185345.GJ2770@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/18/14, 12:53 PM, Arnaldo Carvalho de Melo wrote:
> If nobody objects I'll merge this patch, as it fixes problems, but I
> wonder if the best wouldn't be simply not calling
> perf_evlist__mmap_consume() till the last event there is in fact
> consumed... I.e. as we _really_ consume the events, we remove it from
> there.
>
> Instead of consuming the event at perf_tool->sample() time, we would
> do it at perf_tool->finished_round(), would that be feasible? Has anyone
> tried this?

Hmmm... haven't tried this.  Conceptually it should work - at least 
nothing comes to mind at the moment.


Patch looked ok to me: Reviewed-by: David Ahern <dsahern@gmail.com>

Jiri should review based on his recent changes for ordered events.

David
