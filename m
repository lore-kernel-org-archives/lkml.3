Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3KKUo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:44:29 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:46548 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab3KKUoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:44:23 -0500
Message-ID: <528141A4.3050304@gmail.com>
Date: Mon, 11 Nov 2013 13:44:20 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/2] perf record: mmap output file - v4
References: <1383884605-30968-1-git-send-email-dsahern@gmail.com> <1383884605-30968-3-git-send-email-dsahern@gmail.com> <20131111112906.GE15810@gmail.com> <20131111145804.GB27198@ghostprotocols.net> <5280F50E.6010700@gmail.com> <20131111204104.GB18886@gmail.com>
In-Reply-To: <20131111204104.GB18886@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 1:41 PM, Ingo Molnar wrote:
>
> * David Ahern <dsahern@gmail.com> wrote:
>
>> On 11/11/13, 7:58 AM, Arnaldo Carvalho de Melo wrote:
>>>
>>>> Looks very clean now!
>>>
>>>> Acked-by: Ingo Molnar <mingo@kernel.org>
>>>
>>> Applied the prep patch, but waiting for v5 as stated by David when
>>> answering Jiri's concerns.
>>
>> I'll re-send - giving some time for comments on the use of
>> setjmp/longjmp to bounce out of memcpy and error exit when filesystem
>> runs out of space.
>
> Maybe that could be an add-on patch instead?

That's what Arnaldo and I were thinking.
>
> All the rest would already be an improvement, right?

Yes. The longjmp handles the out-of-space failure condition trying to 
write the data to a file. With mmap writes you get a SIGBUS when the 
filesystem is full and you need to bail out of the memcpy.

David
