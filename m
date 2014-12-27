Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaL0IT7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 03:19:59 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52620 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaL0ITy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 03:19:54 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: nick <xerofoify@gmail.com>
Subject: Re: [Intel-gfx] 3.19-rc1 errors when opening LID
Date: Sat, 27 Dec 2014 09:19:49 +0100
User-Agent: KMail/1.13.7 (Linux/3.19.0-031900rc1-generic; KDE/4.14.2; x86_64; ; )
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
References: <201412241951.48652@pali> <201412250948.38808@pali> <549C4278.5080707@gmail.com>
In-Reply-To: <549C4278.5080707@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1541133.iIH6IYZWgE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412270919.49540@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1541133.iIH6IYZWgE
Content-Type: multipart/mixed;
  boundary="Boundary-01=_lumnUlF/LNzkyu1"
Content-Transfer-Encoding: 7bit


--Boundary-01=_lumnUlF/LNzkyu1
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

in attachment is output of ls -l /sys/bus/acpi/devices from both=20
3.13 and 3.19 kernels.
=20
Anyway Gabriele Mazzotta wrote me that new acpi devices could be=20
created after commit faae404ebdc6bba (ACPICA: Add "Windows 2013"=20
string to _OSI support).

Maybe this another output could help you:

$ cat /sys/bus/acpi/devices/INT33C5\:00/status
0
$ cat /sys/bus/acpi/devices/INT33C5\:00/power_state
(unknown)

Device INT33C5 is in that dmesg log:
acpi INT33C5:00: Cannot transition to non-D0 state from D3

And status 0 in sysnode could indicate that acpi device is not=20
present right?

On Thursday 25 December 2014 17:59:36 nick wrote:
> Pali,
> This was probably to either add better power management or
> enable some new features related to acpi. Can you send me the
> files they created in kernel 3.19 r1 as I can probably trace
> it back to the bad commit. Regards Nick
>=20
> On 2014-12-25 03:48 AM, Pali Roh=C3=A1r wrote:
> > I know how to use git... first I wanted to report errors
> > because maybe it could be known problem or somebody else
> > can come with quick patch even without bisetcing (like for
> > other problems which I reported).
> >=20
> > Anyway those acpi devices which are mentioned in log do not
> > exist in 3.13 kernel (I do not see them in /sys/devices)
> >=20
> > Any idea why 3.19 kernel create new acpi devices which 3.13
> > kernel did not?
> >=20
> > On Thursday 25 December 2014 05:28:27 nick wrote:
> >> Pali,
> >> Do you known how to run git bisect as this is probably the
> >> best way to continue. Otherwise, I can teach you how it's
> >> not hard if your willing to learn :). Cheers Nick
> >>=20
> >> On 2014-12-24 01:51 PM, Pali Roh=C3=A1r wrote:
> >>> Hello!
> >>>=20
> >>> With new 3.19-rc1 kernel every time when I open LID on my
> >>> laptop, kernel prints these error lines to dmesg:
> >>>=20
> >>> [25566.368133] [drm:hsw_unclaimed_reg_detect.isra.6
> >>> [i915]] *ERROR* Unclaimed register detected. Please use
> >>> the i915.mmio_debug=3D1 to debug this problem.
> >>> [25566.368134] [drm:intel_uncore_check_errors [i915]]
> >>> *ERROR* Unclaimed register before interrupt
> >>> [25566.368192]
> >>> [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR*
> >>> Unclaimed register detected. Please use the
> >>> i915.mmio_debug=3D1 to debug this problem. [25566.368232]
> >>> [drm:hsw_unclaimed_reg_detect.isra.6 [i915]] *ERROR*
> >>> Unclaimed register detected. Please use the
> >>> i915.mmio_debug=3D1 to debug this problem.<4>[25568.446011]
> >>> i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has
> >>> bogus alignment
> >>> [25568.447018] pci_bus 0000:02: Allocating resources
> >>> [25568.447055] pci_bus 0000:03: Allocating resources
> >>> [25568.447135] pci_bus 0000:04: Allocating resources
> >>> [25568.447168] pci_bus 0000:05: Allocating resources
> >>> [25568.447195] pci_bus 0000:06: Allocating resources
> >>> [25568.447228] pci_bus 0000:0e: Allocating resources
> >>> [25568.447323] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> >>> flags 0x2] has bogus alignment [25568.447557] i915
> >>> 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus
> >>> alignment [25568.447735] i915 0000:00:02.0: BAR 6: [???
> >>> 0x00000000 flags 0x2] has bogus alignment [25568.447847]
> >>> i915 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has
> >>> bogus alignment [25568.448399] i915 0000:00:02.0: BAR 6:
> >>> [??? 0x00000000 flags 0x2] has bogus alignment
> >>> [25568.448438] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> >>> flags 0x2] has bogus alignment [25568.448566] acpi
> >>> MSFT1111:00: Cannot transition to power state D3cold for
> >>> parent in (unknown) [25568.448572] acpi INT33C2:00: Cannot
> >>> transition to non-D0 state from D3 [25568.448577] acpi
> >>> MSFT0002:00: Cannot transition to power state D3cold for
> >>> parent in (unknown) [25568.448581] acpi ELAN1010:00:
> >>> Cannot transition to power state D3cold for parent in
> >>> (unknown) [25568.448587] acpi INT33C3:00: Cannot
> >>> transition to non-D0 state from D3 [25568.448590] acpi
> >>> INT33C0:00: Cannot transition to non-D0 state from D3
> >>> [25568.448594] acpi INT33C1:00: Cannot transition to
> >>> non-D0 state from D3 [25568.448598] acpi INT33C4:00:
> >>> Cannot transition to non-D0 state from D3 [25568.448602]
> >>> acpi INT33C5:00: Cannot transition to non-D0 state from
> >>> D3 [25568.448623] acpi device:41: Cannot transition to
> >>> power state D3cold for parent in (unknown) [25568.448627]
> >>> acpi INT33C6:00: Cannot transition to non-D0 state from
> >>> D3 [25568.448890] pci_bus 0000:01: Allocating resources
> >>> [25568.448905] i915 0000:00:02.0: BAR 6: [??? 0x00000000
> >>> flags 0x2] has bogus alignment [25568.449064] i915
> >>> 0000:00:02.0: BAR 6: [??? 0x00000000 flags 0x2] has bogus
> >>> alignment [25568.449472] i915 0000:00:02.0: BAR 6: [???
> >>> 0x00000000 flags 0x2] has bogus alignment
> >>>=20
> >>> With older kernel (3.13) I do not see these errors, so it
> >>> is regression. Can you look at it? If it is needed, I can
> >>> provide other logs, ACPI/DSTD dumps, etc.
> >>>=20
> >>>=20
> >>>=20
> >>> _______________________________________________
> >>> Intel-gfx mailing list
> >>> Intel-gfx@lists.freedesktop.org
> >>> http://lists.freedesktop.org/mailman/listinfo/intel-gfx

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--Boundary-01=_lumnUlF/LNzkyu1
Content-Type: text/plain;
  charset="UTF-8";
  name="acpi_devices_3.13.0-44-generic"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="acpi_devices_3.13.0-44-generic"

celkom 0
drwxr-xr-x 2 root root 0 dec 25 14:04 ./
drwxr-xr-x 4 root root 0 dec 25 14:04 ../
lrwxrwxrwx 1 root root 0 dec 25 14:04 ACPI0003:00 -> ../../../devices/LNXSYSTM:00/device:00/ACPI0003:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 DELLABCE:00 -> ../../../devices/LNXSYSTM:00/device:00/DELLABCE:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0a -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0b -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0a/device:0b/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0c -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0c/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0d -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0c/device:0d/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0e -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0e/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:0f -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0f/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:00 -> ../../../devices/LNXSYSTM:00/device:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:01 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:02 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:03 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/device:03/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:04 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:04/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:05 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:04/device:05/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:06 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:07 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:06/device:07/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:08 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:08/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:09 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:08/device:09/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1a -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:1a/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1b -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1c -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1d -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1e -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:1e/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:1f -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:1f/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:10 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:11 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:12 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:13 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:13/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:14 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:14/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:15 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:15/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:16 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:16/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:17 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:17/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:18 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:18/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:19 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:10/device:11/device:12/device:19/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2a -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2a/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2b -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2b/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2c -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2c/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2d -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2d/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2e -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2e/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:2f -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:2f/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:20 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:20/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:21 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:21/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:22 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:22/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:23 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:22/device:23/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:24 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1b/device:1c/device:1d/device:24/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:25 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:26 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:27 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:27/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:28 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:28/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:29 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:29/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3a -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:3a/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3b -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:3b/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3c -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:3c/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3d -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3d/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3e -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:3f -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:3f/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:30 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:30/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:31 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:31/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:32 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:31/device:32/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:33 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:33/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:34 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:34/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:35 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:35/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:36 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:36/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:37 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:37/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:38 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:38/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:39 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:25/device:26/device:39/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4a -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:49/device:4a/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4b -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4b/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4c -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4c/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4d -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:4d/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4e -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:4e/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:4f -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:4f/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:40 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:40/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:41 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:41/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:42 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:42/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:43 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:43/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:44 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:44/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:45 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:45/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:46 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:3e/device:46/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:47 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:47/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:48 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:48/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:49 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:49/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:50 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:50/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:51 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:51/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:52 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:52/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:53 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:53/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:54 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:54/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:55 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/device:55/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:56 -> ../../../devices/LNXSYSTM:00/device:56/
lrwxrwxrwx 1 root root 0 dec 25 14:04 device:57 -> ../../../devices/LNXSYSTM:00/device:57/
lrwxrwxrwx 1 root root 0 dec 25 14:04 DLLK05BD:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/DLLK05BD:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 DLL05BD:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/DLL05BD:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 INT0800:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/INT0800:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 INT3F0D:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/INT3F0D:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:00 -> ../../../devices/LNXSYSTM:00/LNXCPU:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:01 -> ../../../devices/LNXSYSTM:00/LNXCPU:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:02 -> ../../../devices/LNXSYSTM:00/LNXCPU:02/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:03 -> ../../../devices/LNXSYSTM:00/LNXCPU:03/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:04 -> ../../../devices/LNXSYSTM:00/LNXCPU:04/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:05 -> ../../../devices/LNXSYSTM:00/LNXCPU:05/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:06 -> ../../../devices/LNXSYSTM:00/LNXCPU:06/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXCPU:07 -> ../../../devices/LNXSYSTM:00/LNXCPU:07/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXPWRBN:00 -> ../../../devices/LNXSYSTM:00/LNXPWRBN:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXSYSTM:00 -> ../../../devices/LNXSYSTM:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXTHERM:00 -> ../../../devices/LNXSYSTM:00/device:56/LNXTHERM:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXVIDEO:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:49/LNXVIDEO:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 LNXVIDEO:01 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0A08:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0B00:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0B00:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0A:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0A:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0A:01 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0A:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0C:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0C:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0D:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0D:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0E:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0E:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:01 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:02 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:02/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:03 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:03/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:04 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:04/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:05 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:05/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:06 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:06/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C0F:07 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C0F:07/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C01:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C01:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C02:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C02:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C02:01 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C02:01/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C02:02 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/PNP0C02:02/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C04:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C04:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C09:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0C09:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0C14:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0C14:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0000:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0000:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0100:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0100:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0103:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0103:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0200:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0200:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 PNP0401:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/PNP0401:00/
lrwxrwxrwx 1 root root 0 dec 25 14:04 SMO8810:00 -> ../../../devices/LNXSYSTM:00/device:00/PNP0A08:00/SMO8810:00/

--Boundary-01=_lumnUlF/LNzkyu1
Content-Type: text/plain;
  charset="UTF-8";
  name="acpi_devices_3.19-rc1-generic"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="acpi_devices_3.19-rc1-generic"

celkom 0
drwxr-xr-x 2 root root 0 dec 27 09:08 ./
drwxr-xr-x 4 root root 0 dec 27 09:08 ../
lrwxrwxrwx 1 root root 0 dec 27 09:08 ACPI0003:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/ACPI0003:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ALP0001:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ALP0001:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ATML1000:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ATML1000:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ATML2000:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ATML2000:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 BCM2E20:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C5:00/BCM2E20:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 CYP0001:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/CYP0001:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 DELLABCE:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/DELLABCE:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/device:0a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0c -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0b/device:0c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0d -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0d/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0e -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0d/device:0e/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:0f -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0f/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:02 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/device:02/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:03 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:03/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:04 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:03/device:04/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:05 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:05/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:06 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:05/device:06/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:07 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:07/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:08 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:07/device:08/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:09 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:1a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:1b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1c -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:1c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1d -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:1d/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1e -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:1f -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:10 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:0f/device:10/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:11 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:11/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:12 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:12/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:13 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:14 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:15 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:16 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:16/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:17 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:17/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:18 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:18/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:19 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:13/device:14/device:15/device:19/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2c -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2d -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2d/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2e -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2e/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:2f -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:2f/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:20 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:21 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:21/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:22 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:22/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:23 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:23/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:24 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:24/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:25 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:25/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:26 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:25/device:26/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:27 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1e/device:1f/device:20/device:27/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:28 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:29 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3c -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3d -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3d/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3e -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3e/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:3f -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:3f/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:30 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:30/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:31 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:31/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:32 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:32/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:33 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:33/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:34 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:34/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:35 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:34/device:35/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:36 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:36/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:37 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:37/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:38 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:38/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:39 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:28/device:29/device:39/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:4a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:4b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4c -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:4c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4d -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4d/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4e -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4e/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:4f -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:40 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:40/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:41 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C6:00/device:41/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:42 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C8:00/device:42/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:43 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C8:00/device:43/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:44 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:45 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:45/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:46 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:46/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:47 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:47/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:48 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:48/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:49 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/device:49/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:5a -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:5a/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:5b -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:5b/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:5c -> ../../../devices/LNXSYSTM:00/device:5c/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:50 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/device:50/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:51 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:51/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:52 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:52/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:53 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:53/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:54 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:54/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:55 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:55/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:56 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:56/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:57 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:57/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:58 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:58/
lrwxrwxrwx 1 root root 0 dec 27 09:08 device:59 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/device:59/
lrwxrwxrwx 1 root root 0 dec 27 09:08 DLLK05BD:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/DLLK05BD:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 DLL05BD:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/DLL05BD:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 EETI7900:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/EETI7900:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ELAN1000:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ELAN1000:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ELAN1001:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ELAN1001:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ELAN1010:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/ELAN1010:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 ICV0A12:00 -> ../../../devices/LNXSYSTM:00/ICV0A12:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INTL9C60:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INTL9C60:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT0800:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/INT0800:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT3F0D:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/INT3F0D:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33A1:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/INT33A1:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33CA:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/INT33CA:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33CB:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/INT33CB:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C0:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C0:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C1:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C1:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C2:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C3:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C4:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C4:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C5:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C5:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C6:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C6:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C7:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C7:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C8:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C8:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33C9:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/INT33C9:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33D0:00 -> ../../../devices/LNXSYSTM:00/INT33D0:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33D1:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/INT33D1:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33D7:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/INT33D7:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33E0:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C4:00/INT33E0:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT33E0:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C5:00/INT33E0:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 INT3420:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/INT3420:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:00 -> ../../../devices/LNXSYSTM:00/LNXCPU:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:01 -> ../../../devices/LNXSYSTM:00/LNXCPU:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:02 -> ../../../devices/LNXSYSTM:00/LNXCPU:02/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:03 -> ../../../devices/LNXSYSTM:00/LNXCPU:03/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:04 -> ../../../devices/LNXSYSTM:00/LNXCPU:04/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:05 -> ../../../devices/LNXSYSTM:00/LNXCPU:05/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:06 -> ../../../devices/LNXSYSTM:00/LNXCPU:06/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXCPU:07 -> ../../../devices/LNXSYSTM:00/LNXCPU:07/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXIOBAY:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:44/LNXIOBAY:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXPWRBN:00 -> ../../../devices/LNXSYSTM:00/LNXPWRBN:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXSYBUS:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXSYBUS:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXSYSTM:00 -> ../../../devices/LNXSYSTM:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXTHERM:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:01/LNXTHERM:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXVIDEO:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:4f/LNXVIDEO:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 LNXVIDEO:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 MSFT0001:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/MSFT0001:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 MSFT0002:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/MSFT0002:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 MSFT1111:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C2:00/MSFT1111:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 NTRG0001:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/INT33C3:00/NTRG0001:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 NXP5442:00 -> ../../../devices/LNXSYSTM:00/NXP5442:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0A08:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0B00:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0B00:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0A:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0A:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0C:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0D:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0E:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:02 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:02/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:03 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:03/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:04 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:04/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:05 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:05/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:06 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:06/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C0F:07 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0F:07/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C01:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C01:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C01:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C01:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C02:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C02:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C02:01 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C02:01/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C02:02 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C02:02/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C02:03 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/PNP0C02:03/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C04:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C04:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C09:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0C09:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0C14:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C14:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0000:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0000:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0100:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0100:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0103:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0103:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0200:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0200:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0401:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0401:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 PNP0501:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:00/PNP0501:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 SKTD000:00 -> ../../../devices/LNXSYSTM:00/SKTD000:00/
lrwxrwxrwx 1 root root 0 dec 27 09:08 SMO8810:00 -> ../../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/SMO8810:00/

--Boundary-01=_lumnUlF/LNzkyu1--

--nextPart1541133.iIH6IYZWgE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSea6UACgkQi/DJPQPkQ1Lc/ACdHVlpHd+1YPks2H5+Eafl4WZV
4aQAoKT+tDTKbVNRPOk/RcypowKb5Jw9
=TQEw
-----END PGP SIGNATURE-----

--nextPart1541133.iIH6IYZWgE--
