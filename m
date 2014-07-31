Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaGaJvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 05:51:18 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53161 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbaGaJvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:51:15 -0400
Date: Thu, 31 Jul 2014 11:51:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Olof Johansson <olof@lixom.net>
Cc: Mark Rutland <mark.rutland@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <Will.Deacon@arm.com>, Joerg Roedel <joro@8bytes.org>,
        Cho KyongHo <pullip.cho@samsung.com>,
        Grant Grundler <grundler@chromium.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Olav Haugan <ohaugan@codeaurora.org>,
        Varun Sethi <varun.sethi@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] devicetree: Add generic IOMMU device tree bindings
Message-ID: <20140731095103.GB31218@ulmo>
References: <1404487757-18829-1-git-send-email-thierry.reding@gmail.com>
 <20140730152646.GC20162@leverpostej>
 <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <CAOesGMi3zM1-cqmeGddJ69RNXx0ktFm_zXO_yq7N0EeA3HNrUQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 10:35:06AM -0700, Olof Johansson wrote:
> Hi,
>=20
> On Wed, Jul 30, 2014 at 8:26 AM, Mark Rutland <mark.rutland@arm.com> wrot=
e:
> > Hi Thierry,
> >
> > This looks sane to me.
> >
> > I just have a few questions below which are hopefully simple/stupid.
> >
> > On Fri, Jul 04, 2014 at 04:29:17PM +0100, Thierry Reding wrote:
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> This commit introduces a generic device tree binding for IOMMU devices.
> >> Only a very minimal subset is described here, but it is enough to cover
> >> the requirements of both the Exynos System MMU and Tegra SMMU as
> >> discussed here:
> >>
> >>     https://lkml.org/lkml/2014/4/27/346
> >>
> >> Signed-off-by: Thierry Reding <treding@nvidia.com>
> >> ---
> >> Changes in v4:
> >> - clarify that disabling an IOMMU DT node may not disable translation
> >> - be more explicit that examples are only examples
> >> - add multi-ID master example
> >>
> >> Changes in v3:
> >> - use #iommu-cells instead of #address-cells/#size-cells
> >> - drop optional iommu-names property
> >>
> >> Changes in v2:
> >> - add notes about "dma-ranges" property (drop note from commit message)
> >> - document priorities of "iommus" property vs. "dma-ranges" property
> >> - drop #iommu-cells in favour of #address-cells and #size-cells
> >> - remove multiple-master device example
> >>
> >>  Documentation/devicetree/bindings/iommu/iommu.txt | 172 +++++++++++++=
+++++++++
> >>  1 file changed, 172 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/iommu/iommu.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/iommu/iommu.txt b/Docum=
entation/devicetree/bindings/iommu/iommu.txt
> >> new file mode 100644
> >> index 000000000000..464a81eaaf61
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/iommu/iommu.txt
> >> @@ -0,0 +1,172 @@
> >> +This document describes the generic device tree binding for IOMMUs an=
d their
> >> +master(s).
> >> +
> >> +
> >> +IOMMU device node:
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +An IOMMU can provide the following services:
> >> +
> >> +* Remap address space to allow devices to access physical memory rang=
es that
> >> +  they otherwise wouldn't be capable of accessing.
> >> +
> >> +  Example: 32-bit DMA to 64-bit physical addresses
> >> +
> >> +* Implement scatter-gather at page level granularity so that the devi=
ce does
> >> +  not have to.
> >> +
> >> +* Provide system protection against "rogue" DMA by forcing all access=
es to go
> >> +  through the IOMMU and faulting when encountering accesses to unmapp=
ed
> >> +  address regions.
> >> +
> >> +* Provide address space isolation between multiple contexts.
> >> +
> >> +  Example: Virtualization
> >> +
> >> +Device nodes compatible with this binding represent hardware with som=
e of the
> >> +above capabilities.
> >> +
> >> +IOMMUs can be single-master or multiple-master. Single-master IOMMU d=
evices
> >> +typically have a fixed association to the master device, whereas mult=
iple-
> >> +master IOMMU devices can translate accesses from more than one master.
> >> +
> >> +The device tree node of the IOMMU device's parent bus must contain a =
valid
> >> +"dma-ranges" property that describes how the physical address space o=
f the
> >> +IOMMU maps to memory. An empty "dma-ranges" property means that there=
 is a
> >> +1:1 mapping from IOMMU to memory.
> >> +
> >> +Required properties:
> >> +--------------------
> >> +- #iommu-cells: The number of cells in an IOMMU specifier needed to e=
ncode an
> >> +  address.
> >> +
> >> +The meaning of the IOMMU specifier is defined by the device tree bind=
ing of
> >> +the specific IOMMU. Below are a few examples of typical use-cases:
> >> +
> >> +- #iommu-cells =3D <0>: Single master IOMMU devices are not configura=
ble and
> >> +  therefore no additional information needs to be encoded in the spec=
ifier.
> >> +  This may also apply to multiple master IOMMU devices that do not al=
low the
> >> +  association of masters to be configured. Note that an IOMMU can by =
design
> >> +  be multi-master yet only expose a single master in a given configur=
ation.
> >> +  In such cases the number of cells will usually be 1 as in the next =
case.
> >> +- #iommu-cells =3D <1>: Multiple master IOMMU devices may need to be =
configured
> >> +  in order to enable translation for a given master. In such cases th=
e single
> >> +  address cell corresponds to the master device's ID. In some cases m=
ore than
> >> +  one cell can be required to represent a single master ID.
> >> +- #iommu-cells =3D <4>: Some IOMMU devices allow the DMA window for m=
asters to
> >> +  be configured. The first cell of the address in this may contain th=
e master
> >> +  device's ID for example, while the second cell could contain the st=
art of
> >> +  the DMA window for the given device. The length of the DMA window i=
s given
> >> +  by the third and fourth cells.
> >> +
> >> +Note that these are merely examples and real-world use-cases may use =
different
> >> +definitions to represent their individual needs. Always refer to the =
specific
> >> +IOMMU binding for the exact meaning of the cells that make up the spe=
cifier.
> >> +
> >> +
> >> +IOMMU master node:
> >> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >> +
> >> +Devices that access memory through an IOMMU are called masters. A dev=
ice can
> >> +have multiple master interfaces (to one or more IOMMU devices).
> >> +
> >> +Required properties:
> >> +--------------------
> >> +- iommus: A list of phandle and IOMMU specifier pairs that describe t=
he IOMMU
> >> +  master interfaces of the device. One entry in the list describes on=
e master
> >> +  interface of the device.
> >> +
> >> +When an "iommus" property is specified in a device tree node, the IOM=
MU will
> >> +be used for address translation. If a "dma-ranges" property exists in=
 the
> >> +device's parent node it will be ignored. An exception to this rule is=
 if the
> >> +referenced IOMMU is disabled, in which case the "dma-ranges" property=
 of the
> >> +parent shall take effect. Note that merely disabling a device tree no=
de does
> >> +not guarantee that the IOMMU is really disabled since the hardware ma=
y not
> >> +have a means to turn off translation.
>=20
> How do you know if the IOMMU is disabled then? Runtime by checking
> status of the iommu?

I don't think you can really know that it is disabled. If it's disabled
in device tree then you don't have a way of querying it either. This is
probably an issue that needs to be resolved at integration time.

Generally I'd think that if an IOMMU is capable of enable or disabling
translation it will be disabled by default for all masters. Therefore if
the device tree node is status =3D "disabled", then there's no driver that
will set it up and enable translation, so the IOMMU can be considered to
be disabled. If an IOMMU has translations always enabled with no means
to disable them, then does it make sense to set the status =3D "disabled"
on the IOMMU? I think not. No driver would be setting up the mappings
within the IOMMU and translations would always fail. For IOMMUs that
have no way to enable translations... well... they wouldn't be IOMMUs.

So I think we should either drop that last sentence or be more explicit
in that disabling an IOMMU device (via device tree) that can't turn off
address translation is invalid:

	Note that merely disabling a device tree node does not guarantee
	that the IOMMU is really disabled since the hardware may not
	have a means to turn off translation. But it is invalid in such
	cases to disable the IOMMU's device tree node in the first place
	because doing so would prevent any driver from properly setting
	up the translations.

> >> +Multiple-master IOMMU:
> >> +----------------------
> >> +
> >> +     iommu {
> >> +             /* the specifier represents the ID of the master */
> >> +             #iommu-cells =3D <1>;
> >> +     };
> >> +
> >> +     master@1 {
> >> +             /* device has master ID 42 in the IOMMU */
> >> +             iommus =3D <&/iommu 42>;
> >> +     };
> >> +
> >> +     master@2 {
> >> +             /* device has master IDs 23 and 24 in the IOMMU */
> >> +             iommus =3D <&/iommu 23>, <&/iommu 24>;
> >> +     };
> >
> > In future I suspect master will need to be able to identify which master
> > IDs correspond to which of their master ports (where each port might
> > have an arbitrary number of master IDs).
> >
> > While we don't need that for the first run, it would be nice to have
> > that looked into so master bindings don't come up with arbitrarily
> > different ways of doing that.
>=20
> iommu-names would be the logical extension to handle that, just like
> we do with other resources, right?

iommu-names used to be in the bindings as an optional property until v3
where it was dropped upon request by Rob and Arnd on the grounds of
being overengineered by modeling the binding after that of other
subsystems.

But I still think that if we ever want to support multiple-master IOMMUs
then an iommu-names property will be required to tell them apart.

Either that or bindings will have to specify a fixed ordering.

> >> +Multiple-master IOMMU with configurable DMA window:
> >> +---------------------------------------------------
> >> +
> >> +     / {
> >> +             #address-cells =3D <1>;
> >> +             #size-cells =3D <1>;
> >> +
> >> +             iommu {
> >> +                     /* master ID, address and length of DMA window */
> >> +                     #iommu-cells =3D <4>;
> >> +             };
> >> +
> >> +             master {
> >> +                     /* master ID 42, 4 GiB DMA window starting at 0 =
*/
> >> +                     iommus =3D <&/iommu  42  0  0x1 0x0>;
> >
> > Is this that window is from the POV of the master, i.e. the master can
> > address 0x0 to 0xffffffff when generating transactions, and these get
> > translated somehow?
> >
> > Or is this the physical addresses to allocate to the master?
>=20
> It needs to be clarified in the documentation, but as far as I know it
> is the DMA address space that is used.
>=20
> It is somewhat confusing to have size-cells =3D 1 and then use 2 cells
> for size in the iommu property. It's legal and expected, but having
> size-cells in the example adds a little confusion.

I've changed the above to say:

	/ {
		iommu {
			/*
			 * One cell for the master ID and one cell for the
			 * address of the DMA window. The length of the DMA
			 * window is encoded in two cells.
			 *
			 * The DMA window is the range addressable by the
			 * master (i.e. the I/O virtual address space).
			 */
			#iommu-cells =3D <4>;
		};

		master {
			/* master ID 42, 4 GiB DMA window starting at 0 */
			iommus =3D <&{/iommu}  42  0  0x1 0x0>;
		};
	};

The #size-cells =3D <1> was a remainder of an earlier example that didn't
use #iommu-cells. #address-cells and #size-cells are irrelevant for the
example, so removing them makes sense (and reduces confusion).

Does that look better?

Thierry

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT2hGHAAoJEN0jrNd/PrOh138QAKznOfedUcB3/hdA/uTVsjBf
Zg9z19TA5NTD78gLeBcF9dQzo31dygKt7L9xeRCU7GPym4/UIvEN+yPAsnvrZliQ
ljXv970mEz/GUuK+3UIwRZ2V+DEfCOg4DlDMIhdVdVnqW25G3gVSlpZR0vKc/5vq
vL1ybYFmtnYkzqqB107N/GLRQadezivZ1gi0foooMG5+PmSwcDdlmLSo4vitO1QI
TXNMqTeN+fpEfTZDrC2bm3afxghczsJkQIOcK3yiDnJe9ezgv+gxEOMwQKdtW8eG
pDB150ZX4M67SPiKeZaqeV+UNsgIQ/kQVAUhYIA2FBZRpdOqZIZnd7wE/Z6WgbUi
k9nRkMTzcTGXVb5hHSLorGRxLDk3PXyBVWYV6pDRjNbvkH6MDdFF38fnUTOOcYOI
cGrUB0OJoPQ9FkGabd0N7SnBJOa7rBy9DcwUnzYtpIVhun+6D38pd8Hwp+JYV6yO
LmJtgHk8Sy68pu0uuvS4g/iGbtD445cebrNCaXJoZRbNys4Vz4KGVdjNjRQJl81F
MBoHsO5eQD1cImsidupZSQbku1mtl2Hbkou8wOpUBnCjCSsHOGDfyZolQXEmlauM
AwfxN8YGlOZdIBOgKEjh3Q77Z6FhYsoEaF1csPdnkim1U2Xf0c4wFh3FVPLVUEFx
dJ0Wu/+9/KJlyubFIYaG
=5SED
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
