Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030302AbaDJKJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 06:09:18 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33767 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965948AbaDJKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 06:09:13 -0400
Message-ID: <53466DBF.7030606@monstr.eu>
Date: Thu, 10 Apr 2014 12:09:03 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Michal Simek <monstr@monstr.eu>, Punnaiah Choudary <kpc528@gmail.com>,
        Rob Herring <robherring2@gmail.com>,
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
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com> <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local> <20140409113246.GA8778@pd.tnic> <CAL_Jsq+gszc+R_BrLtHKEBGYd=3T+sE1d+-HoF9aYZt6C2k5-g@mail.gmail.com> <20140409151932.GK6529@pd.tnic> <CAHLkNHJTA5bGD1zAfzE2JrDFAWvmgYyYjir+4vR-d9Fe2-E48g@mail.gmail.com> <20140409174701.GO6529@pd.tnic> <53463641.1030800@monstr.eu> <20140410090246.GC29093@pd.tnic>
In-Reply-To: <20140410090246.GC29093@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="0VvOvo4OD33bFmFb7egxpwD48XDSkTK8a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0VvOvo4OD33bFmFb7egxpwD48XDSkTK8a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

>> My question is if using printk in IRQ handler and report problem is
>> equal to reporting this via edac interface. Or it is just easy way
>> to do but using edac interface is right solution and how to do it
>> properly is different question.
>=20
> Yeah, it would probably be easier if you would point out first what you=

> want to use the edac interface for and we can tell you whether it's
> already there/doable/makes sense, etc.

OK. This is the v1 that's why we are having this discussion now
and I really appreciate your recommendation.
It wasn't too complicated to create this driver that's why not big deal
and it is always better to talk about the code and how to handle it prope=
rly.

I had a call with Punnaiah regarding this L2 edac driver and please
correct me if my understanding of pl310 parity error
is wrong (I didn't read pl310 specification).
There are 2 memories in pl310 - data and tag,
Through controller we are able to detect 2 errors:
data parity error and tag parity error.
Both of them are uncorrectable errors and could be just reported.
L2 contains data and instructions together that's why error can
happen in data or instruction part.

The question here is.
This driver is just reporting problem through edac interface
which is counting that errors and provide an unified way
how to report problems.

Maybe as you said we don't need to use edac interface at all
but by design because every error means that there is the problem and
error should be reported and system should be reset because we just
don't know where the problem is. We know that we have a problem.

The question also is if we should execute any code because the problem
can be with instructions and system should just reset.

Isn't there any security issue that even executing any code is a problem?=


=46rom the code I see that IRQ can be raised also for different things
because only errors are handled here (BTW: IRQ_HANDLED should be return w=
hen
IRQ is actually handled).

I just want to make sure that edac is right interface, we have right reac=
tions
and this is how to handle this problem.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--0VvOvo4OD33bFmFb7egxpwD48XDSkTK8a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNGbb8ACgkQykllyylKDCFeEgCfbJjLgaJnmX3OmxBMbnA2hn4U
8CUAoIIG8pwv2bE00c9uUkr+nXq7SW6P
=2CGb
-----END PGP SIGNATURE-----

--0VvOvo4OD33bFmFb7egxpwD48XDSkTK8a--
