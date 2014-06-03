Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaFCN5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 09:57:00 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34824 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbaFCN46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 09:56:58 -0400
Message-ID: <538DD426.6050504@gmail.com>
Date: Tue, 03 Jun 2014 07:56:54 -0600
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
Subject: Re: [PATCH 12/13] perf tests: Add test for caching dso file descriptors
References: <1401743927-398-1-git-send-email-jolsa@kernel.org> <1401743927-398-13-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401743927-398-13-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/14, 3:18 PM, Jiri Olsa wrote:
> +static int dsos__create(int cnt, int size)
> +{
> +	int i;
> +
> +	dsos = malloc(sizeof(dsos) * cnt);
> +	TEST_ASSERT_VAL("failed to alloc dsos array", dsos);
> +
> +	for (i = 0; i < cnt; i++) {
> +		char *file;
> +
> +		file = test_file(size);
> +		TEST_ASSERT_VAL("failed to get dso file", file);
> +
> +		dsos[i] = dso__new((const char *)file);
> +		TEST_ASSERT_VAL("failed to get dso", dsos[i]);

typecast is not needed.

David
