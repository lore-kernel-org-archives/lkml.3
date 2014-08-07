Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbaHGSQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:16:17 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44431 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaHGSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:16:15 -0400
Date: Thu, 7 Aug 2014 11:16:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Goffredo Baroncelli <kreijack@inwind.it>
Cc: Jean Delvare <jdelvare@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] Export the temperatures via hwmon
Message-ID: <20140807181611.GA7679@roeck-us.net>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
 <1407359103-6012-6-git-send-email-kreijack@inwind.it>
 <20140806231803.GA5643@roeck-us.net>
 <53E31694.8050107@gmail.com>
 <53E31AB0.6070604@roeck-us.net>
 <20140807085235.2c0e63dd@endymion.delvare>
 <53E32C77.5000804@roeck-us.net>
 <53E3BC48.4020304@inwind.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E3BC48.4020304@inwind.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 07:50:00PM +0200, Goffredo Baroncelli wrote:
> On 08/07/2014 09:36 AM, Guenter Roeck wrote:
> > On 08/06/2014 11:52 PM, Jean Delvare wrote:
> >> Hi Guenter,
> >>
> >> On Wed, 06 Aug 2014 23:20:32 -0700, Guenter Roeck wrote:
> >>> Patch 4/5 is "Return the fan speed via sysfs: /sys/devices/temperature/fan_level".
> >>>
> >>> So you are saying that returning the fan speed with a non-hwmon attribute works,
> >>> but returning it with a hwmon attribute doesn't ? Not really sure if I understand
> >>> your logic. Either fan_level doesn't return the fan speed (or an abstraction of it),
> >>> or something in your line of argument is inconsistent.
> >>
> >> fan_level is a fan speed _control_ value, like pwm1. It is not a fan
> >> speed monitoring value.
> >>
> > Ah, ok. The patch description doesn't seem to match, though.
> > And why not export it as pwm1, if that is what it is ?
> > 
> > Guenter
> > 
> > 
> 
> the exported fan_level value is a coefficient near proportional to the speed [*];
> so it is not the speed nor the pwm.
> I tried to read the pwm/speed value, but when I did it, every 5/6 seconds the
> fan seemed to stop for 1s, then the speed raised.... So I stopped the test.
> 
> These patches (the first two) solved a real issue: with the last kernels this
> driver doesn't work at all, and the fan go to maximum speed (very loud !)
> The other three are an improvement.
> 
> When (if) these patches will be accepted I want to write another solution,
> but definitely not now. And even if it would work for me, it is very likely 
> that will  be accepted because nobody is able to test it on all hardware.
> 
Might have been easier to just drop all this non-standard code and instantiate
the adm1030 using the adm1031 driver instead.

Guenter
