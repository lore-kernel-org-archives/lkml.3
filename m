Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab3KGObC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 09:31:02 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39171 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab3KGOa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 09:30:59 -0500
Message-ID: <527BA420.6000403@gmail.com>
Date: Thu, 07 Nov 2013 07:30:56 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf: Fix version when building out of tree
References: <1383699213-23981-1-git-send-email-dsahern@gmail.com> <20131106053654.GA23746@gmail.com> <527A582D.4000301@gmail.com> <20131107083035.GB32542@gmail.com>
In-Reply-To: <20131107083035.GB32542@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/7/13, 1:30 AM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> On 11/5/13, 10:36 PM, Ingo Molnar wrote:
>>> I think you could avoid the 'short' complication altogether by doing
>>> something like this:
>>>
>>>> +elif test -f ../../PERF-VERSION-FILE
>>>> +then
>>>> +	TAG=$(cut -d' ' -f3 ../../PERF-VERSION-FILE)
>>>
>>> That extracts 'TAG' as a true sha1 and makes GVF correct on out of tree
>>> builds as well.
>>
>> Certainly. I was trying to make PERF-VERSION-FILE readable as a
>> standalone file -- a better version descriptor than HEAD file.
>
> Do you mean that instead of:
>
>    comet:~/tip/tools/perf> cat PERF-VERSION-FILE
>    #define PERF_VERSION "3.12.g953bfb"

no. I was thinking instead of
cat PERF-VERSION-FILE
#define PERF_VERSION "3.12.g953bfb"

you have
cat PERF-VERSION-FILE
3.12.g953bfb

But remember this is a new PERF-VERSION-FILE at the top of tree -- just 
like the HEAD file that contains the top commit id. Both are generated 
as part of the make perf-tar-src-pkg to keep track of the origin of the 
source. The new file becomes the basis of $(OUTPUT)PERF-VERSION-FILE.

> we should put a plain version into it? (the 'short' form you introduced
> earlier)
>
> And then this:
>
>    Makefile.perf:  $(QUIET_CC)$(CC) -include $(OUTPUT)PERF-VERSION-FILE \
>
> Could be replaced with:
>
>    Makefile.perf:  $(QUIET_CC)$(CC) -D $(shell cat $(OUTPUT)PERF-VERSION-FILE) \
>
> or so?

something like that could be done too.

David
