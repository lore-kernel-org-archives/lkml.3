Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaFDWam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 18:30:42 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64780 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaFDWak convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 18:30:40 -0400
MIME-Version: 1.0
In-Reply-To: <538F18B6.7070102@ti.com>
References: <1401313610-14252-1-git-send-email-nm@ti.com>
	<1401313610-14252-3-git-send-email-nm@ti.com>
	<CANOLnOPb1xbqb5WXaK5-kdCezVuDhNxTtE5VV_MbCi4WTd2=oA@mail.gmail.com>
	<538F18B6.7070102@ti.com>
Date: Thu, 5 Jun 2014 01:30:40 +0300
Message-ID: <CANOLnOMbjpLd2mGcTRcR-+jcp80H1z7g4-eZ6yMJvovEB2__RQ@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] power: twl4030_charger: attempt to power off in
 case of critical events
From: Grazvydas Ignotas <notasas@gmail.com>
To: Nishanth Menon <nm@ti.com>
Cc: dbaryshkov@gmail.com, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        dwmw2@infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 4:01 PM, Nishanth Menon <nm@ti.com> wrote:
> On 06/04/2014 05:04 AM, Grazvydas Ignotas wrote:
>> On Thu, May 29, 2014 at 12:46 AM, Nishanth Menon <nm@ti.com> wrote:
>>> Attempt to power off in case of critical events such as battery removal,
>>> over voltage events.
>>>
>>> There is no guarentee that we'd be in a safe scenario here, but the very
>>> least we can try to do is to power off the device to prevent damage to
>>> the system instead of just printing a message and hoping for the best.
>>
>> At least "battery temperature out of range" does seem to happen quite
>> often while charging on hot summer day. I'd prefer my pandora to not
>> shutdown in such case, it could just stop charging instead.
> Yeah, We could call
>   twl4030_charger_enable_ac(false);
>   twl4030_charger_enable_usb(bci, false);
>
> But then, is that sufficient?
> From the TRM:
> 7.5.8 Battery Temperature Out-of-Range Detection
> Battery temperature out-of-range detection detects whether the battery
> temperature is within a specific
> range. Detection is possible for two temperature ranges. When the
> battery temperature is not in the
> 2–50°C range or is in the 3–43°C range, the TBATOR1 and TBATOR2 status
> bits rise and an interrupt is
> generated.
> This MADC monitoring function can be enabled by writing to the
> TBATOR1EN (BCIMFEN2[3]) and
> TBATOR2EN (BCIMFEN2[1]) fields.
>
> Battery pack at high temperature is a risk, no? and it may not be just
> charger that might be causing such a condition. Is'nt it safer to shut
> the device down in such a case?

I don't know, so far nobody has complained about the battery exploding
and anybody getting hurt, but it would make the device unusable for
people in hot climates. From what I remember the automatic charge is
stopped automatically on this condition, as some people complained
they couldn't charge their device and saw these messages in dmesg. I
guess mainline could choose the safer option and shutdown, no strong
opinion about this.

-- 
Gražvydas
