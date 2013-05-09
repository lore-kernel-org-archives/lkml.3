Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab3EITn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 15:43:56 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:60657 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3EITnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 15:43:53 -0400
Message-ID: <518BFC78.2000308@gmail.com>
Date: Thu, 09 May 2013 13:43:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 5/9] perf tools: Set maximum precise value for event 'p'
 modifier
References: <1368106344-23383-1-git-send-email-jolsa@redhat.com> <1368106344-23383-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1368106344-23383-6-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/9/13 7:32 AM, Jiri Olsa wrote:
> +static int precise_default(void)
> +{
> +	int precise = perf_precise__get();
> +	static int warned;
> +
> +	/*
> +	 * Precise info not supported by by this kernel,
> +	 * set 1 as the precise value.
> +	 */
> +	if (precise == -1)
> +		precise = 1;
> +
> +	/* PEBS is not supported here, display warning. */
> +	if (precise == 0 && !warned++)
> +		pr_warning("warning: no precise support, "
> +			   "using non-precise event(s)\n");

WARN_ONCE().

David
