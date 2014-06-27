Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaF0XIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:08:10 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:57049 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaF0XIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:08:06 -0400
Message-ID: <53ADF953.2080009@gmail.com>
Date: Fri, 27 Jun 2014 17:08:03 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 14/18] perf tools: Add perf_config_u64 function
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org> <1403103539-16807-15-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403103539-16807-15-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/14, 8:58 AM, Jiri Olsa wrote:

> @@ -307,6 +322,15 @@ static void die_bad_config(const char *name)
>   	die("bad config value for '%s'", name);
>   }
>
> +u64 perf_config_u64(const char *name, const char *value)
> +{
> +	long long ret = 0;
> +
> +	if (!perf_parse_llong(value, &ret))
> +		die_bad_config(name);
> +	return (u64) ret;


Thought we were not using the die functions any longer?

David
