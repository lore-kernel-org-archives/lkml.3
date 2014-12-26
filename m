Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaLZRA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 12:00:59 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54591 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLZRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 12:00:58 -0500
Message-ID: <549D9446.6050506@gmail.com>
Date: Fri, 26 Dec 2014 10:00:54 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 11/37] perf tools: Introduce thread__comm_time() helpers
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org> <1419405333-27952-12-git-send-email-namhyung@kernel.org>
In-Reply-To: <1419405333-27952-12-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/14 12:15 AM, Namhyung Kim wrote:
> @@ -139,6 +161,16 @@ const char *thread__comm_str(const struct thread *thread)
>   	return comm__str(comm);
>   }
>
> +const char *thread__comm_time_str(const struct thread *thread, u64 timestamp)
> +{
> +	const struct comm *comm = thread__comm_time(thread, timestamp);
> +
> +	if (!comm)
> +		return NULL;
> +
> +	return comm__str(comm);
> +}
> +

thread__comm_str_time()? time_str suggests a time-based string as 
opposed to a comm_str based on time.

David
