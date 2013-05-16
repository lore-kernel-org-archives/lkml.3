Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3EPHe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:34:59 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:35173 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab3EPHey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:34:54 -0400
Message-ID: <51948C1B.20408@kernel.org>
Date: Thu, 16 May 2013 10:34:51 +0300
From: Pekka Enberg <penberg@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 8/9] perf report: Add report.percent-limit config variable
References: <1368497347-9628-1-git-send-email-namhyung@kernel.org> <1368497347-9628-9-git-send-email-namhyung@kernel.org> <CAOJsxLF+4D68oQrcWXyzFgHBcXv4nLvmnSQyCiEYN2CMpRv48Q@mail.gmail.com> <8761yk5zdr.fsf@sejong.aot.lge.com>
In-Reply-To: <8761yk5zdr.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 01:08 PM, Namhyung Kim wrote:
> Hi Pekka,
>
> On Tue, 14 May 2013 14:05:38 +0300, Pekka Enberg wrote:
>> On Tue, May 14, 2013 at 5:09 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>>> From: Namhyung Kim <namhyung.kim@lge.com>
>>>
>>> Now an user can set a default value of --percent-limit option into the
>>> perfconfig file.
>>>
>>>    $ cat ~/.perfconfig
>>>    [report]
>>>    percent-limit = 0.1
>>>
>>> Cc: Andi Kleen <andi@firstfloor.org>
>>> Cc: Pekka Enberg <penberg@kernel.org>
>>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>>
>> I'm not totally convinced this is useful. The limit is about "what is
>> significant" and that depends on what you are trying to measure.
>> There's an (absolute) lower limit somewhere between 0.1 and 1.0 but I
>> think we can just pick a reasonable default and  let people use the
>> command line switch if they want to override it.
>
> If the limit depends on what is measured, what should be the reasonable
> default value?  I just don't know..
>
> I agree that we should pick a default but the config variable doesn't
> harm anything in this case too.  Some users might not agree with our
> default for their cases and want to use other value.
>
> But I'm not insist on it so strongly, I just gave another way.. ;)

I'd go for default value of 1.0 first and if people complain, drop it to 
0.1. But I guess it's safer to add your config option thingy just in case:

Acked-by: Pekka Enberg <penberg@kernel.org>

			Pekka
