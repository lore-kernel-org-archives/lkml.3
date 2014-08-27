Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbaH0XPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:15:45 -0400
Received: from relay1.sgi.com ([192.48.180.66]:58476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301AbaH0XPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:15:42 -0400
Message-ID: <53FE6690.80608@sgi.com>
Date: Wed, 27 Aug 2014 16:15:28 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, msalter@redhat.com,
        dyoung@redhat.com, riel@redhat.com, peterz@infradead.org,
        mgorman@suse.de, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/2] x86: Speed up ioremap operations
References: <20140827225927.364537333@asylum.americas.sgi.com> <20140827160610.4ef142d28fd7f276efd38a51@linux-foundation.org>
In-Reply-To: <20140827160610.4ef142d28fd7f276efd38a51@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 8/27/2014 4:06 PM, Andrew Morton wrote:
> On Wed, 27 Aug 2014 17:59:27 -0500 Mike Travis <travis@sgi.com> wrote:
> 
>>
>> We have a large university system in the UK that is experiencing
>> very long delays modprobing the driver for a specific I/O device.
>> The delay is from 8-10 minutes per device and there are 31 devices
>> in the system.  This 4 to 5 hour delay in starting up those I/O
>> devices is very much a burden on the customer.
> 
> That's nuts.

Exactly!  The customer was (as expected) not terribly pleased... :)
> 
>> There are two causes for requiring a restart/reload of the drivers.
>> First is periodic preventive maintenance (PM) and the second is if
>> any of the devices experience a fatal error.  Both of these trigger
>> this excessively long delay in bringing the system back up to full
>> capability.
>>
>> The problem was tracked down to a very slow IOREMAP operation and
>> the excessively long ioresource lookup to insure that the user is
>> not attempting to ioremap RAM.  These patches provide a speed up
>> to that function.
> 
> With what result?
> 

Early measurements on our in house lab system (with far fewer cpus
and memory) shows about a 60-75% increase.  They have a 31 devices,
3000+ cpus, 10+Tb of memory.  We have 20 devices, 480 cpus, ~2Tb of
memory.  I expect their ioresource list to be about 5-10 times longer.
[But their system is in production so we have to wait for the next
scheduled PM interval before a live test can be done.]

