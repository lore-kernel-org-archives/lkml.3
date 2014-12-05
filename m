Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755AbaLEIua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:50:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbaLEIu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:50:27 -0500
Message-ID: <1417769421.11297.37.camel@nilsson.home.kraxel.org>
Subject: Re: [ANNOUNCE][RFC] KVMGT - the implementation of Intel GVT-g(full
 GPU virtualization) for KVM
From: Gerd Hoffmann <kraxel@redhat.com>
To: Jike Song <jike.song@intel.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Cowperthwaite, David J" <david.j.cowperthwaite@intel.com>,
        "White, Michael L" <michael.l.white@intel.com>,
        "Dong, Eddie" <eddie.dong@intel.com>, "Li, Susie" <susie.li@intel.com>,
        "Haron, Sandra" <sandra.haron@intel.com>
Date: Fri, 05 Dec 2014 09:50:21 +0100
In-Reply-To: <547FC5DE.4010701@intel.com>
References: <547FC5DE.4010701@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> 		In KVMGT, we need to register an iodev only *after* BAR registers are
> 		written by guest.

Oh, the guest can write the bar register at any time.  Typically it
happens at boot only, but it can also happen at runtime, for example on
reboot.

I've also seen the kernel redoing the pci mappings created by the bios,
due to buggy _crs declarations in the qemu acpi tables.

> 	https://www.usenix.org/conference/atc14/technical-sessions/presentation/tian

/me goes read this.

A few comments on the kernel stuff (brief look so far, also
compile-tested only, intel gfx on my test machine is too old).

 * Noticed the kernel bits don't even compile when configured as
   module.  Everything (vgt, i915, kvm) must be compiled into the
   kernel.
 * Design approach still seems to be i915 on vgt not the other way
   around.

Qemu/SeaBIOS bits:

I've seen the host bridge changes identity from i440fx to
copy-pci-ids-from-host.  Guess the reason for this is that seabios uses
this device to figure whenever it is running on i440fx or q35.  Correct?

What are the exact requirements for the device?  Must it match the host
exactly, to not confuse the guest intel graphics driver?  Or would
something more recent -- such as the q35 emulation qemu has -- be good
enough to make things work (assuming we add support for the
graphic-related pci config space registers there)?

The patch also adds a dummy isa bridge at 0x1f.  Simliar question here:
What exactly is needed here?  Would things work if we simply use the q35
lpc device here?

more to come after I've read the paper linked above ...

cheers,
  Gerd


