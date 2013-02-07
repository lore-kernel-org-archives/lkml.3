Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3BGIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:45:46 -0500
Received: from mx2.parallels.com ([64.131.90.16]:47534 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208Ab3BGIpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:45:45 -0500
Message-ID: <511369CC.6050405@parallels.com>
Date: Thu, 7 Feb 2013 12:46:04 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Michael Wolf <mjw@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <riel@redhat.com>, <gleb@redhat.com>,
        <kvm@vger.kernel.org>, <peterz@infradead.org>, <mtosatti@redhat.com>,
        <mingo@redhat.com>, <anthony@codemonkey.ws>
Subject: Re: [PATCH 4/4] Add a timer to allow the separation of consigned
 from steal time.
References: <20130205214818.4615.12937.stgit@lambeau> <20130205214941.4615.29852.stgit@lambeau> <51126A84.5050005@parallels.com> <51129BEA.6090302@linux.vnet.ibm.com>
In-Reply-To: <51129BEA.6090302@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 10:07 PM, Michael Wolf wrote:
> On 02/06/2013 08:36 AM, Glauber Costa wrote:
>> On 02/06/2013 01:49 AM, Michael Wolf wrote:
>>> Add a helper routine to scheduler/core.c to allow the kvm module
>>> to retrieve the cpu hardlimit settings.  The values will be used
>>> to set up a timer that is used to separate the consigned from the
>>> steal time.
>> Sorry: What is the business of a timer in here?
>> Whenever we read steal time, we know how much time has passed and with
>> that information we can know the entitlement for the period. This breaks
>> if we suspend, but we know that we suspended, so this is not a problem.
> I may be missing something, but how do we know how much time has
> passed?  That is why
> I had the timer in there.  I will go look again at the code but I
> thought the data was collected
> as ticks and passed at random times.  The ticks are also accumulating so
> we are looking at the
> difference in the count between reads.....

They can be collected at random times, but you can of course record the
time in which it happened.

