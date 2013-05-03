Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3ECPSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:18:11 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58196 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932459Ab3ECPSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:18:10 -0400
Message-ID: <5183D52D.7060303@gmail.com>
Date: Fri, 03 May 2013 09:18:05 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, Ulrich Drepper <drepper@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 6/8] perf tests: Add automated tests for formula object
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com> <1367421346-18257-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-7-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/13 9:15 AM, Jiri Olsa wrote:
> +static int __test_basics(char *file)
> +{
> +	struct perf_formula fml;
> +	struct perf_formula_set *set;
> +	struct perf_formula_counter *counter;
> +	struct perf_evlist *evlist;
> +	struct perf_evsel *evsel;
> +	struct perf_counts *counts;
> +	struct perf_formula_expr expr;
> +	int ret;
> +
> +	pr_debug("file %s\n", file);
> +
> +	perf_formula__init(&fml);
> +
> +	ret = perf_formula__load(&fml, file);
> +	TEST_ASSERT_VAL("failed to load formula", !ret);

With all the asserts when something goes wrong you should delete the 
file right after perf_formula__load. so maybe

file = file_get(data, sizeof(data));
ret = perf_formula__load(&fml, file);
file_put(file);

David
