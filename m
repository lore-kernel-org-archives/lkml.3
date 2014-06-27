Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbaF0Vdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:33:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50777 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaF0Vde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:33:34 -0400
Message-ID: <53ADE328.1080005@wwwdotorg.org>
Date: Fri, 27 Jun 2014 15:33:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, Hiroshi DOyu <hdoyu@nvidia.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave Martin <Dave.Martin@arm.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Paul Walmsley <pwalmsley@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>, Allen Martin <AMartin@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 04/10] memory: Add Tegra124 memory controller support
References: <1403815790-8548-1-git-send-email-thierry.reding@gmail.com> <1403815790-8548-5-git-send-email-thierry.reding@gmail.com> <20140627124638.7ec150cca163c89727b8953f@nvidia.com> <20140627110811.GD2797@ulmo>
In-Reply-To: <20140627110811.GD2797@ulmo>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="iRP0KUiPV5PFsE2Td3VmAJUehJcledoiQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iRP0KUiPV5PFsE2Td3VmAJUehJcledoiQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 06/27/2014 05:08 AM, Thierry Reding wrote:
> On Fri, Jun 27, 2014 at 12:46:38PM +0300, Hiroshi DOyu wrote:
>>
>> Thierry Reding <thierry.reding@gmail.com> writes:
>>
>>> From: Thierry Reding <treding@nvidia.com>
>>>
>>> The memory controller on NVIDIA Tegra124 exposes various knobs that c=
an
>>> be used to tune the behaviour of the clients attached to it.
>>>
>>> Currently this driver sets up the latency allowance registers to the =
HW
>>> defaults. Eventually an API should be exported by this driver (via a
>>> custom API or a generic subsystem) to allow clients to register laten=
cy
>>> requirements.
>>>
>>> This driver also registers an IOMMU (SMMU) that's implemented by the
>>> memory controller.
>>>
>>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>>> ---
>>>  drivers/memory/Kconfig                   |    9 +
>>>  drivers/memory/Makefile                  |    1 +
>>>  drivers/memory/tegra124-mc.c             | 1945 ++++++++++++++++++++=
++++++++++
>>>  include/dt-bindings/memory/tegra124-mc.h |   30 +
>>>  4 files changed, 1985 insertions(+)
>>>  create mode 100644 drivers/memory/tegra124-mc.c
>>>  create mode 100644 include/dt-bindings/memory/tegra124-mc.h
>>
>> I prefer reusing the existing SMMU and having MC and SMMU separated
>> since most of SMMU code are not different from functionality POV, and
>> new MC features are quite independent of SMMU.
>>
>> If it's really convenient to combine MC and SMMU into one driver, we
>> could move "drivers/iomm/tegra-smmu.c" here first, and add MC features=

>> on the top of it.
>=20
> I'm not sure if we can do that, since the tegra-smmu driver is
> technically used by Tegra30 and Tegra114. We've never really made use o=
f
> it, but there are device trees in mainline releases that contain the
> separate SMMU node.

The existing DT nodes do nothing more than instantiate the driver.
However, IIUC nothing actually uses the driver for any purpose, so if we
simply deleted those nodes or changed them incompatibly, there'd be no
functional difference. Perhaps this is stretching DT ABIness very
slightly, but I think it makes no practical difference.


--iRP0KUiPV5PFsE2Td3VmAJUehJcledoiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTreMoAAoJEJuNpwkmVCGchyMP/RMvyiKBagbYiO7NxlbVm0El
as1+Vf95u18zvTQkYpLCj4mwwAB0WQ1F4gQPrlk8DeLVVgiK0cg3FJfn29y2ufLK
bjXWXO9Lq2UtL2MP3fZmttkYUi6SLTsP/NCQVLPPbheAQyJKGjSextI8/lKV8uq1
kufVLFDd+qdYNdM/VJaso1Q6oUn5PB43sft57JudZovzLrAVFfm/6sQXwwTqYfFw
W2CZ+zKBnt2L8L1KBaVvFvZGiizxejvfApgbUrfNhY/q8v0330fU8htg+9z1mgjY
isfeEllFK0wV+Vmq/v2cFDMC3OhpLZp5nq5/fhCAJB2/HNXhP8mEypKeKQHeFvey
TjciyQ3MFI9Rig41o/qKVt5w8Ih8WvY7NCm+6n/yukBfFn8k4cHLteBbrjU6+qhc
+lJ/tmkXgHqF+u+J3iJdmblOrjkLWhDTxQCRpj1M+5gxpdCIXdmMUGRY1TGiqzzm
Wx/GHJ2EdujyWjmrYsO62WwQrRtb2nutytBHk7VCtghmEqWwUOx5fsc/hH4zDrwl
oxQO9L5Knt7tpqoQOqXpYQpoxdcwfMmU6DGi0CVWMncISqAL9JZG+f/eY/wxrgpu
L5QsAx5+19pEtuxeFvTelC9APzNz5ccOl0joRBvYybkqjstsmTd5GxAF4moO1NwQ
2v8lj49ngpi/pssv2j2A
=Ovyz
-----END PGP SIGNATURE-----

--iRP0KUiPV5PFsE2Td3VmAJUehJcledoiQ--
