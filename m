Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3KZOaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:30:14 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:35193 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083Ab3KZOaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:30:11 -0500
Message-ID: <5294B06A.60104@gmail.com>
Date: Tue, 26 Nov 2013 07:30:02 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 21/25] perf evsel: Skip ignored symbols while printing
 callchain
References: <1385389075-7989-1-git-send-email-acme@infradead.org> <1385389075-7989-22-git-send-email-acme@infradead.org> <52947D65.4050405@intel.com> <20131126142002.GC14838@ghostprotocols.net>
In-Reply-To: <20131126142002.GC14838@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/13, 7:20 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 26, 2013 at 12:52:21PM +0200, Adrian Hunter escreveu:
>> On 25/11/13 16:17, Arnaldo Carvalho de Melo wrote:
>>> From: David Ahern <dsahern@gmail.com>
>>>   	} else {
>>> +		if (al.sym->ignore)
>>
>> Seems to segfault here because sym is null
>>
>>> +			return;
>>> +
>
> Changed it to look at (al.sym && al.sym->ignore), the rest of the code
> already checkfs if al.sym is NULL (printing [unknown], etc), can you
> please take a look at:
>
> https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=c0dd57452349779e0e5d436db8f9448dfffcc512
>
> In an updated acme/perf/core branch?
>

Looks good to me. That's what I was going to send you. Sorry for the noise.

David

