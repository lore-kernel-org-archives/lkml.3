Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760470Ab3LIEc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:32:59 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43284 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab3LIEcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:32:54 -0500
Message-ID: <52A547F4.6080904@gmail.com>
Date: Sun, 08 Dec 2013 21:32:52 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A5DFC9.6020105@cn.fujitsu.com> <52A53C3A.2090107@gmail.com> <52A5FA13.9000000@cn.fujitsu.com>
In-Reply-To: <52A5FA13.9000000@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/13, 10:12 AM, Dongsheng Yang wrote:
> On 12/08/2013 10:42 PM, David Ahern wrote:
>> On 12/9/13, 8:20 AM, Dongsheng Yang wrote:
>>> How about introduce an option named --guestpid? Then we can make the
>>> usage of perf kvm
>>> more clear:
>>>      * perf kvm --guestkallsyms --guestmodules --guestpid
>>> [top|record|report]
>>>          This usage is for only one guest and will not resolve the
>>> symbols from other guests.
>>
>> If there is only 1 guest then there should not be a problem right? You
>> give perf a single guest kallsyms as the "default" and it works.
>> --guestpid adds no value in that case.
>
> Yes, if there is only one guest is running, "default" guest is "the"
> guest. Then with my patch in this thread applied, it works well.
>
> But consider this scenario, there are two guests are running, but we
> need to record-report one of them.
>
> --guestmount can achieve this request, but as a shortcut of guestmount,
> --guest{kallysms, modules} dose not
> support it well, right? So, I think we can discard the default guest,
> and use guestpid in record-report.

No.

Use cases:
1. one guest
--guestkallsyms and --guestmodules apply to default guest; user should 
supply files that apply to the one guest. Supplying any other kallsyms 
is just nonsense. *NO* other arguments are needed.

2. more than 1 VM, *ALL* VMs running the same kernel
--guestkallsyms and --guestmodules apply to default guest; user should 
supply files that apply to all of guests. No other arguments are needed.

3. more than 1 VM, VMs running different kernels. 1+ VMs running the 
same kernel
--guestmount allows user to supply files that apply to all of guests 
based on pid. --guestkallsyms/guestmodules is used for any guest not 
showing up in guestmount.

David

