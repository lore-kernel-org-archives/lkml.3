Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3LLQzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:55:16 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56519 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3LLQzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:55:13 -0500
Message-ID: <52A9EA6E.50205@gmail.com>
Date: Thu, 12 Dec 2013 09:55:10 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] perf list: fix --raw-dump
References: <1386756980-23121-1-git-send-email-artagnon@gmail.com> <52A8D2DA.7050409@gmail.com> <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
In-Reply-To: <CALkWK0ksAB1xkaCR5jxaN-4n1KL3yQACp_62=ijmFZjj8KNuew@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/13, 12:34 AM, Ramkumar Ramachandra wrote:
> David Ahern wrote:
>> Why not make raw_dump a proper argument?
>
> Sure, that'd work too. I was thinking of a minimal way to fix the
> problem myself.
>
>> diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
>> index 011195e38f21..b553d0c4ca82 100644
>> --- a/tools/perf/builtin-list.c
>> +++ b/tools/perf/builtin-list.c
>> @@ -36,6 +38,10 @@ int cmd_list(int argc, const char
>>               print_events(NULL, false);
>>               return 0;
>>         }
>> +      if (raw_dump) {
>> +            print_events(NULL, true);
>> +            return 0;
>> +      }
>
> This won't work because you've put it right below the `if (argc ==
> 0)`, which executes print_events(). You could move it up and get it to
> work.
>

your updated patch looks good to me.

David
