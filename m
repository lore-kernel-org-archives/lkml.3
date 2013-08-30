Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3H3Mdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:33:40 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:49551 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3H3Mdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:33:39 -0400
Message-ID: <52209119.3070907@gmail.com>
Date: Fri, 30 Aug 2013 21:33:29 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: mpatocka@redhat.com, agk@redhat.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kernelnewbies@kernelnewbies.org
Subject: Re: [dm-devel] [RFC] dm-lc: plan to go to staging
References: <521EA567.1070801@gmail.com> <20130829020555.GA26206@kroah.com> <20130829033023.GH4872@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308291043410.20142@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your constructive comments,

I want to first settle an agreement on the new name for current dm-lc
according to Alasdair's comment:
>> 2) Agree a new and meaningful target name with us so you don't have to
>> change it later.  "lc" means nothing, I'm afraid.

After we agree on this issue, I will start tackling on the design issues.
Choosing this issue first is because it may change the whole codebase
and rename the Github repo which can be one of the elements in MAINTAINERS file.

Name is very important.

First of all, let me make a tiny objection:
1) The name dm-lc does means. lc is the initials from Log-structured Caching.
2) LC is also the name of my a favorite anime character from "God only knows".
   I did want to use her name for my creation.

But,
I can agree on Alasdair's opinion that dm-lc means nothing,
for the potential future users.
Abbreviation of some technical word to a software name looks nice
but the unfortunate is that LC is not widely common like RAID or LFS.

I have three candidates on my mind.
I am thinking of removing the dm- prefix as bcache and enhanceio do.

The Points are:
1) The name should not be too long.
   A name explaining too much about the software is noisy.
2) Making clear the characteristics and the difference from other targets.
   The characteristics to note are:
   a) It writes in-coming writes in log-structured manner.
   b) It is extremely fast in write.
   c) It is caching software.

Candidates:
1) logcache
Not too long but explaining enough
but looks little bit dull to me.
Futhermore, there still is dm-log
and I feel like duplicating a little bit.

2) lscache
lscache sounds cool to me.
But the problem is that there is a preceding one with the same name
as to caching web-server workload.
Unique name makes it easy to search for a web documents.

3) writeboost or wboost
Concentrating on the characteristic b)
but doesn't mention cache.

Up to this point,
which do you think the best for the new name?
or other candidate?

I suppose logcache is an acceptable compromise.

Thanks for reading,
Akira

On 8/29/13 11:45 PM, Mikulas Patocka wrote:
> Another idea:
> 
> Make the interface of dm-lc (the arguments to constructor, messages and 
> the status line) the same as dm-cache, so that they can be driven by the 
> same userspace code.
> 
> Mikulas
> 
> 
> On Thu, 29 Aug 2013, Alasdair G Kergon wrote:
> 
>> On Wed, Aug 28, 2013 at 07:05:55PM -0700, Greg KH wrote:
>>> For staging drivers, I need a TODO file that lists
>>> what needs to be done to the code to get it into a mergable state for
>>> the "real" part of the kernel,
>>
>> Two simple requirements before putting your proof-of-concept into staging
>> if you want to work that way:
>>
>> 1) Drop the major version number to 0.  Version 1 is reserved for
>> supported modules.
>>
>> 2) Agree a new and meaningful target name with us so you don't have to
>> change it later.  "lc" means nothing, I'm afraid.
>>
>> Then in general terms, you should continue to compare your device-mapper
>> target with the existing targets and where there are differences, either
>> change your target to be like something that already exists, or be ready
>> to explain why that can't or shouldn't be done.
>>
>> In particular, the interface and architecture will need substantial
>> changes and working these out should be your highest priority.
>>
>> For example, you write:
>>
>>   Be careful, you MUST create all the LVs as the destinations of
>>   the dirty blocks on the cache device before this operation.  Otherwise,
>>   the kernel may crash.
>>
>> I read a statement like that as an indication of an interface or
>> architectural problem.  The device-mapper approach is to 'design out'
>> problems, rather than relying on users not doing bad things.
>> Study the existing interfaces used by other targets to understand
>> some approaches that proved successful, then decide which ones
>> come closest to your needs.
>>
>> (Your code also needs many more comments inline to explain what it does
>> and how it works.)
>>
>> The documentation file will eventually need rewriting to follow the same
>> format as the other targets recently added to the kernel.  We document
>> the kernel interface rather than any particular userspace tools, which
>> just have the status of convenient examples.
>>
>> Another little thing I noticed: look into using something like
>> __dm_bless_for_disk() for your metadata and clearly segregate your
>> on-disk structures and document the layout.
>>
>> Alasdair
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>

