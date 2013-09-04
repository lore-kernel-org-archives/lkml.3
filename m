Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab3IDRzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:55:04 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50831 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762923Ab3IDRzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:55:02 -0400
Message-ID: <522773EF.8080701@gmail.com>
Date: Wed, 04 Sep 2013 11:54:55 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: latest perf code fails to parse existing data file
References: <5225051C.3030608@gmail.com> <5225844E.3090700@intel.com> <5225DAFB.1070406@gmail.com> <5225E320.8090307@intel.com> <5225E815.4010705@gmail.com>
In-Reply-To: <5225E815.4010705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/13 7:45 AM, David Ahern wrote:
> On 9/3/13 7:24 AM, Adrian Hunter wrote:
>> On 03/09/13 15:50, David Ahern wrote:
>>> Kernel version? Is your kernel side support there?
>>
>> The kernel version is the same as the perf version i.e. 3.9
>>
>>>
>>> For me data was collected on 2.6.34 about a week ago. Processed fine
>>> up to
>>> the point of this patch getting added.
>>
>> Is it only "perf trace" that fails or does "perf script" fail too?
>
> Both throw the same error. Command line used to create the file:
>    perf record -e raw_syscalls:* -e sched:* -p 2271 -g -- sleep 5

Seems to be an artifact of older kernels. Definitely occurs for 2.6.34 
and WindRiver Linux 4. Also reproduced with vanilla 2.6.35. Use newer 
perf command -- e.g., 3.11 -- to record events and then try to analyze 
with Linus', Arnaldo's or Ingo's latest branch which now have this 
patch. Given the breakage it needs to be either fixed or reverted before 
3.12

David

