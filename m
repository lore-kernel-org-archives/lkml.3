Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab3JAQ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:59:15 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37165 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3JAQ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:59:12 -0400
Message-ID: <524AFF5A.3030909@gmail.com>
Date: Tue, 01 Oct 2013 10:59:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Sonny Rao <sonnyrao@chromium.org>
Subject: Re: [PATCH] perf session: Fix infinite loop on invalid perf.data
 file
References: <1380529188-27193-1-git-send-email-namhyung@kernel.org> <20131001071646.GA20023@gmail.com> <524ACD2A.7040902@gmail.com> <20131001142154.GA31298@gmail.com> <524ADF84.4080801@gmail.com> <20131001153309.GA1287@gmail.com> <20131001165437.GF2920@ghostprotocols.net>
In-Reply-To: <20131001165437.GF2920@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/1/13 10:54 AM, Arnaldo Carvalho de Melo wrote:
> Em Tue, Oct 01, 2013 at 05:33:09PM +0200, Ingo Molnar escreveu:
>>
>> * David Ahern <dsahern@gmail.com> wrote:
>>
>>> On 10/1/13 8:21 AM, Ingo Molnar wrote:
>>>> But if I understood it correctly this particular message could trigger for
>>>> regular users of perf as well, of the perf record is terminated in some
>>>> unusual fashion. Regular users might not have the perf code handy (and
>>>> might not know about git grep either).
>>>
>>> This is the case I was referring to -- normal users don't care about
>>> the code reference, hence the more specific question about how the
>>> perf-record session ended.
>>
>> Hm, what do you call 'code reference'?
>>
>> The message I suggested is:
>>
>>    WARNING: perf/header: Data size is 0. Was the 'perf record' command properly terminated?
>>
>> I didn't intend 'perf/header' to be a code reference - it wanted to refer
>> to the perf.data header. Maybe that should be formulated in a less
>> confusing manner? Something like:
>
> I liked this last one:
>
>>    WARNING: The perf.data file's data size field is 0 which is unexpected.
>>             Was the 'perf record' command properly terminated?
>
> Can I patch that up into Namhyung's latest patch?
>
> Sonny, David, from your replies I think I can add Tested-by: tags for
> both of you?

I'm fine with the last message. And yes a Tested by

