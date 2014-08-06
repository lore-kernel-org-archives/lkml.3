Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaHFV30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:29:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaHFV3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:29:24 -0400
Date: Wed, 6 Aug 2014 17:29:02 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Ping Cheng <pinglinux@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH] Input - wacom: update the ABI doc according to latest
 changes
Message-ID: <20140806212902.GD15018@mail.corp.redhat.com>
References: <1407252899-10293-1-git-send-email-benjamin.tissoires@redhat.com>
 <CAF8JNhKQAZz_a-=5qyqS4rgdv-8Lr=i=uKJMwz_iR4c7cq-cvg@mail.gmail.com>
 <20140805213436.GC29591@mail.corp.redhat.com>
 <CAF8JNhKR8uDB4AS5B00y-m7MCH6H8CHGegRb+W8ahS+gdtveNg@mail.gmail.com>
 <20140806204408.GC15018@mail.corp.redhat.com>
 <20140806210401.GB22889@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140806210401.GB22889@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 06 2014 or thereabouts, Dmitry Torokhov wrote:
> On Wed, Aug 06, 2014 at 04:44:08PM -0400, Benjamin Tissoires wrote:
> > On Aug 05 2014 or thereabouts, Ping Cheng wrote:
> > > On Tue, Aug 5, 2014 at 2:34 PM, Benjamin Tissoires
> > > <benjamin.tissoires@redhat.com> wrote:
> > > > Hi Ping,
> > > >
> > > > On Aug 05 2014 or thereabouts, Ping Cheng wrote:
> > > >> Thank you Benjamin for updating the ABI docs. My comments are inline.
> > > >>
> > > >> With those lines updated, this patch is:
> > > >>
> > > >> Reviewed-by: Ping Cheng <pingc@wacom.com>
> > > >
> > > > Thanks!
> > > >
> > > >>
> > > >> Cheers,
> > > >>
> > > >> Ping
> > > >>
> > > >> On Tue, Aug 5, 2014 at 8:34 AM, Benjamin Tissoires
> > > >> <benjamin.tissoires@redhat.com> wrote:
> > > >> > Now the devices show up under hid no matter the connection. So update the
> > > >> > sysfs path to the shortest and common one.
> > > >> > The ABI has also been unified regarding the OLEDs, but Bluetooth handle
> > > >> > only 1-bit images instead of 4.
> > > >> >
> > > >> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > >> > ---
> > > >> >
> > > >> > Guys,
> > > >> >
> > > >> > by updating this and working on the g-s-d client side for OLEDs, I think now
> > > >> > that we should also keep the oled*_img for Bluetooth and implement this file
> > > >> > for USB too. The user space code gets messy quite fast due to the need to
> > > >> > support old and new kernels, whereas if we handle the scrambling in the kernel,
> > > >> > it should be quite straightforward.
> > > >> > Of course, we have to keep the current button<n>_rawimg for backward
> > > >> > compatibility.
> > > >> >
> > > >> > Any thoughts?
> > > >> >
> > > >> > Cheers,
> > > >> > Benjamin
> > > >> >
> > > >> >  Documentation/ABI/testing/sysfs-driver-wacom | 56 ++++++++++------------------
> > > >> >  1 file changed, 20 insertions(+), 36 deletions(-)
> > > >> >
> > > >> > diff --git a/Documentation/ABI/testing/sysfs-driver-wacom b/Documentation/ABI/testing/sysfs-driver-wacom
> > > >> > index 7fc7810..c75ed4c 100644
> > > >> > --- a/Documentation/ABI/testing/sysfs-driver-wacom
> > > >> > +++ b/Documentation/ABI/testing/sysfs-driver-wacom
> > > >> > @@ -1,47 +1,26 @@
> > > >> > -WWhat:         /sys/class/hidraw/hidraw*/device/oled*_img
> > > >> > -Date:          June 2012
> > > >> > -Contact:       linux-bluetooth@vger.kernel.org
> > > >> > -Description:
> > > >> > -               The /sys/class/hidraw/hidraw*/device/oled*_img files control
> > > >> > -               OLED mocro displays on Intuos4 Wireless tablet. Accepted image
> > > >> > -               has to contain 256 bytes (64x32 px 1 bit colour). The format
> > > >> > -               is the same as PBM image 62x32px without header (64 bits per
> > > >> > -               horizontal line, 32 lines). An example of setting OLED No. 0:
> > > >> > -               dd bs=256 count=1 if=img_file of=[path to oled0_img]/oled0_img
> > > >> > -               The attribute is read only and no local copy of the image is
> > > >> > -               stored.
> > > >> > -
> > > >> > -What:          /sys/class/hidraw/hidraw*/device/speed
> > > >> > +What:          /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed
> > > >> >  Date:          April 2010
> > > >>
> > > >> Should the Date be updated?
> > > >
> > > > I don't think that this one should. The ABI is the same since April
> > > > 2010, and the "new" path works also for older kernels. So basically,
> > > > here, for Bluetooth, there has been no changes.
> > > 
> > > Oh, I see your point. But, don't we consider path part of the interface?
> > > 
> > 
> > Well, in this case, both the path /sys/class/hidraw/hidraw*/device/speed
> > and /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed refers to the same
> > device, even in April 2010.
> > 
> > /sys/class/hidraw/hidraw*/device is IMO not accurate because you have to
> > check all the hidraw devices to find the right one.
> > /sys/bus/hid/devices/<bus>:<vid>:<pid>.<n>/speed gives you the correct
> > at first sight. This is just a fix to have a more reliable path in the
> > documentation, not a change.
> 
> Can we document this in changelog?
> 

Hmm, yes. I guess I'll have to send a new version with this
documentation in the commit message and the update of the other dates.

I should be offline for the next 3 to 4 hours, so it will have to wait
tonight or tomorrow morning.

BTW, thanks for merging the rest of the series (and the various
patches). Greatly appreciated.

Cheers,
Benjamin

