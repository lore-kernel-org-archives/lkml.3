Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab3ECPIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:08:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:50990 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561Ab3ECPIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:08:01 -0400
Message-ID: <5183D2CC.6050409@gmail.com>
Date: Fri, 03 May 2013 09:07:56 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ulrich Drepper <drepper@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 3/8] perf tools: Add formula-* parsing support for events
References: <1367421346-18257-1-git-send-email-jolsa@redhat.com> <1367421346-18257-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1367421346-18257-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/13 9:15 AM, Jiri Olsa wrote:
> +static char **formula_add(char **f, char *new)
> +{
> +	int i;
> +#define FORMULAS_CNT 20
> +
> +	if (!f) {
> +		f = zalloc(sizeof(char *) * FORMULAS_CNT + 1);
> +		if (!f)
> +			return NULL;
> +	}
> +
> +	for (i = 0; f[i] && (i < FORMULAS_CNT); i++);
> +
> +	if (i == FORMULAS_CNT) {
> +		pr_err("Too many formula defined, max = %d\n",
> +		       FORMULAS_CNT);
> +		return NULL;
> +	}

Why have an array of arbitrary limit versus a linked list?

David
