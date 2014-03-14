Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161056AbaCNVkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:40:06 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42121 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030221AbaCNVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:40:01 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: next-20140312 - build error in drivers/acpi/sleep.c
In-Reply-To: Your message of "Thu, 13 Mar 2014 22:23:51 +0100."
             <1431943.FB4azhDoEG@vostro.rjw.lan>
From: Valdis.Kletnieks@vt.edu
References: <22429.1394736511@turing-police.cc.vt.edu>
            <1431943.FB4azhDoEG@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1394830609_14626P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Mar 2014 16:56:49 -0400
Message-ID: <72679.1394830609@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1394830609_14626P
Content-Type: text/plain; charset=us-ascii

On Thu, 13 Mar 2014 22:23:51 +0100, "Rafael J. Wysocki" said:

> On Thursday, March 13, 2014 02:48:31 PM Valdis Kletnieks wrote:
> > Seen in the most recent linux-next with a CONFIG_SUSPEND=n .config:
> >   CC      drivers/acpi/sleep.o
> > drivers/acpi/sleep.c: In function 'acpi_sleep_init':
> > drivers/acpi/sleep.c:808:2: error: implicit declaration of function 'acpi_sleep_state_supported' [-Werror=implicit-function-declaration]
> >   if (acpi_sleep_state_supported(ACPI_STATE_S5)) {
> >   ^
> > cc1: some warnings being treated as errors
> > make[2]: *** [drivers/acpi/sleep.o] Error 1
> > make[1]: *** [drivers/acpi] Error 2
> > make: *** [drivers] Error 2

> > Function is defined inside a #ifdef CONFIG_SUSPEND, but used outside of
> > one in acpi_sleep_init().

> git blame points at commit eaa54ccbc:
>
> commit eaa54ccbcf81de987e6978ad457cc9e425b7a8db
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Tue Mar 11 14:08:58 2014 +0100
>
>     ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

This appears to be fixed in next-20140314, with updated commit:

commit a4e90bed511220ff601d064c9e5d583e91308f65
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Thu Mar 13 22:11:39 2014 +0100

    ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states


Thanks...


--==_Exmh_1394830609_14626P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUyNtEQdmEQWDXROgAQKqaBAAh3ZVZdXX8nv2638OoWgUWnu4O/UCGrb/
a+XtslcZe3AX/JGyw3C5rLnkmwmY/JYdEXuwAPTug5phcb+0lzd9nAS/NC+aB28E
JYZRTwKcp2PjxjBwyAfL1LhiHYfHd2fOPvJk3XNrpZSvIJfQsxKAqDg8UmU3rBCT
dIIlrVS2AGOhhMlC7L32oQ0yxoqGGiZMIv7YJpbowVm0TWHF3kMtbRIDIjOCC+a9
F6Q0p1dDcGe6bDXmLhswH9NYjUK91JV61NjQiw7VJsFsGwnSMIw7cP6eDyy7xD3O
u1VnPGPxTvMeXHk7EjxJ9PJxoLD17k1mJ/knjDvCCd+KLFiKexztPQpmkpHB6LTw
1qdFSKE2sg5C45TsBp8HujG6qlVBLleeEp4F84oEKPYPzKZvYXu/7RDAzeSq/05D
IqiEnIUZvCH0fZUhQz99cOQtwgB4Pz2x09MlfXtJSjZeMrNB2WjeKadOCxfXPquV
926y3CDSqLf6eqXYZ97vms0RKWlCHnPSL2fiwpoID1j0gStQxjDZBz4KsTDXctIm
1YiOMOJLIQs4HyVoKsXmCTFpgLkzhihe9QFOISxiDVsZGxjM2GGCGdNVuR7yZk7r
LsIDZvuTw2p7UzF6Uvh6hPVID/6UH5mi+rUiniPepA9dMz021az9lAjIYUb7HXuT
YhOJ02FuxaM=
=4CgH
-----END PGP SIGNATURE-----

--==_Exmh_1394830609_14626P--
