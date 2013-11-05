Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab3KEPN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:13:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55729 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab3KEPN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:13:57 -0500
Date: Tue, 5 Nov 2013 07:16:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] staging: new asus fan driver
Message-ID: <20131105151609.GA20950@kroah.com>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
 <20131105125228.GB18093@kroah.com>
 <CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 08:29:40AM -0600, Felipe Contreras wrote:
> On Tue, Nov 5, 2013 at 6:52 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Nov 05, 2013 at 02:59:47AM -0600, Felipe Contreras wrote:
> >> Simple driver to enable control of the fan in ASUS laptops. So far this
> >> has only been tested in ASUS Zenbook Prime UX31A, but according to some
> >> online reference [1], it should work in other models as well.
> >>
> >> The implementation is very straight-forward, the only caveat is that the
> >> fan speed needs to be saved after it has been manually changed because
> >> it won't be reported properly until it goes back to 'auto' mode.
> >>
> >> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
> >>
> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >> ---
> >>
> >> Two incarnations of this code exists [1][2], one that used ACPI methods
> >> directly, and one through WMI. Unfortunately the WMI version needs us to pass
> >> physicall addresses which is not exactly clean, and that's the only reason the
> >> code is proposed for staging.
> >>
> >> Most likely this cannot graduate until acpica gets support to receive virtual
> >> addresses.
> >
> > When is that going to happen?
> 
> I don't know. Presumably when I get it done, which might be never, or
> a few days from now. Most likely it will take some time.

Then why not just merge this to the proper place, instead of relying on
staging?  I don't want to have to have a staging driver that is waiting
on external things to get it merged, instead of issues with the driver
itself, as you are now putting the burden of maintenance on me, for no
good reason other than you being too "lazy" to get other stuff done :)

So, I really don't want this driver, sorry, please merge it to the
"proper" place in the kernel itself, fixing up the ACPI core to do so,
or just living with the driver as-is if you don't want to do that
work...

greg k-h
