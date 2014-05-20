Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaETHBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:01:45 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:47161 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaETHBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:01:43 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8800/SMO8810)
In-Reply-To: Your message of "Sat, 03 May 2014 12:47:56 +0200."
             <1399114077-19314-2-git-send-email-pali.rohar@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
            <1399114077-19314-2-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400569205_1944P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 20 May 2014 03:00:05 -0400
Message-ID: <20135.1400569205@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400569205_1944P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sat, 03 May 2014 12:47:56 +0200, Pali Roh=E1r said:
> This acpi driver provide supports for freefall sensors SMO8800/SMO8810 =
which
> can be found on Dell Latitude laptops. Driver register /dev/freefall mi=
sc
> device which has same interface as driver hp_accel freefall driver. So =
any
> existing applications for HP freefall sensor /dev/freefall will work fo=
r with
> this new driver for Dell Latitude laptops too.

So just for grins, I tossed this patchset on top of next-20140519, and
it actually works on my Dell Latitude E6530. Tested with a controlled
drop of 3-4 inches, and I get the distinctive sound of a head park, and
the following in /var/log/messages:

May 20 02:46:22 turing-police kernel: =5B18839.158926=5D smo8800 SMO8810:=
00: detected free fall
May 20 02:46:22 turing-police FREE FALL=5B1337=5D: Parked /dev/sda disk h=
ead
May 20 02:46:24 turing-police FREE FALL=5B1337=5D: Unparked /dev/sda disk=
 head

I did a quick read-through of the code, looks OK.  checkpatch complains a=
bout
missing blank lines after declarations in 3-4 places. Sparse and gcc have=
 no
complaints. We've certainly merged much uglier code.  And it certainly ma=
kes
the world a better place for us Dell users.

So it's OK by me if Pali adds this to the signoffs after fixing the
checkpatch and the one serious nit below....

Tested-By: Valdis Kletnieks <valdis.kletnieks=40vt.edu>
Acked-By: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

One nit:

> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> =40=40 -127,6 +127,16 =40=40 config DELL_WMI_AIO
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called dell-wmi-aio.
> =20
> +config DELL_SMO8800
> +	tristate =22Dell Latitude freefall driver (ACPI SMO8800/SMO8810)=22
> +	depends ON ACPI

Lowercase ON.  Not sure how this escaped, Kbuild barfs on it.


--==_Exmh_1400569205_1944P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3r9dQdmEQWDXROgAQJE5A/9Hxi4bTHvLsgQsi76nwyrxhI/E2BLPLBb
D+pZzgunKxQ+KcGm3mxuObd+apn5kpOpJK86OC5w5VZDjf0XcVhFQsHn6eDFzbi2
nP+hsCrg7EoI1o/oqMPqZIHXbbh746EkOHcNjb3md3aEpU68l00tGERrDH2fMzHl
d6aMJdqAA219saxhFZ97kcBOj/WhodH1ag2gJzCZZ8SUmNAqYxOFnKp2UnLof1yt
szsfpDrPoTNBs9PmnpHz4l9Styowue8ljAZpCiS1xVlq64m7NfLIg6VL9aNsXAoI
RsDij2NocZFbmC3C/EmReVFQvAewSGHN+suTUvmVQIMz7yq1rKKxhb19/cN2WDiT
6B3JfwD1O6RZaSsxEz4KHs6etK07Tf7lh7IEr0pVCBoN55jZElhWkza/JSdfCtzY
g5wremtSMCTZiV6F/m9UY2hRC8pzU3wztbeSWwt+b3OvfIwFgLJ/rBcPY97XIGSg
2JmXyp5GXoVkBpdOy3udOIginRYxFovzfSG196zzoCQVX4ZbWs3uzpEIVIy/nCKM
SO6g8Fu7bcjzn9D0mJ3tLr6bIkCLhv8ZVW4EJbOHn4EYTu8D1gJ8dFYkgfxUwlHc
ym4IuOmh0QMT/Apyq9Nh9Dz85g4KBkVlw/Sp386CdnE+2m/M1QjNa151ieBXZjda
kCw0cwwrhWI=
=eiV7
-----END PGP SIGNATURE-----

--==_Exmh_1400569205_1944P--
