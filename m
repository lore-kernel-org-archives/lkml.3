Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758297Ab3DXVZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:25:40 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41374 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab3DXVZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:25:38 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <Pine.LNX.4.44L0.1304241715170.1548-100000@iolanthe.rowland.org>
References: <CA+icZUVkRCavG-gs6r2x_kyZe_Mm8WLewp-zpKn=f3GWU+jJZw@mail.gmail.com>
	<Pine.LNX.4.44L0.1304241715170.1548-100000@iolanthe.rowland.org>
Date: Wed, 24 Apr 2013 23:25:36 +0200
Message-ID: <CA+icZUVHvO-fzqwdTHNa_ijHSuxFaoZVKdS=TDH2CQXYYARdjQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 11:17 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 24 Apr 2013, Sedat Dilek wrote:
>
>> > Did this work differently under earlier kernels?
>> >
>>
>> Unfortunately, s/r did not work for several Linux-Next releases as
>> there is missing tglx's patch pendinging in tip.git/timers/core.
>
> Have you tried testing under 3.8?  Or earlier releases?
>
>> > This indicates that the optical mouse didn't survive the suspend/resume
>> > sequence and had to be reenumerated.  Without more information, there's
>> > no way to tell specifically what went wrong during the initial reset at
>> > timestamp 62.353997.
>> >
>> > If you want to pursue this farther, you could enable CONFIG_USB_DEBUG.
>> > You could also collect a usbmon trace for bus 1 showing what happens
>> > during the suspend and resume.
>> >
>>
>> Hmm, I can try to enable CONFIG_USB_DEBUG and build a new kernel.
>>
>> Can you give me more hints how to do a usbmon-trace?
>
> See Documentation/usb/usbmon.txt.
>

Grrr, that docs do not mention which kernel-configs have to be set!

CONFIG_USB_DEBUG=y is not enough.

# modprobe -v usbmon
FATAL: Module usbmon not found.

# CONFIG_USB_MON is not set <--- Grrr!!!

Doing a -4 build...

- Sedat -

>> > On the other hand, what difference does it really make if a mouse has
>> > to be reenumerated?
>> >
>>
>> As a non-USB-expert it's hard to interprete such "bogus" lines in your logs.
>> I am curious enough to ask which is fair :-).
>> AFAICS in your eyes this is "harmless"?
>
> If the device continues to work normally after the resume and none of
> your programs are affected, then it is harmless.
>
> Alan Stern
>
