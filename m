Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967505Ab3HIDJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 23:09:53 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62132 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967185Ab3HIDJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 23:09:52 -0400
Message-ID: <52045D7C.50300@gmail.com>
Date: Thu, 08 Aug 2013 23:09:48 -0400
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf tests: Fix compile failure on do_sort_something
References: <1375912782-74921-1-git-send-email-dsahern@gmail.com> <5203337B.4040906@intel.com>
In-Reply-To: <5203337B.4040906@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/13 1:58 AM, Adrian Hunter wrote:
> On 08/08/13 00:59, David Ahern wrote:
>> Commit b55ae0a9 added code-reading.c which fails to compile on Fedora 16
>> with compiler version:
>> $ gcc --version
>> gcc (GCC) 4.6.3 20120306 (Red Hat 4.6.3-2)
>>
>> Failure message is:
>>
>> tests/code-reading.c: In function ‘do_sort_something’:
>> tests/code-reading.c:305:13: error: stack protector not protecting local variables: variable length buffer [-Werror=stack-protector]
>> cc1: all warnings being treated as errors
>> make: *** [/tmp/junk/tests/code-reading.o] Error 1
>> make: *** Waiting for unfinished jobs....
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> Cc: Adrian Hunter <adrian.hunter@intel.com>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>> ---
>>   tools/perf/tests/code-reading.c |   11 +++++------
>>   1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
>> index 8e0943b..4bde8be 100644
>> --- a/tools/perf/tests/code-reading.c
>> +++ b/tools/perf/tests/code-reading.c
>> @@ -304,15 +304,14 @@ static int comp(const void *a, const void *b)
>>
>>   static void do_sort_something(void)
>>   {
>> -	size_t sz = 40960;
>> -	int buf[sz], i;
>> +	int buf[40960], i;
>>
>> -	for (i = 0; i < (int)sz; i++)
>> -		buf[i] = sz - i - 1;
>> +	for (i = 0; i < (int)sizeof(buf); i++)
>
>
> Should that be ARRAY_SIZE not sizeof

oops, yes it should.

David
