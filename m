Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaIWQhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:37:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:57458 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013AbaIWQhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:37:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="390455551"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
CC: Borislav Petkov <bp@alien8.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAADXwAgACyqwCAAHIRAIAAG/KA
Date: Tue, 23 Sep 2014 16:29:37 +0000
Message-ID: <04948956-998A-4369-B644-C920299FF629@intel.com>
References: <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <1411420912.2513.32.camel@jtkirshe-mobl.jf.intel.com>
 <20140923080120.GA22072@pd.tnic> <20140923144936.GA9844@thin>
In-Reply-To: <20140923144936.GA9844@thin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.72]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_8C8A84AA-490B-4DEE-B23B-6C796F24AF43";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_8C8A84AA-490B-4DEE-B23B-6C796F24AF43
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Sep 23, 2014, at 7:49 AM, Josh Triplett <josh@joshtriplett.org> =
wrote:

> On Tue, Sep 23, 2014 at 10:01:20AM +0200, Borislav Petkov wrote:
>> ./arch/x86/include/asm/io_apic.h: In function =91io_apic_modify=92:
>> ./arch/x86/include/asm/io_apic.h:223:48: warning: declaration of =
=91apic=92 shadows a global declaration [-Wshadow]
>> static inline void io_apic_modify(unsigned int apic, unsigned int =
reg, unsigned int value)
>>                                                ^
>> In file included from ./arch/x86/include/asm/smp.h:12:0,
>>                 from include/linux/smp.h:59,
>>                 from include/linux/topology.h:33,
>>                 from include/linux/gfp.h:8,
>>                 from include/linux/kmod.h:22,
>>                 from include/linux/module.h:13,
>>                 from drivers/edac/amd64_edac.h:65,
>>                 from drivers/edac/amd64_edac.c:1:
>> ./arch/x86/include/asm/apic.h:366:21: warning: shadowed declaration =
is here [-Wshadow]
>> extern struct apic *apic;
>>                     ^
>>=20
>> So gcc complains that an unsigned int shadows a struct apic pointer.
>=20
> Here, I think the right fix involves picking a more descriptive name
> than "apic" for the global varible.

I agree, but I don't know enough about the area to necessarily know what =
it should be called instead. I do have a patch that changes the local =
variables instead, but even as I made it, I didn't really think it was =
right. But it silenced a ton of warnings and let me see other things.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_8C8A84AA-490B-4DEE-B23B-6C796F24AF43
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIZ/xAAoJEDwO/+eO4+5ucCoQAI0CCfqNdsuzH1FSwKiIVEBo
eO3wHgSBZvwAigHO0f8ItDpZ2TwPdmB6OMjrCSc5YwETh8rbcNC8B/EIcxgWjldJ
LSFm9OfYe3E99DZHb3rtLzpM0FwU7gY6zcJnGNsIQs/dABU/Vs/xZwZfMRwao8q6
qa5GkwDcM6iL0XX7f4UYqjWb1z1Vah504Y29Gp8JXoxXFJuLm4ISz5j4kjprAJJm
8uIhLICmzy0G+T1SIGvo5eKuhwvzVY/4ptsLDeVQoUv/osfc/8sM1AFcDISSj2fH
t+GNq0R2pngrgWTj7a/+IP/pEOnwIeASy78kp4EERT2f2eKtgiQdcQTBXNGG6e8Z
VcG+/UnH4MZzjicnRfJlo9N6KtgnDHf+bEAOFClrBe6Ecv5XgMzLJiqhAYk1NquA
Fc+cZKqjpo0G7C7XdSsUUfpPtbNiru8p3/GpGMZLpUPaEEGnJFjyNdOUVNJJuMzh
zpPd9B+jGwmOS3Bq0QMAsAVW24b+jcVwefNrjTx2WgMWOMNqBYCIGEW0w99iCMiC
BqoGRBXOzmmu114T46QytXr6EKQTwUzdqbgK8bqHIcNIxHi3Z0rVfFm7tDT2eBCO
p724R9H5Scac/42REjOZEJyrlwp2aizT53/MTJssUNMmOCYI8zfG0XXfC4z9o6jT
+qhzb/n2CCWJcRYhYPKv
=Jjjb
-----END PGP SIGNATURE-----

--Apple-Mail=_8C8A84AA-490B-4DEE-B23B-6C796F24AF43--
