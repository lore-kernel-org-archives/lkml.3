Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3AWX0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:26:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43494 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3AWX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:26:28 -0500
Message-ID: <5100719C.8070503@canonical.com>
Date: Wed, 23 Jan 2013 23:26:20 +0000
From: Colin Ian King <colin.king@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf evsel: fix NULL pointer deference when evsel->counts
 is NULL
References: <1358613414-13005-1-git-send-email-colin.king@canonical.com> <871udfkua5.fsf@sejong.aot.lge.com> <20130123220200.GE6687@ghostprotocols.net>
In-Reply-To: <20130123220200.GE6687@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/13 22:02, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jan 21, 2013 at 01:53:21PM +0900, Namhyung Kim escreveu:
>> On Sat, 19 Jan 2013 16:36:54 +0000, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>
>>> __perf_evsel__read_on_cpu() only bails out with -ENOMEM if
>>> evsel->counts is NULL and perf_evsel__alloc_counts() has returned
>>> an error.  If perf_evsel__alloc_counts() does not return an error
>>> we get an NULL pointer deference on evsel->counts->cpu[cpu]
>>> if evsel->counts is NULL.
>
>> perf_evsel__alloc_counts() should allocate evsel->counts when it sees
>> evsel->counts is NULL and return negative error code if the allocation
>> fails.
>
>> So I don't see any problem in current code.  With your code, it won't
>> try to allocate if ->counts is NULL but overwrite existing ->counts?
>
> Right, the patch introduces a problem in code that works perfectly :-)
>
> - Arnaldo
>
Apologies for the noise.

Colin
