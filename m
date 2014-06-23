Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbaFWXfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:35:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:56218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864AbaFWXfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:35:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="356846789"
Message-ID: <53A8B9D2.8090705@linux.intel.com>
Date: Tue, 24 Jun 2014 07:35:46 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] GPIO button wth wakeup attribute is supposed to wake
 the system up
References: <53A2340D.9030503@linux.intel.com> <20140619114006.72ac8e06@alan.etchedpixels.co.uk>
In-Reply-To: <20140619114006.72ac8e06@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On 2014/6/19 18:40, One Thousand Gnomes wrote:
> On Thu, 19 Jun 2014 08:51:25 +0800
> "Li, Aubrey" <aubrey.li@linux.intel.com> wrote:
> 
>> When the wakeup attribute is set, the GPIO button is capable of
>> waking up the system from sleep states, including the "freeze"
>> sleep state.  For that to work, its driver needs to pass the
>> IRQF_NO_SUSPEND flag to devm_request_any_context_irq(), or the
>> interrupt will be disabled by suspend_device_irqs() and the
>> system won't be woken up by it from the "freeze" sleep state.
>>
>> The suspend_device_irqs() routine is a workaround for drivers
>> that mishandle interrupts triggered when the devices handled
>> by them are suspended, so it is safe to use IRQF_NO_SUSPEND in
>> all drivers that don't have that problem.
>>
>> The affected/tested machines include Dell Venue 11 Pro and Asus T100TA.
>>
>> Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
>> Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Reviewed-by: Alan Cox <alan@linux.intel.com>
> 
> 
> 

