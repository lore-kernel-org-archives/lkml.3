Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaESXFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:05:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397AbaESXFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:05:17 -0400
Message-ID: <537A8E22.4030400@zytor.com>
Date: Mon, 19 May 2014 16:05:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
References: <20140519211719.GA14563@logfs.org> <20140519212320.GB14563@logfs.org> <537A8319.5010100@zytor.com> <20140519223943.GC14563@logfs.org>
In-Reply-To: <20140519223943.GC14563@logfs.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 03:39 PM, Jörn Engel wrote:
> On Mon, 19 May 2014 15:18:01 -0700, H. Peter Anvin wrote:
>>
>> I think this is likely to be particularly valuable during boot.  I can
>> see it becoming substantially less valuable after that point, but during
>> boot is when the most critical.
>>
>> What I do see as an issue is that the value is probably impossible to
>> quantify, and so I feel more than a bit queasy about giving it
>> /dev/random credit.  However, making sure the pool is well stirred
>> during boot is really way more important.
> 
> I would feel fairly confident giving this .25 bits of entropy per
> event.  With 40% unique hashes and assuming at most 1 bit of entropy
> for a unique hash, that is a fairly conservative underestimate.
> 

Sure, but that is for a specific workload.

> What worries me is that much of those 5s may be spent inside the idle
> loop and have rather predictable register content and we may run
> tickless.  I have no great solution for that case.
>
> We could change the ratelimiting to, say, 4 interrupts per jiffie.
> But that would still not help much in the worst case scenario above,
> so the benefits don't seem convincing.

Exactly.

	-hpa

