Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaFCNvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:51:40 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53494 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbaFCNvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:51:39 -0400
Message-ID: <538DD2E3.2090407@gmail.com>
Date: Tue, 03 Jun 2014 07:51:31 -0600
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
Subject: Re: [PATCH 11/13] perf tests: Allow reuse of test_file function
References: <1401743927-398-1-git-send-email-jolsa@kernel.org> <1401743927-398-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401743927-398-12-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> Making the test_file function to be reusable for
> new tests coming in following patches.
>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jean Pihet <jean.pihet@linaro.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/perf/tests/dso-data.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/tests/dso-data.c b/tools/perf/tests/dso-data.c
> index 3e6cb17..f5c8743 100644
> --- a/tools/perf/tests/dso-data.c
> +++ b/tools/perf/tests/dso-data.c
> @@ -12,11 +12,15 @@
>
>   static char *test_file(int size)
>   {
> -	static char buf_templ[] = "/tmp/test-XXXXXX";
> +#define TEMPL "/tmp/test-XXXXXX"

use /tmp/perf-test-XXXXXX or /tmp/perf-XXXXXX to we know where all these 
tmp files came from.

> +	static char buf_templ[sizeof(TEMPL)];

why static? and ...

>   	char *templ = buf_templ;
>   	int fd, i;
>   	unsigned char *buf;
>
> +	strcpy(buf_templ, TEMPL);
> +#undef TEMPL

why the need to change from char buf_templ[] to strcpy?

David
