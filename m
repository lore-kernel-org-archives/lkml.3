Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaH2PST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 11:18:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823AbaH2PSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 11:18:15 -0400
Message-ID: <540099AF.4020005@suse.de>
Date: Fri, 29 Aug 2014 17:18:07 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] ARM: zynq: DT: Add Ethernet phys
References: <1408550219-19825-1-git-send-email-soren.brinkmann@xilinx.com> <1408550219-19825-3-git-send-email-soren.brinkmann@xilinx.com> <5a7b6f57-b6c0-4fb3-af0d-d403277c0207@BN1AFFO11FD045.protection.gbl> <53F5D8D9.7040604@suse.de> <f166a186-301c-4288-97cf-71f8173c07e7@BN1AFFO11FD010.protection.gbl> <CAGVrzcYWN83tznwvw1M9V_mwWgobs2kwtRvEj4stqE=XGC10fg@mail.gmail.com> <20140825174610.GA13737@obsidianresearch.com> <53FB9AC4.8010704@gmail.com> <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl>
In-Reply-To: <660fe929-1f16-4e22-8bd3-0388cd363978@BY2FFO11FD038.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="L9SjPjK87rLQL0d6dcRU2bdsfjHCWwCCn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L9SjPjK87rLQL0d6dcRU2bdsfjHCWwCCn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 29.08.2014 16:08, schrieb Michal Simek:
> On 08/25/2014 10:21 PM, Florian Fainelli wrote:
>> On 08/25/2014 10:46 AM, Jason Gunthorpe wrote:
>>> On Fri, Aug 22, 2014 at 01:47:09PM -0700, Florian Fainelli wrote:
>>>
>>>>>  - the ID based strings seem to be not needed since, IIUC, the core=

>>>>>    reads the ID from the PHY and uses it, so I just left it out not=

>>>>>    trying to figure out how to obtain the correct ID
>>>>
>>>> It is not needed, but it is one way to specify a PHY device if you d=
o
>>>> not know what compatible string to use instead.
>>>
>>> No, it is a way to specify a PHY device if the kernel can't auto prob=
e
>>> the Phy ID.
>>>
>>> Last I checked, the kernel doesn't support plain text compatible
>>> strings for phys - everything is driven on the phy id, either auto
>>> probed or specified in the DT.
>>
>> That's right. Some PHY drivers might be relying on specific compatible=

>> strings though, but not the core PHY library that probes and maps a
>> driver to a PHY node.
>>
>>>
>>>>>  - the marvell compatible strings are used in our vendor tree. They=

>>>>>    aren't used anywhere but in our vendor tree. I though keeping th=
em is
>>>>>    nice since it identifies the PHY fully. And in case that level o=
f
>>>>>    detail is needed at some point it is already there.
>>>>
>>>> And this is the recommended way to do it in case we ever need to key=
 a
>>>> software decision based on the hardware.
>>>
>>> All compatible strings need to be documented.
>>>
>>> .. and they need to encode more information than you get from the phy=

>>> id - die revsision, package option, functional options, voltage
>>> codes. Etc.
>>>
>>> .. and they actually need to be *right*
>>
>> Agreed.
>>
>>>
>>> An example: The kernel reports 88E1318S for all four chips in that
>>> family, AFAIK you have to read the package marking to figure out whic=
h
>>> you have (it is the same die, with options switched on/off at
>>> packaging time). People have already posted patches trying to
>>> helpfully add a 'marvell,88E1318S' compatible string based on kernel
>>> output. Except it is wrong, it isn't actually the '8S version in the
>>> HW.
>>>
>>> Even worse, Marvell has a whole series of socket compatible phys. Jus=
t
>>> because the board the DT author looked at has a '318, doesn't mean
>>> that every board ever made will. We've actually already been switchin=
g
>>> between the 318 and 318S for production depending on which has part
>>> availability.
>>>
>>> Basically: don't try to override self-discoverable hardware in DT
>>> without a really good reason.
>>
>> I think that's a very good point, at the very least let's use a
>> compatible string that contains the full 32-bits PHY OUI.
>=20
> I think resolution is:
> 1. Do not use marvell,88e1518 because it is not listed anywhere
> 2. Do not add ethernet-phy-idAAAA.BBBB because it breaks autodetection
> if there is different phy on the board and we shouldn't restrict us in =
this.
> In spite of autodetection takes some time.
> 3. "ethernet-phy-ieee802.3-c22" is optional that's why doesn't need to =
be added
> 4. Any listed compatible string has to be parsed which takes time
>=20
> That's why I think make sense not to use any compatible string.
> This should give us all flexibility which we want to have.

Sorry, but we do need some node that we can reference via phy-handle
from the gem node, don't we?

In that case, is not specifying any compatible string a valid option?

If you don't want to specify the IDs, then I would've assumed we need to
specify the -c22 in order to have *some* compatible string in order to
trigger loading of the appropriate driver module.

Regards,
Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer; HRB 16746 AG N=C3=BC=
rnberg


--L9SjPjK87rLQL0d6dcRU2bdsfjHCWwCCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUAJmyAAoJEPou0S0+fgE/btsP/1Vjwczj47L41H3pUJAAmzT4
UVJr7/EPUzSWMekRUL82SxTXJdVHzZtuu+5CMoIDva+GQpdQnCsZysAMCK0WC03H
OfG1VL2A21FAjA+/67mau4uh/AcPecgGYe6Fy5lkW3hmv2ToPnAzLrOFofXrZjrG
6EmElRzwQ+pW5pRHAkXvyO47cr6/8WCfg8QMckAgpejpQQUIQWPjQ7t4Hx2NuMW6
4dxJRtf0wmvH5nG+Fzr6Pw/fyrQ1zgMETE4a7dDoILbc145t/8OnujKx5+0qqmQX
mC3IequtbMBjYr+0cBal0MIptFhgQ0te6BbGg7LJF2yjMDovvNxs2hLS1OD1nObx
Oi55RwgnMDgmvnFd8/c9AUk/ymHcdTOQfS8WBwhiFv6BZY/0CDb0i13CW1pxT0XA
+GCu35HWdP9XCu+CTUwiRzTuwXfjwDpR05Msb0BVZ7XejUdpMe1D+CWxpYkzeuAd
PSBM9MWfHerZQ26cV79AIlyvw8Eoma8NqBVV1V1bSanYAkEmU5QlWykzysNvQ0ZU
UeptIarS+zlGMgAJwlmsZbC0PNLrN4v6hjjlfEmXlmIiIfy3BDv58IGrI4/o9Mxz
DfhajYNrrbzlgTdRrQ9X+iaDfm62V9XmgA8PyBQmcEQx+IYDXSYHAQJoni/n4TTs
uIgz/k++al6inabvRHq/
=AYo3
-----END PGP SIGNATURE-----

--L9SjPjK87rLQL0d6dcRU2bdsfjHCWwCCn--
