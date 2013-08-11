Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750901Ab3HKE2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 00:28:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37992 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3HKE2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 00:28:02 -0400
Message-ID: <520712AE.6060904@zytor.com>
Date: Sat, 10 Aug 2013 21:27:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mingo@kernel.org, torvalds@linux-foundation.org
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>  <5205C4BB.6020003@zytor.com> <1376114128.5332.17.camel@marge.simpson.net>  <5206659F.9070705@zytor.com> <1376194657.7006.11.camel@marge.simpson.net>
In-Reply-To: <1376194657.7006.11.camel@marge.simpson.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2013 09:17 PM, Mike Galbraith wrote:
>>
>> Do you have any quantification of "munches throughput?"  It seems odd
>> that it would be worse than polling for preempt all over the kernel, but
>> perhaps the additional locking is what costs.
> 
> I hadn't compared in ages, so made some fresh samples.
> 
> Q6600 3.11-rc4
> 
> vmark
> voluntary     169808     155826     154741     1.000
> preempt       149354     124016     128436      .836
> 
> That should be ~worst case, it hates preemption. 
> 
> tbench 8
> voluntary    1027.96    1028.76    1044.60     1.000
> preempt       929.06     935.01     928.64      .900
> 
> hackbench -l 10000
> voluntary     23.146     23.124     23.230     1.000
> preempt       25.065     24.633     24.789     1.071
> 
> kbuild vmlinux
> voluntary  3m44.842s  3m42.975s  3m42.954s     1.000
> preempt    3m46.141s  3m45.835s  3m45.953s     1.010
> 
> Compute load comparisons are boring 'course.
> 

I presume voluntary is indistinguishable from no preemption at all?

Either way, that is definitely a reproducible test case, so if someone
is willing to take on optimizing preemption they can use vmark as the
litmus test.  It would be really awesome if we genuinely could get the
cost of preemption down to where it just doesn't matter.

	-hpa


