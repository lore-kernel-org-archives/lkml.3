Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK1Xan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 18:30:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54421 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751256AbaK1Xam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 18:30:42 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mark Brown <broonie@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Zhang <benzh@chromium.org>,
        alsa-devel <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Bard Liao <bardliao@realtek.com>,
        Oder Chiou <oder_chiou@realtek.com>,
        Anatol Pomozov <anatol@google.com>, Dylan Reid <dgreid@chromium.org>,
        flove@realtek.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ASoC: rt5677: Add ACPI device probing
Date: Sat, 29 Nov 2014 00:51:59 +0100
Message-ID: <2127240.rWRTDu6LHQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141128160036.GW7712@sirena.org.uk>
References: <1416034608-24238-1-git-send-email-benzh@chromium.org> <7202604.4LK4s7RH1S@vostro.rjw.lan> <20141128160036.GW7712@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 28, 2014 04:00:36 PM Mark Brown wrote:
> 
> --k9ssVBY1NpawPNl1
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> On Thu, Nov 27, 2014 at 12:09:55AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 26, 2014 11:17:16 AM Mark Brown wrote:
> 
> > > > As to registering ACPI IDs, I believe this is the right link:
> > > > http://www.uefi.org/PNP_ACPI_Registry
> 
> > > No, those are vendors as far as I can tell.  I mean identifiers for
> > > specific devices - it appears to be common for for example Intel to
> > > allocate identifiers for devices they don't produce, I'd expect there to
> > > be some effort to keep track of that especially given that _DSD
> > > properties may well end up being specific to the identifier used to
> > > register in cases of parallel evolution.
> 
> > The vendor (or more precisely the owner of the initial 3 or 4 letter code)
> > is supposed to do that.  I'm not aware of any common registry of those IDs
> > for all vendors.
> 
> OK, we probably should have one to aid discoverability since as far as I
> can tell what's happening is that people (hi Intel!) are allocating
> their own identifiers for devices produced by other vendors that turn up
> on their boards.  If people can find the set of IDs in use there's more
> chance they'll use the same ones as other people.

There's the PRP0001 ID that can be use to in combination with the
"compatible" property which then works the same way as for DT.

That should be sufficient if the properties are going to be the
same for ACPI (_DSD) and DT.

> > > > Or did you mean a HID/CID<->DSD mapping?
> 
> > > I don't really know what that is, sorry.
> 
> > The device ID is supposed to determine the way all of the ACPI objects for that
> > device will work, including what is returned by _DSD.  Pretty much in analogy
> > with PCI device IDs.
> 
> So the HID and CID are device IDs then?  Please bear in mind that we're
> not all familiar with the acronym soup that tends to go along with ACPI!

Yes, they are supposed to be treated this way.

> If those are device IDs then what you're saying is what I'd expect to
> happen and it's part of the reason I'd expect us to be registering IDs
> along with registering properties - if people are defining device
> specific properties they really ought to be tied to the IDs that are in
> use especially if (as seems likely to be the case with the current state
> of the world) people are doing things without attempting to coordinate
> and we're ending up trying to document the deployed reality.

The rule of thumb (in my view) should be that if the device object's _DSD is
going to return the same set of properties as for DT and no other special
handling determined by the ID is required (ie. nothing along the lines of
"if the device ID is X, the _ABC method works like that" which has to be known
by the driver), "PRP0001" should be returned by _HID and then the value of the
"compatible" property should be the same as for DT.

In other words, "PRP0001" means "a generic device with properties as returned
by _DSD".

Otherwise, a new device ID needs to be allocated for the device and _HID
should return that ID.  Also, if the device is compatible with another
device with an already allocated ID (for _HID), _CID may return the device ID
of the compatible device.  [Of course, it's better if _HID is the same for
identical devices.]


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
