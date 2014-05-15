Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaEORf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:35:56 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:49016 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaEORfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:35:53 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
References: <Pine.LNX.4.44L0.1405131139510.1098-100000@iolanthe.rowland.org>
Date: Thu, 15 May 2014 10:35:51 -0700
In-Reply-To: <Pine.LNX.4.44L0.1405131139510.1098-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 13 May 2014 11:46:55 -0400 (EDT)")
Message-ID: <7hiop7ymfc.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> On Tue, 13 May 2014, Rafael J. Wysocki wrote:
>
>> > A wakeup request from the hardware could cause a runtime resume to 
>> > occur at this time.  The barrier wouldn't prevent that.
>> > 
>> > It's unlikely, I agree, but not impossible.
>> 
>> Yeah, I didn't think about that.
>
> Come to think of it, if the hardware sends a wakeup request then it
> must have been enabled for remote wakeup.  And if the hardware settings
> are appropriate for system suspend then it must be enabled for system
> wakeup.  Consequently a wakeup from the hardware ought to abort the
> system suspend in any case.  So maybe we don't care about this 
> scenario.
>
> On the other hand, there may be other mechanisms that could cause a 
> runtime resume at this inconvenient time.  A timer routine, for 
> instance.

Another common case is when device X depends on device Y in it's
->prepare or ->suspend path (e.g. need to write to an I2C connected
GPIO/PMIC) in which case, device Y (and the I2C bus) would be runtime
resumed during device X's ->prepare or ->suspend path, and possibly
after device Y (or the I2C busses) ->prepare and ->suspend.

Kevin
