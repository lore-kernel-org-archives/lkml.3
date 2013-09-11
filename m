Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab3IKBAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 21:00:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:26842 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab3IKBAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 21:00:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,881,1371106800"; 
   d="scan'208";a="401501532"
Message-ID: <522FC0DC.9030708@intel.com>
Date: Wed, 11 Sep 2013 09:01:16 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Mark Brown <broonie@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C client
 devices
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com> <3397524.g9aUWuArnm@vostro.rjw.lan> <20130910213522.GG29403@sirena.org.uk> <2029393.u6DaKBPszu@vostro.rjw.lan>
In-Reply-To: <2029393.u6DaKBPszu@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 06:32 AM, Rafael J. Wysocki wrote:
> On Tuesday, September 10, 2013 10:35:22 PM Mark Brown wrote:
>> On Tue, Sep 10, 2013 at 10:04:21PM +0200, Rafael J. Wysocki wrote:
>>> On Tuesday, September 10, 2013 05:13:21 PM Mark Brown wrote:
>>
>>>> OK, that is very much not the model which embedded systems follow, in
>>>> embedded systems the driver for the device is fully in control of its
>>>> own power.  It gets resources like GPIOs and regulators which allow it
>>>> to make fine grained decisions.
>>
>>> There are platforms where those resources are simply not available for
>>> direct manipulation and we need to use ACPI methods for power management.
>>
>>> Now, since those methods are used in pretty much the same way for all I2C
>>> devices, we add a PM domain for that to avoid duplicating the same code in
>>> all of the drivers in question (patch [2/2]).  Does that make sense to you?
>>
>> It doesn't seem like a particular problem, but the existing usage does
>> need to be preserved for the systems that use it so things like having
>> auto as the default and updating the drivers seem like they're needed.
>>
>>>> If we're starting to get a reasonable number of buses following the same
>>>> pattern it seems like we're in a position to start 
>>
>>> We need that for exactly 3 buses: platform (already done), I2C and SPI.
>>
>>> No other bus types are going to use ACPI this way for PM, at least for the
>>> time being, simply because PCI, USB and SATA/IDE have their own ways of doing
>>> this (which are bus-specific) and the spec doesn't cover other bus types
>>> directly (it defines support for UART, but we don't have a UART bus type).
>>
>>> Moreover, because PCI and USB use ACPI for PM in their own ways, moving that
>>> thing up to the driver core would be rather inconvenient.
>>
>> That only applies to the power domains though, what Mika was saying was
>> that the process for enabling runtime PM (just drop a reference) also
>> becomes easier with this method regardless of anything else - that makes
>> sense to me as something we might want to end up with so do we want to
>> just move towards making that a default?
> 
> Possibly. :-)
> 
> At least I don't see any fundamental obstacles ...

Looks like, it all boils down to how many I2C devices should be allowed
for runtime PM by default and how many I2C devices should be forbidden.
, and then we allow/forbid runtime PM for the majority case in I2C core
while individual driver can still forbid/allow it in their own code.

So if the majority case is runtime PM should be allowed by default, I'm
also OK to not forbid runtime PM for I2C client device in I2C core. My
original intention to forbid runtime PM by default is to make sure no
adverse effect would occur to some I2C devices that used to work well
before runtime PM.

Thanks,
Aaron
