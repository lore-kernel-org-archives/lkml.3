Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaFJF6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 01:58:50 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:49960 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaFJF6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 01:58:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/9] perf, tools: Add support for text descriptions of events and alias add
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
	<1401486615-21374-3-git-send-email-andi@firstfloor.org>
	<87ha3ud6ic.fsf@sejong.aot.lge.com>
	<20140609165245.GR25366@two.firstfloor.org>
Date: Tue, 10 Jun 2014 14:58:46 +0900
In-Reply-To: <20140609165245.GR25366@two.firstfloor.org> (Andi Kleen's message
	of "Mon, 9 Jun 2014 18:52:45 +0200")
Message-ID: <87fvjdb90p.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Mon, 9 Jun 2014 18:52:45 +0200, Andi Kleen wrote:
>> Hmm.. this will print the description at right side and I think it'd be
>> better if it prints in another line(s) like below:
>
> I think it's better to show the descriptions by default without 
> an extra option. I suspect most people want to see them, or if they
> need them they won't know about obscure -v options.

I partially agree, but I guess adding -v option to the command is not
that hard for them. :)  Maybe we could add a message in order to advise
users to use -v option for description like below:

  $ perf list
  # Use -v/--verbose to see event description (if exists)
  ...

>
>> 
>>   agu_bypass_cancel.count                            [Kernel PMU event]
>>         This event counts executed load operations with all the following
>>          traits: 1. addressing of the format [base + offset], 2. the offset
>>          is between 1 and 2047, 3. the address specified in the base register
>>          is in one page and the address [base+offset] is in an
>
> The problem with this format is that it is not compatible, so it would
> break existing parsers that look at perf list output.  That is why I ended up
> with the right side format.

Hmm.. I think existing parsers should not use -v option then.  The perf
list was for listing only event names (and their types).

I think the main problem of the right side format is that it hurts
readability especially on small screens/terminals.

Thanks,
Namhyung

>
>
>>   arith.fpu_div                                      [Kernel PMU event]
>>         Divide operations executed
>>   arith.fpu_div_active                               [Kernel PMU event]
>>         Cycles when divider is busy executing divide operations
>>   ...
>> 
>> 
>> I just tweaked it using -v option for perf list.  Below is the change I
>> made on top of your series.  What do you think?
>
> I prefer not to apply that patch.
>
> I guess what could make sense is a quiet option to not print
> descriptions.
>
> -Andi
