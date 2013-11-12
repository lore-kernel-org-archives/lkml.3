Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3KLBHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:07:43 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:38937 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab3KLBHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:07:37 -0500
MIME-Version: 1.0
In-Reply-To: <20131112005628.GA2914@khazad-dum.debian.net>
References: <20131111235700.GA29987@july>
	<002901cedf3c$a7e77a00$f7b66e00$%han@samsung.com>
	<20131112005628.GA2914@khazad-dum.debian.net>
Date: Tue, 12 Nov 2013 10:07:36 +0900
X-Google-Sender-Auth: vFjISeIc3w1qUBvZulOhqKHuQIE
Message-ID: <CAH9JG2Wa_QXo3CZPmEyfDrHkZAGLVwhANoFAz6GZEC7mX48UGQ@mail.gmail.com>
Subject: Re: [PATCH] video: backlight: Remove backlight sysfs uevent
From: Kyungmin Park <kmpark@infradead.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kay@vrfy.org, Richard Purdie <rpurdie@rpsys.net>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 9:56 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 12 Nov 2013, Jingoo Han wrote:
>> On Tuesday, November 12, 2013 8:57 AM, Kyungmin Park wrote:
>> > From: Kyungmin Park <kyungmin.park@samsung.com>
>> >
>> > The most mobile phones have Ambient Light Sensors and it changes brightness according lux.
>> > It means it changes backlight brightness frequently by just writing sysfs node, so it generates uevent.
>> >
>> > Usually there's no user to use this backlight changes. But it forks udev worker threads and it takes
>> > about 5ms. The main problem is that it hurts other process activities. so remove it.
>> >
>> > Kay said
>> > "Uevents are for the major, low-frequent, global device state-changes,
>> >  not for carrying-out any sort of measurement data. Subsystems which
>> >  need that should use other facilities like poll()-able sysfs file or
>> >  any other subscription-based, client-tracking interface which does not
>> >  cause overhead if it isn't used. Uevents are not the right thing to
>> >  use here, and upstream udev should not paper-over broken kernel
>> >  subsystems."
>
> True.
>
> Now, let's take a look at reality: should you poll()/select() on a sysfs
> node that doesn't suport it, it will wait until the poll/select timeout
> happens (or EINTR happens), and userspace has absolutely NO way to detect
> whether a sysfs node has poll/select support.
>
> What happens if the sysfs interface did not provide poll/select support
> since day one, but rather added it later?  Nobody will use it for a *long*
> time, if ever... unless you actually took pains to version the sysfs
> interface, and people actually care.
>
>> 'thinkpad_acpi.c' uses the 'BACKLIGHT_UPDATE_SYSFS'.
>> Henrique, can we remove it?
>
> Can't you fix this by rate-limiting, or otherwise adding an attribute that
> backlight devices should set when they need to supress change events?

other way is that just remove sysfs node store update then you can use
current API, force_update as is.

are there any other good ideas?

Thank you,
Kyungmin Park
>
> Is there a proper on-screen-display support path for the backlight class
> nowadays?  Otherwise, you'd be removing the only way userspace ever had to
> do proper OSD of backlight changes...
>
> --
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
