Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbaFCNjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:39:13 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:57378 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaFCNjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:39:12 -0400
Message-ID: <538DCFFD.8030306@gmail.com>
Date: Tue, 03 Jun 2014 07:39:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 06/13] perf tools: Cache dso data file descriptor
References: <1401743927-398-1-git-send-email-jolsa@kernel.org> <1401743927-398-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401743927-398-7-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> +static rlim_t get_fd_limit(void)
> +{
> +	struct rlimit l;
> +	rlim_t limit = 0;
> +
> +	/* Allow half of the current open fd limit. */
> +	if (getrlimit(RLIMIT_NOFILE, &l) == 0) {
> +		if (l.rlim_cur == RLIM_INFINITY)
> +			limit = l.rlim_cur;


Why not limit this to something reasonable -- 512 or 1024 -- rather 
"infinity" (~0UL).

David
