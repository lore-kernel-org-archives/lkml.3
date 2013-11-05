Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3KETyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 14:54:54 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:51032 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab3KETyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 14:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131105151609.GA20950@kroah.com>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
	<20131105125228.GB18093@kroah.com>
	<CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
	<20131105151609.GA20950@kroah.com>
Date: Tue, 5 Nov 2013 13:54:51 -0600
Message-ID: <CAMP44s2BmZY2vQXQKsWmF68td8w9i4YNzp-o37ZN3YzsyZ3SWA@mail.gmail.com>
Subject: Re: [PATCH] staging: new asus fan driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 9:16 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 05, 2013 at 08:29:40AM -0600, Felipe Contreras wrote:
>> On Tue, Nov 5, 2013 at 6:52 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Nov 05, 2013 at 02:59:47AM -0600, Felipe Contreras wrote:
>> >> Simple driver to enable control of the fan in ASUS laptops. So far this
>> >> has only been tested in ASUS Zenbook Prime UX31A, but according to some
>> >> online reference [1], it should work in other models as well.
>> >>
>> >> The implementation is very straight-forward, the only caveat is that the
>> >> fan speed needs to be saved after it has been manually changed because
>> >> it won't be reported properly until it goes back to 'auto' mode.
>> >>
>> >> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
>> >>
>> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >> ---
>> >>
>> >> Two incarnations of this code exists [1][2], one that used ACPI methods
>> >> directly, and one through WMI. Unfortunately the WMI version needs us to pass
>> >> physicall addresses which is not exactly clean, and that's the only reason the
>> >> code is proposed for staging.
>> >>
>> >> Most likely this cannot graduate until acpica gets support to receive virtual
>> >> addresses.
>> >
>> > When is that going to happen?
>>
>> I don't know. Presumably when I get it done, which might be never, or
>> a few days from now. Most likely it will take some time.
>
> Then why not just merge this to the proper place, instead of relying on
> staging?  I don't want to have to have a staging driver that is waiting
> on external things to get it merged, instead of issues with the driver
> itself, as you are now putting the burden of maintenance on me, for no
> good reason other than you being too "lazy" to get other stuff done :)

*I* am too lazy? I am doing all the work. Nobody else is doing
anything about it.

Linux is throttling the CPU speed of this machine without trying to to
increase the fan speed first, that is not ideal.

So I do the first step of writing the fan driver and I get told it
shouldn't be a separate driver, it should be part of wmi, only to be
told later by the same person that it doesn't belong in wmi when I put
it there. Then I get told virt_to_physical() is not good, and it
should move to staging, and then I'm told you don't want it.

And at no point in time has anybody helped an iota to actually solve
the throttling problem.

So much for collaborative effort.

> So, I really don't want this driver, sorry, please merge it to the
> "proper" place in the kernel itself, fixing up the ACPI core to do so,
> or just living with the driver as-is if you don't want to do that
> work...

Forget it, I was hoping other people could use the driver while
somebody explains to me how to plug it o the thermal framework so it
gets activated when the machine gets hot, but clearly that's not going
to happen.

I have done my fair share of collaboration.

I'll just keep the driver for myself and figure out how to solve the
throttling by myself, which apparently I have to do anyway.

Cheers.

-- 
Felipe Contreras
