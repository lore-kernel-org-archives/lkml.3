Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676Ab3GaA2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:28:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25099 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756990Ab3GaA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:28:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,782,1367996400"; 
   d="scan'208";a="65803387"
X-IronPort-AV: E=Sophos;i="4.89,782,1367996400"; 
   d="scan'208";a="522883003"
Date: Tue, 30 Jul 2013 17:27:44 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
        Hector Palacios <hector.palacios@digi.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "gustavo@padovan.org" <gustavo@padovan.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        <mcgrof@do-not-panic.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "surajs@qca.qualcomm.com" <surajs@qca.qualcomm.com>,
        <jjohnson@qca.qualcomm.com>, Adrian Chadd <adrian@freebsd.org>,
        <ddahlby@qca.qualcomm.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: ROM Patching (was: [PATCH] bluetooth: remove wrong dependency
 for BT_ATH3K)
Message-ID: <20130731002744.GT17130@pogo>
References: <1375114325-25498-1-git-send-email-hector.palacios@digi.com>
 <5438CD3C-E28C-485C-94B8-F743E8B13D4A@holtmann.org>
 <51F7722E.9050708@digi.com>
 <20130730205601.GI17130@pogo>
 <2C94C740-76BA-4058-B0D7-C37D44875CA1@holtmann.org>
 <20130730224809.GN17130@pogo>
 <20130730235508.GA25319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130730235508.GA25319@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 04:55:08PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 30, 2013 at 03:48:09PM -0700, Luis R. Rodriguez wrote:
> > > We are planning to take one extra step and split this into a
> > > mini-driver approach similar to what has been done for usbnet, but we
> > > are not there yet.
> > 
> > Neat. Perhaps we need something that we can share with 802.11 or other
> > hardare I highly doubt we're the only ones patching ROM. Don't we even
> > patch up core CPUs? I'm wondering if firmware_class could be expanded to
> > support serialized ROM patching. The biggest hurdle I see with splititng
> > ROM patching from a single firmware is serializing that, addressing
> > revision dependencies and of course kernel dependencies.
> 
> What does the firmware_class need to do here that it doesn't do today?

It will depend on the requirements for ROM patches and if or not
firmware can be split up into patches rather than getting a full
firmware.fw update for any single patch update. If ROM patches
get split up then how I can imagine driver code firmware getting
to become a pain in the ass to maintain and nasty. It'd seem
better to build relationships between these and possible patch
depdendencies on ROM and let firmware_class do the management
of that.

> > > However the ROM patching drivers need to be in the kernel since
> > > otherwise they will race with the core init sequence.
> > 
> > Sure and depending on the architecture -- if this is kicked off to
> > userspace helpers or not then we may need to consider dbus in
> > kernel thing to help with speed / races, dependenecies / async
> > loading, -EPROBE_DEFER, etc.
> 
> How would dbus in the kernel change anything here?
> The kernel directly loads firmware from the filesystem now, no userspace
> helpers are involved, so no need for udev, libusb, etc.  And as such, no
> need for any "dbus" in the kernel to do this either.
> I don't understand how it could, please explain.

Yeah nevermind :D too much coffee today made my brain fart.

> Also note, for those not knowing, we have been working on dbus in the
> kernel (google "kdbus" for the github repo), but it is all
> outward-facing (i.e. userspace using the kdbus code to interact with
> other processes with a dbus-like protocol, not for in-kernel dbus
> things, although adding it wouldn't be that hard, just really strange.

Thanks!

  Luis
