Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbaDJGMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:12:25 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:34995 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaDJGMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:12:23 -0400
Message-ID: <53463641.1030800@monstr.eu>
Date: Thu, 10 Apr 2014 08:12:17 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Punnaiah Choudary <kpc528@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Doug Thompson <dougthompson@xmission.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-edac@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        punnaiah choudary kalluri <kalluripunnaiahchoudary@gmail.com>,
        punnaiah choudary kalluri <punnaia@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com> <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local> <20140409113246.GA8778@pd.tnic> <CAL_Jsq+gszc+R_BrLtHKEBGYd=3T+sE1d+-HoF9aYZt6C2k5-g@mail.gmail.com> <20140409151932.GK6529@pd.tnic> <CAHLkNHJTA5bGD1zAfzE2JrDFAWvmgYyYjir+4vR-d9Fe2-E48g@mail.gmail.com> <20140409174701.GO6529@pd.tnic>
In-Reply-To: <20140409174701.GO6529@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ME3xMGXB0ilkieRoxEIfFGdTbD860ewG6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ME3xMGXB0ilkieRoxEIfFGdTbD860ewG6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 04/09/2014 07:47 PM, Borislav Petkov wrote:
> On Wed, Apr 09, 2014 at 10:59:49PM +0530, Punnaiah Choudary wrote:
>> There is a driver file cache-l2x0.c under arch/arm/mm for pl310 cache
>> configuration and management. Russel king had suggested to use
>> single driver file for both pl310 edac implementation and cache-l2x0.c=

>> Here is the thread
>> http://www.spinics.net/lists/arm-kernel/msg320407.html
>>
>> please provide your inputs
>=20
> Well, it is very simple - you don't really need an EDAC compilation uni=
t
> just so that you can report errors - you can very well do that in your
> cache-l2x0.c and boom, problem solved.
>=20
> Simply move the irq handler and the parity error checker to that file.

I am just curious about this recommendation. Does it mean that we shouldn=
't
use edac interface just for reporting problems?

I didn't play with it but I guess that there is a record about edac drive=
r
via sysfs, etc. You could read some useful information that you know
what it is protected and I hope that edac interface bring any value
to reporting errors comparing to just printk message from IRQ handler.

My question is if using printk in IRQ handler and report problem is equal=
 to
reporting this via edac interface. Or it is just easy way to do but
using edac interface is right solution and how to do it properly
is different question.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ME3xMGXB0ilkieRoxEIfFGdTbD860ewG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNGNkEACgkQykllyylKDCFcdwCfWd+zLKLdg7fKhj2az7pGDH2u
6eEAn14us5SrSATJ2vm0EKz1wf7BtV8B
=Jujl
-----END PGP SIGNATURE-----

--ME3xMGXB0ilkieRoxEIfFGdTbD860ewG6--
