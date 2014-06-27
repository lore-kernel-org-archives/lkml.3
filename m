Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaF0XH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:07:57 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57544 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaF0XH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:07:56 -0400
Message-ID: <53ADF948.2070300@gmail.com>
Date: Fri, 27 Jun 2014 17:07:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 08/18] perf tools: Flush ordered events in case of allocation
 failure
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-9-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> +	case OEQ_FLUSH__HALF:
> +	{
> +		struct ordered_event *first, *last;
> +		struct list_head *head = &q->events;
> +
> +		first = list_entry(head->next, struct ordered_event, list);
> +		last = q->last;
> +
> +		if (WARN_ONCE(!last || list_empty(head), "empty queue"))
> +			return 0;

Maybe a comment that the WARN_ONCE can only happen if perf can't 
allocate an ordered event the first time through?

> +
> +		q->next_flush  = first->timestamp;
> +		q->next_flush += (last->timestamp - first->timestamp) / 2;
> +		break;
> +	}
> +


David
