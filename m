Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbbAZQVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:21:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbbAZQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:21:40 -0500
Message-ID: <54C6698F.5020301@suse.de>
Date: Mon, 26 Jan 2015 17:21:35 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl> <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu> <54C5FBC3.7030903@suse.de> <54C60A56.7010403@suse.de> <c65880cef67945ebaf61306febc1349b@BN1BFFO11FD010.protection.gbl>
In-Reply-To: <c65880cef67945ebaf61306febc1349b@BN1BFFO11FD010.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="kth46uS2Jkx0lPpfhGQsrWETpXIDhD15U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kth46uS2Jkx0lPpfhGQsrWETpXIDhD15U
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 26.01.2015 um 16:50 schrieb S=C3=B6ren Brinkmann:
> On Mon, 2015-01-26 at 10:35AM +0100, Andreas F=C3=A4rber wrote:
>> Am 26.01.2015 um 09:33 schrieb Andreas F=C3=A4rber:
>>> Am 26.01.2015 um 09:23 schrieb Michal Simek:
>>>> On 01/26/2015 09:19 AM, Andreas F=C3=A4rber wrote:
>>>>> And if I apply it to my -next based tree, adding corresponding node=
s to
>>>>> zynq-parallella.dts, I get repeatedly:
>>>>>
>>>>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT=

>>>>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
>>>>> f090e100 op: f090e140
>>>>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe def=
erral
>>>>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT=

>>>>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
>>>>> f0910100 op: f0910140
>>>>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe def=
erral
>>>>>
>>>>> Am I missing any other patches or config options?
>>>>> (I do notice that the pinctrl v3 patch that got merged has a trivia=
l bug
>>>>> for usb0, for which I'll send a patch later on.)
>>>>
>>>> Why is it deferred? Is it because of pinmuxing stuff?
>>>
>>> No, happened without as well.
>>>
>>> Looking at a different place in dmesg, I spot this:
>>>
>>> [  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset-gp=
ios
>>> [  +0,000012] usb_phy_generic phy0: using device tree for GPIO lookup=

>>> [  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio=
s'
>>> property
>>>  of node '/phy0[0]'
>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio=
'
>>> property
>>> of node '/phy0[0]'
>>> [  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO look=
up
>>> [  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios faile=
d
>>> [  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
>>> [  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
>>> [  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset-gp=
ios
>>> [  +0,000012] usb_phy_generic phy1: using device tree for GPIO lookup=

>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio=
s'
>>> property
>>>  of node '/phy1[0]'
>>> [  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio=
'
>>> property of node '/phy1[0]'
>>> [  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO look=
up
>>> [  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios faile=
d
>>> [  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
>>> [  +0,004337] usb_phy_generic: probe of phy1 failed with error -2
>>>
>>> So, I guess the chipidea driver is deferring because the phys want a
>>> property that neither me nor you are specifying? Would that be the tw=
o
>>> MDIO pins 52 and 53 that would need to be specified?
>>
>> Erm, scratch that last question - wrong PHY. Trying it resolved the
>> above phy errors but not the original problem. And so does an empty on=
e:
>>
>> @@ -99,11 +100,13 @@
>>
>>         usb_phy0: phy0 {
>>                 compatible =3D "usb-nop-xceiv";
>> +               reset-gpios =3D <>;
>>                 #phy-cells =3D <0>;
>>         };
>>
>>         usb_phy1: phy1 {
>>                 compatible =3D "usb-nop-xceiv";
>> +               reset-gpios =3D <>;
>>                 #phy-cells =3D <0>;
>>         };
>>  };
>>
>> In my manuals and notes I can't find any GPIO being used as reset for
>> the USB PHYs. Any thoughts appreciated.
>=20
> Such a connection is optional. The platform might rely on its reset
> circuit, though it might not work for warm reboots.
> I haven't looked at parallela docs, but if there is a schematic
> available, that should tell you if/what is connected to the PHY reset
> pin.

I do have the schematic, and the way I read it, only the on-board reset
button resets the PHYs.

Yet it looks as if usb-nop-xceiv insists on a reset-gpios above, no?
Does it work on your boards with linux-next?

And regarding my previous reporting, I was mistaken: I had to increase
the log buffer size due to enabled pinctrl debugging, which made the phy
errors sometimes appear, depending on timing. They're still there.

Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Felix Imend=C3=B6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,=

Graham Norton; HRB 21284 (AG N=C3=BCrnberg)


--kth46uS2Jkx0lPpfhGQsrWETpXIDhD15U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxmmPAAoJEPou0S0+fgE/HcAP/jMZ0yNuvrStgV0pIPsL4rJW
gVk9QR7zyMsMf/NllfJZYoW3zPW/eu/T0b7MazcPxGVq3uAIsZ7fJdalyiFDaoVQ
xlpZp0j6MJINHqBN9cNUG2HbOCRGvpjxF9PMCEbfsatkZQ//C/n/nSAhSCoELj4j
AqtU5LbYFokicWmxLhBB1ed+UOMHiH2LFgpGbK/6g0Q3rN1xtU8lcQ790Z3sULrS
d3ZR2/GfgqTKbFT1AjZOYukzHavYazDIWJ4tkSJ5d4GzqSW3+tRt19uGO1feTUKz
r/iBnnszWqFcE/dgT8a7/kFlAw5/3VSLM6yQa6xTPtwtnSxp//2wEON6jW2iXtfn
1vlOQLx3pEDhfSV9qqqKbLoqRYCCF2FdPI1d1hd1vTtx6L40/VFGPuCuX0OI+v3F
+ERD9xly2XRrndMka2PigjLaMGxCHy4MGjJwpm6zh0PlYA/95xhOKvwmAh3U4TdQ
ckxGN4bdwFA8pUTHOkOeZgcE8ZY+9fHEnkwiyCFFB62YXZuZHC0Lh2O7L3EzU6E2
nOPujgCRBpjzFHBnxPjrE8EX8XB8ooAkS5KaAVaEWHdQIzU8whkI9vwchiLkIzmk
+290du+KJK4lNjFPnu9fTKLFyEbf2X0OYDb+1QLQLxEwjmJbDmWCjuoKCJGpZypk
1Fc4/jWDuT+K3VLowqu5
=VA47
-----END PGP SIGNATURE-----

--kth46uS2Jkx0lPpfhGQsrWETpXIDhD15U--
