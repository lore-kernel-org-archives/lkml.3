Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233AbaH0RD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:03:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437AbaH0RD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:03:26 -0400
Message-ID: <53FE0F46.5010001@zytor.com>
Date: Wed, 27 Aug 2014 10:03:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mike Galbraith <mgalbraith@suse.de>, Linux-X86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Reduce length of the eagerfpu path during x86 context
 switches
References: <1407329748-3928-1-git-send-email-mgorman@suse.de> <20140827160335.GD12424@suse.de>
In-Reply-To: <20140827160335.GD12424@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 09:03 AM, Mel Gorman wrote:
> On Wed, Aug 06, 2014 at 01:55:45PM +0100, Mel Gorman wrote:
>> Eager FPU switching is used on CPUs that support xsave on the grounds
>> that CPUs that support it can optimise the switch with xsaveopt and xrstor
>> instead of serialising by updating cr0.TS which has serialising semantics.
>>
>> The path for eagerfpu is fatter than it needs to be because it still
>> maintains the fpu_counter for lazy FPU switches even though the information
>> is never used. This patch splits the paths optimises the eagerfpu path a
>> little. The benefit is marginal, it was just noticed when looking at why
>> integer-only workloads were spending time saving/restoring FPU states.
>>
> 
> This was initially sent when it would collide with the merge window
> which was stupid timing. Nothing has actually changed since but I wonder
> if anyone had a chance to take a look at this patches?
> 

Looking at it now.

	-hpa


