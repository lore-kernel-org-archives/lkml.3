Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbbAZIdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 03:33:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbbAZIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 03:33:11 -0500
Message-ID: <54C5FBC3.7030903@suse.de>
Date: Mon, 26 Jan 2015 09:33:07 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: monstr@monstr.eu, Michal Simek <michal.simek@xilinx.com>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: devicetree@vger.kernel.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ola Jeppson <ola@adapteva.com>
Subject: Re: [PATCH v3] ARM: zynq: DT: Add USB to device tree
References: <1417536431-27759-1-git-send-email-soren.brinkmann@xilinx.com> <d78fedd84f354d80985187f851cb3cd1@BN1AFFO11FD055.protection.gbl> <54C5F89A.3090901@suse.de> <54C5F965.90100@monstr.eu>
In-Reply-To: <54C5F965.90100@monstr.eu>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="vK2eVfIOTLc0od0Pp7OgMJh84XtLkNbVw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--vK2eVfIOTLc0od0Pp7OgMJh84XtLkNbVw
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 26.01.2015 um 09:23 schrieb Michal Simek:
> On 01/26/2015 09:19 AM, Andreas F=E4rber wrote:
>> Am 03.12.2014 um 09:39 schrieb Michal Simek:
>>> On 12/02/2014 05:07 PM, Soren Brinkmann wrote:
>>>> Add USB nodes to zc702, zc706 and zed device trees.
>>>>
>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>> ---
>>>> v3:
>>>>  - rename phy nodes: usb_phy -> phy0
>>>>  - rebased onto zynq/dt
>>>> v2:
>>>>  - remove '@0' from phy node name
>>>>  - don't add bogus space
>>>> ---
>>>>  arch/arm/boot/dts/zynq-7000.dtsi | 20 ++++++++++++++++++++
>>>>  arch/arm/boot/dts/zynq-zc702.dts | 11 +++++++++++
>>>>  arch/arm/boot/dts/zynq-zc706.dts | 10 ++++++++++
>>>>  arch/arm/boot/dts/zynq-zed.dts   | 10 ++++++++++
>>>>  4 files changed, 51 insertions(+)
>> [...]
>>>
>>> Applied to zynq/dt.
>>
>> Hm, I don't see this patch in linux-next next-20150123...
>>
>> And if I apply it to my -next based tree, adding corresponding nodes t=
o
>> zynq-parallella.dts, I get repeatedly:
>>
>> [  +0,012242] ci_hdrc ci_hdrc.0: no of_node; not parsing pinctrl DT
>> [  +0,000157] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
>> f090e100 op: f090e140
>> [  +0,000081] platform ci_hdrc.0: Driver ci_hdrc requests probe deferr=
al
>> [  +0,005360] ci_hdrc ci_hdrc.1: no of_node; not parsing pinctrl DT
>> [  +0,000120] ci_hdrc ci_hdrc.1: ChipIdea HDRC found, lpm: 0; cap:
>> f0910100 op: f0910140
>> [  +0,001810] platform ci_hdrc.1: Driver ci_hdrc requests probe deferr=
al
>>
>> Am I missing any other patches or config options?
>> (I do notice that the pinctrl v3 patch that got merged has a trivial b=
ug
>> for usb0, for which I'll send a patch later on.)
>=20
> Why is it deferred? Is it because of pinmuxing stuff?

No, happened without as well.

Looking at a different place in dmesg, I spot this:

[  +0,003988] usb_phy_generic phy0: GPIO lookup for consumer reset-gpios
[  +0,000012] usb_phy_generic phy0: using device tree for GPIO lookup
[  +0,000015] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
property
 of node '/phy0[0]'
[  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
property
of node '/phy0[0]'
[  +0,000010] usb_phy_generic phy0: using lookup tables for GPIO lookup
[  +0,000153] usb_phy_generic phy0: lookup for GPIO reset-gpios failed
[  +0,000012] usb_phy_generic phy0: Error requesting RESET GPIO
[  +0,004360] usb_phy_generic: probe of phy0 failed with error -2
[  +0,004991] usb_phy_generic phy1: GPIO lookup for consumer reset-gpios
[  +0,000012] usb_phy_generic phy1: using device tree for GPIO lookup
[  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpios'
property
 of node '/phy1[0]'
[  +0,000013] of_get_named_gpiod_flags: can't parse 'reset-gpios-gpio'
property of node '/phy1[0]'
[  +0,000010] usb_phy_generic phy1: using lookup tables for GPIO lookup
[  +0,000012] usb_phy_generic phy1: lookup for GPIO reset-gpios failed
[  +0,000011] usb_phy_generic phy1: Error requesting RESET GPIO
[  +0,004337] usb_phy_generic: probe of phy1 failed with error -2

So, I guess the chipidea driver is deferring because the phys want a
property that neither me nor you are specifying? Would that be the two
MDIO pins 52 and 53 that would need to be specified?

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)


--vK2eVfIOTLc0od0Pp7OgMJh84XtLkNbVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUxfvDAAoJEPou0S0+fgE/vTYQAKX2vLOe1zuoM0h6wDbwOxRm
P6n/m100HhTE7XII+GkVE5j6t6uGVMUY2SI7sZyt6ftaQAoHUFtDVJrakLtBNi2r
ljpNhuiEWo1aiF/pi3q3z24pE6aTSt/1I+ox9vG0TKiumzeMSbO6tXiL0evtds1I
zNoEVSj94AmzGKE9eZcWMgzkggtgFa4wUGbjAVbvpwCLesC4CvqZb5XbsFEmNvIq
KIhduhAlGUojYDrorkQeDZop631a7bziG6NjfcFxRbzcW+BVE6hyBS0SC/OVkPRe
5y14pVFa3/CssAQeLXytNPU7il2VWdGKvJBq041NvHTNxuTDGhhjI0+DL6qX0K+s
mN2pSgk3tAmVXMPDiVofjzKvx5wywUoxaqQc1jMuUr1lCETNjemhvF+m2dMR3D9y
ddj1wvOwp2UvxMnK5eder8u5KV7ABKCO0oZ8dzz1Or2Rh5ng106sjW6cwa62k1Bq
lZK3JQ2Nfx3kPs4n53xmqLro36VVUrEINTFcZeXbLg5p/b1Wl223ibmC80OY+iKL
OKz46+D5DjteEJRBxmXMnEH+WXINjjCdUDGg2ucmho2tOx4Z65/P/shwKfBm3tQJ
zWk44wefM3cBStY91pwGI2LweynX0qg2CwXk0ldseGNX9MqShGIlLG14Gt7tsv4f
coe9xALGnJMWiAOIFTJA
=vNY9
-----END PGP SIGNATURE-----

--vK2eVfIOTLc0od0Pp7OgMJh84XtLkNbVw--
