Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164AbaKYMMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:12:21 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51783 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaKYMMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:12:19 -0500
Message-ID: <5474720F.5030106@ti.com>
Date: Tue, 25 Nov 2014 14:11:59 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: David Herrmann <dh.herrmann@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Luc Verhaegen <libv@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: linux-next: build failure after merge of the omap_dss2 tree
References: <20141117190905.4e96294a@canb.auug.org.au>	<546B5D5A.8020304@ti.com> <CANq1E4SMLHmezfXSENSQ8xUaXptwA8YKQ9Nne=sDCB0gPkPLmA@mail.gmail.com> <5474615F.20407@ti.com> <5474660B.8070507@redhat.com>
In-Reply-To: <5474660B.8070507@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="5a3J5qHR81gld1Wtv6Q7wTtRjoDou65jJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5a3J5qHR81gld1Wtv6Q7wTtRjoDou65jJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 25/11/14 13:20, Hans de Goede wrote:
> Hi Tomi,
>=20
> On 11/25/2014 12:00 PM, Tomi Valkeinen wrote:
>> On 18/11/14 17:07, David Herrmann wrote:
>>> Hi
>>>
>>> On Tue, Nov 18, 2014 at 3:53 PM, Tomi Valkeinen
>>> <tomi.valkeinen@ti.com> wrote:
>>>> Hi,
>>>>
>>>> Thanks Stephen!
>>>>
>>>> Hans, have you had a look at this? kbuild test bot also reported thi=
s.
>>>
>>> The fix from Stephen should not go to main-line. It breaks simplefb o=
n
>>> x86 without OF. Imo, linux/clk.h should provide a fallback if OF is
>>> not defined (like it already does for of_clk_get() and friends).
>>>
>>> Hans, any comments?
>>
>> Hans, ping.
>=20
> Sorry I somehow missed this thread so far, I did see the kbuild mail, b=
ut
> it looked like a false positive to me, for the compile error case I
> already fixed
> in the last revision of the patch, adding #ifdef CONFIG_OF around the
> offending code.
>=20
> But on closer inspection I see that the entirety of linux/clk-provider.=
h
> is wrapped
> in one huge #ifdef CONFIG_COMMON_CLK and then later on also has:
>=20
> #ifdef CONFIG_OF
> ...
> int of_clk_get_parent_count(struct device_node *np);
> ...
> #endif
>=20
> So we need both CONFIG_OF and CONFIG_COMMON_CLK, the attached patch
> should fix this.

Thanks, applied.

 Tomi



--5a3J5qHR81gld1Wtv6Q7wTtRjoDou65jJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdHIPAAoJEPo9qoy8lh71g6QP/AhfyO81UhZcLsGVxxb+0tRC
hf0+DB607fpiCTTrszRQgsd2UzzAJ6CZ2iyINLYSztPY1iP3ECCdlu8qENh0xBEe
HAw2xoEEqlk5QUwkdVFEVIjA+7cH4KA0nq2M3sqbRbiXcNYL6HOPkis8Z5mzla7G
bKNx8glaCNl9F9u/uJSCy//MdccglPbEy5IfNaj/GymzIDDEOw/v75IY90fGy1+g
MiYOTm0mJ82/NvpniuYK3I1boU5yCfH23a2xX+5NxeiFQGL0KqF3xw+dyLBS1ibG
A477zhTM2vd53iOuMqNcfNkq7B/0235KBnTOgehmnhYelWqkBWcNe48BG8rw2YDA
PSRtuJYWft2k6qvAdFSV2nfDmLwaGHrGPiz8tBvjbhmNeCFxszCpnPI5O1DF/AZz
xUIaUc7Rinp03j+3u7MZU/Q6lxRuMtjBQi1MRqnhH5h1sCqY6+V4C96jn5KqQIGz
M1T2z/28MvbEPPJUiQ6gbAxvjzy2M17t/HS80pKbtnItCeJs1BKvM0sLmA9rQMsH
iwAGN/JGKtcojL8tQGc48HHc76lnCHywrSW4qwS94zHBVHghp2cYNPw1cY1z4Tiy
91wd6epm6F5fhqRg/KVKrLFvIEo7ID9AKBGgjnBpkN8z2rRQ+qs1SQtLYUCggzEU
bhUOORLeEnCqInebzoHj
=p5yZ
-----END PGP SIGNATURE-----

--5a3J5qHR81gld1Wtv6Q7wTtRjoDou65jJ--
