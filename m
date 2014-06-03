Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaFCNga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:36:30 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43777 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbaFCNg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:36:29 -0400
Message-ID: <538DCF59.6000808@gmail.com>
Date: Tue, 03 Jun 2014 07:36:25 -0600
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
> We keep dsos data file descriptors open until their count reaches
> the half of the current fd open limit (RLIMIT_NOFILE). In this case
> we close file descriptor of the first opened dso object.
>
> We've got overall speedup (24% for my workload) of report:
>   'perf report --stdio -i perf-test.data' (3 runs)
>    (perf-test.data size was around 12GB)
>
>    current code:
>     446,826,474,217      cycles                     ( +-  0.23% )
>     669,435,100,846      instructions               ( +-  0.03% )
>
>       266.380674551 seconds time elapsed            ( +-  0.37% )
>
>    change:
>     558,345,509,819      cycles                     ( +-  0.55% )
>     817,283,647,637      instructions               ( +-  0.03% )
>
>       351.564209617 seconds time elapsed            ( +-  0.89% )

message is confusing. Looks like time went up.

David
