Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854Ab3BFSHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:07:53 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50419 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3BFSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:07:51 -0500
Message-ID: <51129BEA.6090302@linux.vnet.ibm.com>
Date: Wed, 06 Feb 2013 12:07:38 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214941.4615.29852.stgit@lambeau> <51126A84.5050005@parallels.com>
In-Reply-To: <51126A84.5050005@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020618-5564-0000-0000-0000068295D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 08:36 AM, Glauber Costa wrote:
> On 02/06/2013 01:49 AM, Michael Wolf wrote:
>> Add a helper routine to scheduler/core.c to allow the kvm module
>> to retrieve the cpu hardlimit settings.  The values will be used
>> to set up a timer that is used to separate the consigned from the
>> steal time.
> Sorry: What is the business of a timer in here?
> Whenever we read steal time, we know how much time has passed and with
> that information we can know the entitlement for the period. This breaks
> if we suspend, but we know that we suspended, so this is not a problem.
I may be missing something, but how do we know how much time has 
passed?  That is why
I had the timer in there.  I will go look again at the code but I 
thought the data was collected
as ticks and passed at random times.  The ticks are also accumulating so 
we are looking at the
difference in the count between reads.....

>
> Everything bigger the entitlement is steal time.
I agree provided I know the amount of total time that the steal time was 
accumulated.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

