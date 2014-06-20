Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967123AbaFTVeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:34:18 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55833 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486AbaFTVeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:34:16 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Allen Yu <alleny@nvidia.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pm\@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] PM / Runtime: let rpm_resume fail if rpm disabled and device suspended.
References: <Pine.LNX.4.44L0.1406201043420.1160-100000@iolanthe.rowland.org>
Date: Fri, 20 Jun 2014 14:34:14 -0700
In-Reply-To: <Pine.LNX.4.44L0.1406201043420.1160-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri, 20 Jun 2014 10:48:09 -0400 (EDT)")
Message-ID: <7h4mzftgdl.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Fri, 20 Jun 2014, Rafael J. Wysocki wrote:
>
>> > For a general device, the fact that dev->power.is_suspended is set
>> > means the device _has_ been powered down.  Even though the
>> > runtime_status may not have changed, the PM core has to assume the
>> > device is not available for use.
>> 
>> This seems to go a bit too far.  What power.is_suspended actually means is
>> that __device_suspend() has run for the device successfully.  What the
>> implications of that are depends on the bus type (or subsystem in general)
>> and device driver.
>> 
>> > While your I2C devices may be useable even after the ->suspend callback
>> > returns, for most devices this isn't true.  So we shouldn't allow
>> > rpm_resume() to return imediately when is_suspended is set.
>> 
>> I can agree with that.
>
> We really do need to decide more precisely how runtime PM and system PM 
> will interact.  

Yes!

> Should ->runtime_resume callbacks be allowed after ->suspend has
> returned?

Abolutely.

> Kevin has stated that some devices do need this ability.  But most
> don't.  

Does it matter if most don't?  As long a some do, we need to support
this.  It may not be "most" devices, but on the (mostly embedded) SoCs I
work on, the devices that do need this tend to be rather crucial core
devices that are used during the PM of other devices (e.g. I2C, SPI,
GPIOs, etc. etc.)

> The PM core needs to handle these conflicting requirements
> somehow.

I agree.  We've gone back and forth a few times on the various
interactions between system PM and runtime PM over the years but it
seems there are still things to clarify.

Kevin
