Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3FSRiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:38:54 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56227 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757279Ab3FSRiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:38:50 -0400
Message-ID: <51C1ECA7.3030001@linaro.org>
Date: Wed, 19 Jun 2013 10:38:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com> <1371655523-15609-3-git-send-email-david.vrabel@citrix.com> <51C1E1B6.8090203@linaro.org> <20130619171321.GE13046@phenom.dumpdata.com>
In-Reply-To: <20130619171321.GE13046@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 10:13 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 19, 2013 at 09:52:06AM -0700, John Stultz wrote:
>> On 06/19/2013 08:25 AM, David Vrabel wrote:
>>> From: David Vrabel <david.vrabel@citrix.com>
>>>
>>> The high resolution timer code gets notified of step changes to the
>>> system time with clock_was_set() or clock_was_set_delayed() calls.  If
>>> other parts of the kernel require similar notification there is no
>>> clear place to hook into.
>>>
>>> Add a clock_was_set atomic notifier chain
>>> (clock_was_set_notifier_list) and call this in place of
>>> clock_was_set().  If the timekeeping locks are held, the calls are
>>> deferred to a new tasklet.
>>>
>>> The hrtimer code adds a notifier block to this chain and uses it to
>>> call (the now internal) clock_was_set().  Since the timekeeping code
>>> does not call the chain from the timer irq clock_was_set_delayed() and
>>> associated code can be removed.
>> So on my initial quick review, this *looks* pretty reasonable. I get
>> a little worried about interface abuse (ie: random drivers trying to
>> hook into clock_was_set_notifier_list), but we can move that into
>> timekeeper_internal.h or something similar to limit that.
>>
>> The other issue here is we've been burned pretty badly in the past
>> with changes to clock_was_set(), as its key to keeping timers in
>> line with timekeeping.  So this will need a fair amount of testing
>> and run time before this gets merged, so 3.12 is what we'd be
>> targeting at the earliest (its getting a bit late for taking changes
>> for 3.11 anyway).
> I think we have four weeks left? Or you think Linus is going to release
> at the end of the month?

Well, I have to queue it, and then get Thomas to pull it from me, and 
that can take some time. And after -rc6 there's just not a lot of time 
for things to get testing in -next before being pushed to Linus. Its 
just a bit rushed for me.


>> If you want to try to push patch 1/4 in for 3.11 via the Xen tree,
> Done.
>> I'll see about queuing the other three for hopefully 3.12.
> OK, let me run them through the testing gauntleet to have the
> warm fuzzy feeling.

Thanks.  I'll be running it through my test cases as well.

-john
