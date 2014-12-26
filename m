Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaLZOu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:50:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52211 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752864AbaLZOuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:50:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: 3.19-rc1 errors when opening LID
Date: Fri, 26 Dec 2014 16:12:49 +0100
Message-ID: <3406993.nnu7vUsHIn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <201412241951.48652@pali>
References: <201412241951.48652@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 24, 2014 07:51:48 PM Pali Rohár wrote:
> 
> --nextPart5943893.pKyMBm5Emp
> Content-Type: Text/Plain;
>   charset="utf-8"
> Content-Transfer-Encoding: quoted-printable
> 
> Hello!
> 
> With new 3.19-rc1 kernel every time when I open LID on my laptop, kernel pr=
> ints these error lines to dmesg:

Does your syste suspend when the lid is closed and resume when it is open?

> [25566.368133] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
> ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
> lem.
> [25566.368134] [drm:intel_uncore_check_errors [i915]] *ERROR* Unclaimed reg=
> ister before interrupt
> [25566.368192] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
> ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
> lem.
> [25566.368232] [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR* Unclaim=
> ed register detected. Please use the i915.mmio_debug=3D1 to debug this prob=
> lem.<4>[25568.446011] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2]=
> =20
> has bogus alignment

The above messages are from i915 and don't seem to be related to ACPI.

> [25568.447018] pci_bus 0000:02: Allocating resources
> [25568.447055] pci_bus 0000:03: Allocating resources
> [25568.447135] pci_bus 0000:04: Allocating resources
> [25568.447168] pci_bus 0000:05: Allocating resources
> [25568.447195] pci_bus 0000:06: Allocating resources
> [25568.447228] pci_bus 0000:0e: Allocating resources
> [25568.447323] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.447557] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.447735] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.447847] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.448399] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.448438] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment

The above too.

> [25568.448566] acpi MSFT1111:00: Cannot transition to power state D3cold fo=
> r parent in (unknown)
> [25568.448572] acpi INT33C2:00: Cannot transition to non-D0 state from D3
> [25568.448577] acpi MSFT0002:00: Cannot transition to power state D3cold fo=
> r parent in (unknown)
> [25568.448581] acpi ELAN1010:00: Cannot transition to power state D3cold fo=
> r parent in (unknown)
> [25568.448587] acpi INT33C3:00: Cannot transition to non-D0 state from D3
> [25568.448590] acpi INT33C0:00: Cannot transition to non-D0 state from D3
> [25568.448594] acpi INT33C1:00: Cannot transition to non-D0 state from D3
> [25568.448598] acpi INT33C4:00: Cannot transition to non-D0 state from D3
> [25568.448602] acpi INT33C5:00: Cannot transition to non-D0 state from D3
> [25568.448623] acpi device:41: Cannot transition to power state D3cold for =
> parent in (unknown)
> [25568.448627] acpi INT33C6:00: Cannot transition to non-D0 state from D3

All of the above mean that power transitions were not carried out for some
devices, because they were in unexpected power states to start with.

They are devices on the Intel LPSS as far as I can say (CCing Mika and Andy).

> [25568.448890] pci_bus 0000:01: Allocating resources
> [25568.448905] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.449064] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> [25568.449472] i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bog=
> us alignment
> 
> With older kernel (3.13) I do not see these errors, so it is regression.

It only is a regression if it leads to functional problems.  Do you see any?

> Ca=n you look at it? If it is needed, I can provide other logs, ACPI/DSTD dump=
> s, etc.

It looks like 3.13 didn't try to use some devices that are now used in 3.19-rc1
and something doesn't work entirely as expected.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
