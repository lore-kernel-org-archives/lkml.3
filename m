Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaLJM7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:59:20 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42529 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbaLJM7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:59:19 -0500
Message-ID: <548843A0.6040906@gmail.com>
Date: Wed, 10 Dec 2014 21:59:12 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: ejt@redhat.com
CC: dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com,
        agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
References: <5484498E.4000202@gmail.com> <20141207200834.GA2322@kroah.com> <5484C0E9.3060707@gmail.com> <20141209151253.GA17660@debian> <20141210100033.GA21108@debian> <548827BD.3050803@gmail.com> <20141210123349.GC21108@debian>
In-Reply-To: <20141210123349.GC21108@debian>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

I appreciate your continuous work.

Is that read or write?
The difference between Type 0 and 1 should only show up in write path.
So is it write test?

And what is the unit of each result?

> So maybe it's just volume of IO that's causing the problem?  What's
> the difference between Type 0 and Type 1?  In the code I notice you
> have 'rambuf' structures, are you caching IO in memory?
"rambuf" is a temporary space that every write data comes in.
127*4KB data are once stored there and 4KB metadata section are added
then it becomes a log and flushed to the cache device sequentially (512KB each).

By the way,
I think more clearer discussion can be done if tests are done on physical machines
to isolate things relevant to VM. I will also add these tests to dmts later and
run on my machine.
But, it will be much better if we have good server with RAID-ed backing store
and the newest SSD (How would it be if it's PCI-e SSD)... 

- Akira

On 12/10/14 9:33 PM, Joe Thornber wrote:
> On Wed, Dec 10, 2014 at 08:00:13PM +0900, Akira Hayakawa wrote:
>> Hi, Joe
>>
>> Thanks for continuous evaluation.
> 
> Some more details:
> 
> dd, with block size 512b
> ------------------------
> 
> raw spindle      : 143
> writeboost Type 0: 137
> writeboost Type 1: 130
> 
> dd, with block size 4k
> ----------------------
> 
> raw spindle      : 31
> writeboost Type 0: 29
> writeboost Type 1: 81
> 
> 
> dd, with block size 64m
> -----------------------
> 
> raw spindle      : 8.9
> writeboost Type 0: 32
> writeboost Type 1: 72
> 
> 
> 
> So maybe it's just volume of IO that's causing the problem?  What's
> the difference between Type 0 and Type 1?  In the code I notice you
> have 'rambuf' structures, are you caching IO in memory?
> 

