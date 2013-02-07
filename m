Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab3BGO1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:27:50 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37662 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654Ab3BGO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:27:48 -0500
Message-ID: <5113B9D7.9090503@linux.vnet.ibm.com>
Date: Thu, 07 Feb 2013 08:27:35 -0600
From: Michael Wolf <mjw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: linux-kernel@vger.kernel.org, riel@redhat.com, gleb@redhat.com,
        kvm@vger.kernel.org, peterz@infradead.org, mtosatti@redhat.com,
        mingo@redhat.com, anthony@codemonkey.ws
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214941.4615.29852.stgit@lambeau> <51126A84.5050005@parallels.com> <51129BEA.6090302@linux.vnet.ibm.com> <511369CC.6050405@parallels.com>
In-Reply-To: <511369CC.6050405@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020714-5816-0000-0000-0000069665F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 02:46 AM, Glauber Costa wrote:
> On 02/06/2013 10:07 PM, Michael Wolf wrote:
>> On 02/06/2013 08:36 AM, Glauber Costa wrote:
>>> On 02/06/2013 01:49 AM, Michael Wolf wrote:
>>>> Add a helper routine to scheduler/core.c to allow the kvm module
>>>> to retrieve the cpu hardlimit settings.  The values will be used
>>>> to set up a timer that is used to separate the consigned from the
>>>> steal time.
>>> Sorry: What is the business of a timer in here?
>>> Whenever we read steal time, we know how much time has passed and with
>>> that information we can know the entitlement for the period. This breaks
>>> if we suspend, but we know that we suspended, so this is not a problem.
>> I may be missing something, but how do we know how much time has
>> passed?  That is why
>> I had the timer in there.  I will go look again at the code but I
>> thought the data was collected
>> as ticks and passed at random times.  The ticks are also accumulating so
>> we are looking at the
>> difference in the count between reads.....
> They can be collected at random times, but you can of course record the
> time in which it happened.
>
ok.  Let me add a previous_read field and take out the timer.

