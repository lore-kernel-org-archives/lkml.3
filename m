Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547Ab3LITnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:43:08 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63339 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432Ab3LITnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:43:04 -0500
Message-ID: <52A61D43.6020007@gmail.com>
Date: Mon, 09 Dec 2013 12:42:59 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
References: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20131206115627.GA2279@ghostprotocols.net> <52A4AED8.3000506@gmail.com> <20131209180705.GB8098@ghostprotocols.net> <52A60705.5030303@gmail.com> <20131209184901.GE8098@ghostprotocols.net>
In-Reply-To: <20131209184901.GE8098@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/9/13, 11:49 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Dec 09, 2013 at 11:08:05AM -0700, David Ahern escreveu:
>> On 12/9/13, 11:07 AM, Arnaldo Carvalho de Melo wrote:
>>> Em Sun, Dec 08, 2013 at 10:39:36AM -0700, David Ahern escreveu:
>>>> On 12/6/13, 4:56 AM, Arnaldo Carvalho de Melo wrote:
>>>>> You get correct results because the modules/kallsyms info you provided
>>>>> matches the VM you're testing, i.e. the pid test is not needed.
>>>>>
>>>>> I think we need to specify for which PID the --guestmodules and
>>>>> --guestkallsyms is provided, so that it can refuse to use it for pids
>>>>> where it is invalid.
>>>>
>>>> Those are arguments are shortcut defaults for guests. If the VMs are
>>>> not running the same kernel use guestmount and pid specific
>>>> directories. e.g.,
>>>>
>>>> /tmp/guestmount/<pid>/proc/kallsyms
>>>
>>> Does this already works like that? /me tries to figure that out...
>>
>> yes.
>>
>
> Yeah, I saw that:
>
>          if ((pid != HOST_KERNEL_ID) &&
>              (pid != DEFAULT_GUEST_KERNEL_ID) &&
>              (symbol_conf.guestmount)) {
>                  sprintf(path, "%s/%d", symbol_conf.guestmount, pid);
>
> So, in summary, ack/nack this patch?
>

NACK. Not needed and breaks the very intent of those 2 options.

David
