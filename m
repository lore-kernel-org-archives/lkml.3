Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3J3POJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:14:09 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:39869 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3J3POH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:14:07 -0400
Message-ID: <5271223C.9090803@monstr.eu>
Date: Wed, 30 Oct 2013 16:14:04 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Michal Simek <michal.simek@xilinx.com>, Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: Fix ECC mem policy printk
References: <8986e8f1a3761e45a7927bdb0e54393c9155e6bf.1383137171.git.michal.simek@xilinx.com> <20131030130728.GA16735@n2100.arm.linux.org.uk> <5271165A.4050509@monstr.eu> <52711869.60703@monstr.eu> <20131030150106.GC16735@n2100.arm.linux.org.uk>
In-Reply-To: <20131030150106.GC16735@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="jIbVmJIkNUfcIewbH1E7SCr3aGBugCl1X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jIbVmJIkNUfcIewbH1E7SCr3aGBugCl1X
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On 10/30/2013 04:01 PM, Russell King - ARM Linux wrote:
> On Wed, Oct 30, 2013 at 03:32:09PM +0100, Michal Simek wrote:
>> btw: passing ecc=3Don through command line will caused that "ECC enabl=
ed"
>> message will be there even on systems which don't implement this bit.
>> It is just side effect for both these solutions.
>=20
> It is a hint, nothing more.  There is no way to detect whether it's
> implemented or even how it has been implemented.

ok. That's what I wanted to know.


>> Isn't there any easy way to test if this bit is implemented or not jus=
t
>> by setting it up and clear it?
>=20
> So... let's summerise the message that you're giving.
>=20
> "My SoC doesn't implement this bit other than to provide ECC at the L1
> cache, instead implementing a separate ECC scheme for system memory.
> Therefore, I want to change it to describe my implementation, because
> my customers are complaining that it says ECC is disabled when that
> is not the case.  If it can't describe my setup, I want to remove the
> whole facility."
>=20
> That's a very selfish attitude.  Sorry, but it would be wrong of me
> to allow your situation to change what we have beyond the proposed
> patch.

I thought the situation is quite clear here. I am just saying
that there is a way to get it back and it is task for us to educate
our users/customers how to get ecc to work on zynq.

>=20
> I've shown you the ARM architecture reference manual where this bit in
> the page tables is described, both older and newer versions.  What we'r=
e
> doing is in the spirit of the descriptions of bit 9 in the L1 page tabl=
es.
>=20
> I don't think there's any sensible short description which would
> adequately describe this setting which would satisfy both your situatio=
n
> and situations on other SoCs.  We could make the kernel print an entire=

> paragraph on it, something like:

It is not my situation and even not my two use cases.
I just want to make sure that if any "user" just use this without knowing=

what it means that we will get that message back.
I am not saying it is good or bad. Just saying that there is a way how
to get it back. And the purpose of this second email was just check
that we can't detect that. That's it - nothing more nothing less.

>=20
> "ECC might be %sabled.  The exact ECC setting depends on how your SoC
> is implemented.  Please refer to your SoCs technical reference manual
> for a description of bit 9 in the level one page tables for further
> information on how to interpret this statement."
>=20
> but that would be idiotic.

I agree with you and none is asking for this.


> Of course, we could just print nothing, but the purpose of printing thi=
s
> is so that _we_ as developers looking at the kernel messages know the
> status of this bit, particularly when interpreting oops dumps.  Hiding
> this information would make some oops dumps harder to diagnose.  So...
> this is a matter for user education if your users are complaining about=

> it.

I have no problem with that. I just wanted to check that there is no way
how we can detect that. Then your proposed fix is completely fine to me.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--jIbVmJIkNUfcIewbH1E7SCr3aGBugCl1X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEUEARECAAYFAlJxIjwACgkQykllyylKDCGP3gCfVirRFW2RtZ42LRD+hvb6XbYi
hewAli/pf4wpaflp1pBb/sqAY5pVO1U=
=SFfb
-----END PGP SIGNATURE-----

--jIbVmJIkNUfcIewbH1E7SCr3aGBugCl1X--
