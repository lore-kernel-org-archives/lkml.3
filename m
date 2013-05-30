Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178Ab3E3EjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:39:00 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64913 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3E3Eix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:38:53 -0400
Date: Wed, 29 May 2013 23:38:48 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: Dead URL in Documentation/acpi/dsdt-override.txt
To: Drunkard Zhang <gongfan193@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <CAJiejCSQOGP-8fyKgw2pgkGNZ9uQSG0vU_OsQDuK8iMJkq5sOA@mail.gmail.com>
	(from gongfan193@gmail.com on Tue May 28 21:45:35 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1369888728.2776.46@driftwood>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-CiJ4RVy6UIv7LzCy5dZy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-CiJ4RVy6UIv7LzCy5dZy
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05/28/2013 09:45:35 PM, Drunkard Zhang wrote:
> The domain name www.lesswatts.org in
> Documentation/acpi/dsdt-override.txt is unresolvable, so the URL is
> dead too.

Judging solely from the t-shirt they gave me at OLS 2008, I knew the =20
website probably wasn't long for the world. (It lasted longer than I =20
expected.)

> I found some good docs in this topic:
>=20
> http://wiki.debian.org/OverridingDSDT

The original is at =20
http://web.archive.org/web/20120328105600/http://www.lesswatts.org/projects=
/acpi/overridingDSDT.php =20
and since all this file does is link you to the (now defunct) web page, =20
I'll just copy it inline. (And cc: Arjan, who was the contact for that =20
website...)

(Sorry for the attachment, but balsa is crap and I've forgotten step =20
twelve of sending a non-whitespace damaged inline patch through it. =20
Something about frogs.)

Rob=

--=-CiJ4RVy6UIv7LzCy5dZy
Content-Type: text/x-patch; charset=us-ascii; name=blah2.patch
Content-Disposition: attachment; filename=blah2.patch
Content-Transfer-Encoding: quoted-printable

From: Rob Landley <rob@landley.net>

Copy text from archive.org copy of lesswatts.org inline, replacing dead lin=
k.

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/acpi/dsdt-override.txt |  110 ++++++++++++++++++++++++-
 1 file changed, 107 insertions(+), 3 deletions(-)


diff --git a/Documentation/acpi/dsdt-override.txt b/Documentation/acpi/dsdt=
-override.txt
index febbb1b..7011e0d 100644
--- a/Documentation/acpi/dsdt-override.txt
+++ b/Documentation/acpi/dsdt-override.txt
@@ -2,6 +2,110 @@ Linux supports a method of overriding the BIOS DSDT:
=20
 CONFIG_ACPI_CUSTOM_DSDT builds the image into the kernel.
=20
-When to use this method is described in detail on the
-Linux/ACPI home page:
-http://www.lesswatts.org/projects/acpi/overridingDSDT.php
+Overriding a DSDT
+
+-- Why override a DSDT?
+
+The DSDT (Differentiated System Description Table) is the primary AML tabl=
e in
+the BIOS. Per the description of acpidump, the DSDT can be extracted from =
the
+machine, the ASL modified, and a new AML DSDT can be compiled. The section=
s
+below show two ways to tell Linux to use this modified DSDT instead of the
+version that came with the BIOS.
+
+In the early days of Linux/ACPI, DSDT modifications were common to work ar=
ound
+both BIOS bugs and Linux bugs. However, the stated goal of the Linux/ACPI
+project today is that Linux should run on un-modified firmware. Thus, the =
DSDT
+database at the old http://acpi.sourceforge.net web site is now largely a
+historical artifact.
+
+-- Where do I get iasl for dis-assembling and compiling tables?
+
+iASL is part of the ACPICA release at http://acpica.org.  Note that "iasl =
-d"
+can now not only dis-assemble a DSDT and SSDT, but also most other ACPI ta=
ble
+images.
+
+-- What if I also want to override the SSDTs?
+
+If you need to modify the code present in an SSDT, then combine all of the
+SSDTs into a DSDT override, modify it as necessary, and boot with
+"acpi_no_auto_ssdt" to prevent Linux from automatically loading the SSDTs
+listed in the RSDT/XSDT.
+
+-- Is it important if my DSDT doesn't re-compile
+
+Not necessarily. Many static ASL bugs that are rejected by iASL have
+workarounds present in the Linux kernel. This is because even if you might=
 be
+able to modify and override your DSDT, most users with a system like yours
+cannot.
+
+Of course you need to get the DSDT to re-compile if you want to run your
+modifications.
+
+-- How to print to the Linux console from AML
+
+When CONFIG_ACPI_DEBUG=3Dy and when acpi.debug_level & 0x8, ASL stores to =
the
+special object "Debug" will come out in the dmesg. eg
+
+  Store("hello world!", Debug)
+
+  Store(Local0, Debug)
+
+
+  [ACPI Debug] String: [0x0C] "hello world!"
+
+  [ACPI Debug] Integer: 0x00000042
+
+-- How to Build a custom DSDT into the kernel
+
+Get original DSDT:
+
+  # cp /proc/acpi/dsdt DSDT
+
+or
+
+  # acpidump > acpidump.out
+  $ acpixtract DSDT acpidump > DSDT.dat
+
+Disassemble it
+
+  $ iasl -d DSDT.dat
+
+Make your changes:
+
+  $ vi DSDT.dsl
+
+Build it:
+
+  $ iasl -tc DSDT.dsl
+
+Put it where the kernel build can include it:
+
+  $ cp DSDT.hex $SRC/include/
+
+Add this to the kernel .config:
+
+  CONFIG_STANDALONE=3Dn
+  CONFIG_ACPI_CUSTOM_DSDT=3Dy
+  CONFIG_ACPI_CUSTOM_DSDT_FILE=3D"DSDT.hex"
+
+Make the kernel and off you go!
+
+  You should see in dmesg:=20
+  Table [DSDT] replaced by host OS
+
+-- How to build a custom DSDT into an initrd
+
+If you are unable to re-build the kernel, or you'd like to run the same ke=
rnel
+binary on multiple machines that require different DSDT overrides, then th=
e
+initrd method should suit your needs. This method is enabled using
+CONFIG_ACPI_CUSTOM_DSDT_INITRD, and you can tell if a kernel binary includ=
es
+it by finding the following line in the console log:
+
+  "ACPI: Checking initramfs for custom DSDT"
+
+The process for creating the DSDT image is the same as above. But note tha=
t the
+format of the table included in the initramfs is binary (iasl -ta), while =
if
+you build a DSDT into the kernel, C-source code is used (iasl -tc).
+
+In case your mkinitrd tool does not support this feature, a script is prov=
ided
=

--=-CiJ4RVy6UIv7LzCy5dZy--
