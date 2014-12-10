Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbaLJNbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:31:40 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:43517 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaLJNbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:31:38 -0500
Message-ID: <54884B33.4090709@gmail.com>
Date: Wed, 10 Dec 2014 22:31:31 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: ejt@redhat.com
CC: dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com> <5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141210100033.GA21108@debian> <548827BD.3050803@gmail.com> <20141210123349.GC21108@debian> <548843A0.6040906@gmail.com> <20141210131325.GD21108@debian>
In-Reply-To: <20141210131325.GD21108@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

> So you copy the bio payload to a different block of ram and then
> complete the bio?  Or does the rambuf refer to the bio payload
> directly?
Good question.
The answer is, copy the data (got by bio_data(bio)) to rambuf once
and ack if it's not barrier things.
It would be nice if data in rambuf points to bio payload but it now copies
because bio payload can be reused after completion. Am I right?
Is there a way of eliminate memory copying?
 
> I generally find it quicker to investigate problems on the machine
> that are actually exhibiting the problem ;) Seriously though, you're
> asking us to send this upstream; it needs to work on consumer level
> hardware.
OK, I see. I will continue evaluation on my machine too.

> I've got a big machine with Fusion IO storage that I can run the same
> tests on later.
What is the limit of random write performance is one of my concerns.
I guess it can be over 1GB/sec.

- Akira

On 12/10/14 10:13 PM, Joe Thornber wrote:
> On Wed, Dec 10, 2014 at 09:59:12PM +0900, Akira Hayakawa wrote:
>> Joe,
>>
>> I appreciate your continuous work.
>>
>> Is that read or write?
>> The difference between Type 0 and 1 should only show up in write path.
>> So is it write test?
> 
> Yes, writing across the whole device using 'dd'.
> 
> These are the tests:
> 
>   dmtest list --suite writeboost -n /wipe_device/
> 
>> And what is the unit of each result?
> 
> seconds.
> 
>>
>>> So maybe it's just volume of IO that's causing the problem?  What's
>>> the difference between Type 0 and Type 1?  In the code I notice you
>>> have 'rambuf' structures, are you caching IO in memory?
>> "rambuf" is a temporary space that every write data comes in.
>> 127*4KB data are once stored there and 4KB metadata section are added
>> then it becomes a log and flushed to the cache device sequentially (512KB each).
> 
> So you copy the bio payload to a different block of ram and then
> complete the bio?  Or does the rambuf refer to the bio payload
> directly?
> 
>> By the way,
>> I think more clearer discussion can be done if tests are done on physical machines
>> to isolate things relevant to VM. I will also add these tests to dmts later and
>> run on my machine.
>> But, it will be much better if we have good server with RAID-ed backing store
>> and the newest SSD (How would it be if it's PCI-e SSD)... 
> 
> I generally find it quicker to investigate problems on the machine
> that are actually exhibiting the problem ;) Seriously though, you're
> asking us to send this upstream; it needs to work on consumer level
> hardware.
> 
> I've got a big machine with Fusion IO storage that I can run the same
> tests on later.
> 
> - Joe
> 

