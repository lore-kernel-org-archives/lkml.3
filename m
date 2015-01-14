Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbbANQcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:32:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:25315 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbbANQck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:32:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="651073738"
Message-ID: <54B69A29.6060201@linux.intel.com>
Date: Wed, 14 Jan 2015 08:32:41 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Arnd Bergmann <arnd@arndb.de>
CC: Alexandre Courbot <gnurou@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ortiz, Samuel" <samuel.ortiz@intel.com>
Subject: Re: [RFC PATCH] gpio: support for GPIO forwarding
References: <1418890998-23811-1-git-send-email-heikki.krogerus@linux.intel.com> <CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
In-Reply-To: <CACRpkdY-yFKsYbCrMpnViMFoQEugyGQivaV0M+GDzLrbDO7i6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, Samuel actually Cc'd this time...

On 1/14/15 4:58 AM, Linus Walleij wrote:
> On Thu, Dec 18, 2014 at 9:23 AM, Heikki Krogerus
> <heikki.krogerus@linux.intel.com> wrote:
> 
>> This makes it possible to assign GPIOs at runtime. The
>> motivation for it is because of need to forward GPIOs from
>> one device to an other. That feature may be useful for
>> example with some mfd devices, but initially it is needed
>> because on some Intel Braswell based ACPI platforms the GPIO
>> resources controlling signals of the USB PHY are given to
>> the controller device object for whatever reason, so the
>> driver of that controller needs be able to pass them to the
>> PHY device somehow.
>>
>> So basically this is meant to allow patching of bad (bad
>> from Linux kernels point of view) hardware descriptions
>> provided by system fw in the drivers.
>>
>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> ---
>>
>> Hi,
>>
>> I'm sending this first as a RFC in case you guys have some better
>> idea how to solve our problem. I actually already have couple
>> platforms where the GPIO resources are given to the "wrong" device
>> objects now.
>>
>> Originally we were thinking about simply handling our problem with
>> hacks to the PHY drivers, basically also checking if the parent has
>> GPIOs. That would only work if the controller is always the parent,
>> which it's not, but even if it was, it would be too risky. The PHY
>> drivers don't know which controller they are attached to, so what is
>> to say that the GPIOs aren't really attached to the controller.
>>
>> So the safest way to handle our problem is to deal with it in quirks
>> in the controller drivers. Solving it by bouncing the GPIOs did not
>> feel ideal there doesn't seem to be any other way. The API is copied
>> from clkdev (clk_register_clkdev). In the end it's really only one
>> function for adding the lookups and one for removing them.
>>
>> The way it's implemented is by modifying the current style of handling
>> the lookups a little bit. The per device lookup table is basically
>> reverted back to the single linked-list format since it seems that
>> these lookups may have to be assigned from several sources.
> 
> Oh ain't that great.
> 
> So now we start patching around the kernel because the ACPI
> tables are erroneous for GPIOs. I'd like some feedback from
> Rafael &| Darren on this patch, i.e. if you two think this is a good
> way of accounting for bad GPIO descriptions in ACPI tables then
> ACK this patch.
> 
> I guess the other option would be to fix up the ACPI DSDT
> itself to put resources right, correct? Is this not possible?
> 
> Alexandre also need to ACK it before I dare do anything with
> it.
> 
> Do we want to use the same mechanism for augmenting
> bad device trees too?
> 
> What I like about it so far is the create/remove symmetry
> though.
> 
> Yours,
> Linus Walleij
> 

-- 
Darren Hart
Intel Open Source Technology Center
