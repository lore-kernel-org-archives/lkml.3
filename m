Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaJOOqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:46:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:45798 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaJOOqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,724,1406617200"; 
   d="scan'208";a="614929469"
Message-ID: <543E88CF.5060504@linux.intel.com>
Date: Wed, 15 Oct 2014 16:46:39 +0200
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, Mark Rutland <mark.rutland@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, dvhart@infradead.org
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
References: <2660541.BycO7TFnA2@vostro.rjw.lan>    <1413378271.2762.77.camel@infradead.org>    <20141015131551.GC20034@leverpostej>    <1413379736.2762.79.camel@infradead.org>    <20141015134209.GD20034@leverpostej> <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
In-Reply-To: <db4038336b5e165b8b61eda064b10eeb.squirrel@twosheds.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/15/14 16:08, David Woodhouse wrote:
> 
>> We have been checking for all DT platforms, and that's a bug for DT.
>> Copying that bug to ACPI is inexcusable given we know it's a bug to do
>> so.
> 
> We'll, perhaps it should be named 'used-by-firmware' and actually it's
> just as valid under ACPI as it is on RTAS systems. All it does is stop the
> OS from using the port.
> 
>> I understand that. However, where a binding doesn't make sense (as in
>> this case), it shouldn't be enabled for ACPI as it provides a larger
>> surface area for misuse, for no benefit.
> 
> These are *optional* properties. They were optional precisely *because*
> they only make sense in some cases. I don't know that it makes sense to
> take them away. The benefit we get is *consistency*. For example if
> someone *does* use the property in question as 'used-by-firmware' and
> expects the OS not to touch it, we don't want that to change behaviour
> between ACPI and fdt boots.

My comment was going to be along the same lines. It is an optional
parameter, which is what I would expect for a firmware-specific type of
property.

I also don't agree that this is "copying that bug to ACPI". This line of
code has no impact to ACPI. No ACPI implementation should add this,
certainly not if it was actually tested as it would not run if it was
present in the _DSD. So... what's the problem exactly? Or perhaps more
specifically:

Mark, what would you propose we do differently to enable this driver to
be firmware-type agnostic?

-- 
Darren Hart
Intel Open Source Technology Center
