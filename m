Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3LTCih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:38:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40441 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab3LTCig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:38:36 -0500
Date: Thu, 19 Dec 2013 21:38:20 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-kernel@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk,
        arnd@arndb.de, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] misc: Reserve minor for VFIO
Message-ID: <20131220023820.GG25322@phenom.dumpdata.com>
References: <20131218204024.30540.55302.stgit@bling.home>
 <20131218210141.GA11267@kroah.com>
 <52B21B7E.1020307@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B21B7E.1020307@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:02:38PM -0800, H. Peter Anvin wrote:
> On 12/18/2013 01:01 PM, Greg KH wrote:
> > On Wed, Dec 18, 2013 at 01:56:32PM -0700, Alex Williamson wrote:
> >> VFIO currently allocates it's own dynamic chardev range, reserving the
> >> first minor for the control part of the interface (/dev/vfio/vfio) and
> >> the remainder for VFIO groups (/dev/vfio/$GROUP).  This works, but it
> >> doesn't support auto loading.  For instance when libvirt checks for
> >> VFIO support it looks for /dev/vfio/vfio, which currently doesn't
> >> exist unless the vfio module is loaded.  By converting the control
> >> device to a misc driver and reserving a static minor, we can enable
> >> auto loading.

Why not have libvirt or systemctl try to load vfio first? If it does
not work it would error out.

Or perhaps make the loading of modules in /dev/vfio automatic? I thought
it was based on the name?

> >>
> >> Reserving the minor is a prerequist to that conversion.  Minor 196
> >> is unused by anything currently in the kernel.
> >>
> >> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> >> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >> ---
> >>
> >> v2: Plea for ack edition
> >>
> >> As Alan suspected, there's been no response from device@lanana.org,
> >> so there's probably nobody monitoring it anymore.  I've done due
> >> diligence looking at all the callers of misc_register() in linux-next
> >> and cannot find any conflicts with minor 196.  If anyone wants to toss
> >> me an ack or sign-off I'll be happy to bring this in through my vfio
> >> tree, otherwise I'd appreciate if someone wants to take it directly.
> >> Thanks!
> >>
> >>  Documentation/devices.txt  |    1 +
> >>  include/linux/miscdevice.h |    1 +
> >>  2 files changed, 2 insertions(+)
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> 
> I think Alan Cox was the last person to man <device@lanana.org>... Alan,
> are you still doing that?  (Otherwise patching the file in the Linux
> kernel tree seems eminently sensible... there really isn't any need to
> reserve numbers for out-of-tree drivers anymore.  Just another perk of
> being in-tree.)
> 
> 	-hpa
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
