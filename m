Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3JDRob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:44:31 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:55653 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3JDRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:44:30 -0400
Message-ID: <524EFE76.70200@monstr.eu>
Date: Fri, 04 Oct 2013 19:44:22 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@altera.com>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Yves Vandervennet <rocket.yvanderv@gmail.com>,
        Kyle Teske <kyle.teske@ni.com>, Josh Cartwright <joshc@eso.teric.us>,
        Nicolas Pitre <nico@linaro.org>,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Felipe Balbi <balbi@ti.com>, linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH v2 0/1] FPGA subsystem core
References: <cover.1380727889.git.michal.simek@xilinx.com> <524C6D64.8080801@zytor.com> <20131003064915.GB17155@amd.pavel.ucw.cz> <524EC965.70701@monstr.eu> <20131004141646.GA9396@kroah.com> <d700a91e-1319-4c35-895d-55e323c40703@email.android.com> <524ED081.1040600@monstr.eu> <524EF0CE.4040002@zytor.com>
In-Reply-To: <524EF0CE.4040002@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="cJIjtimtJic7IwV33Rx9Q2BWhshpaACof"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--cJIjtimtJic7IwV33Rx9Q2BWhshpaACof
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 10/04/2013 06:46 PM, H. Peter Anvin wrote:
> On 10/04/2013 07:28 AM, Michal Simek wrote:
>> On 10/04/2013 04:21 PM, H. Peter Anvin wrote:
>>> Yes; I never got too corner Greg ;)
>>>
>>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>>>> On Fri, Oct 04, 2013 at 03:57:57PM +0200, Michal Simek wrote:
>>>>> But anyway what was resolution from that meeting?
>>>>
>>>> It never happened, we got distracted by lunch :)
>>
>> Then why not to have it here?
>>
>=20
> The essential question is if the firmware interface really is
> appropriate for FPGAs.  It definitely has a feel of a "square peg in a
> round hole", especially when you consider the myriad ways FPGAs can be
> configured (some persistent, some not, some which takes effect now,
> some which come later, some which involve bytecode interpreters...)
> and considering reconfiguration and partial reconfiguration.

If you look at it in general I believe that there is wide range
of applications which just contain one bitstream per fpga and the bitstre=
am is replaced
by newer version in upgrade. For them firmware interface should be pretty=
 useful.
Just setup firmware name with bitstream and it will be automatically load=
ed in
startup phase.

Then there is another set of applications especially in connection to par=
tial reconfiguration
where this can be done statically by pregenerated partial bitstreams
or automatically generated on target cpu. For doing everything on the tar=
get
firmware interface is not the best because everything can be handled by u=
ser application
and it is easier just to push this bitstream to do device and not to save=
 it
to the fs.

I think the question here is if this subsystem could have several interfa=
ces.
For example Alan is asking for adding char support.
Does it even make sense to have more interfaces with the same backend dri=
ver?
When this is answered then we can talk which one make sense to have.
In v2 is sysfs and firmware one. Adding char is also easy to do.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--cJIjtimtJic7IwV33Rx9Q2BWhshpaACof
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJO/nYACgkQykllyylKDCEdPQCeL8aYPCjJkwEm1UslWWKFF816
Z2AAnjoSJCeVq1OTddOGkLJtxF+PPfvf
=Cil7
-----END PGP SIGNATURE-----

--cJIjtimtJic7IwV33Rx9Q2BWhshpaACof--
