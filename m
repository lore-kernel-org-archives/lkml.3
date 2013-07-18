Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3GRSax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:30:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3GRSav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:30:51 -0400
Message-ID: <1374172235.24793.9.camel@fourier>
Subject: Re: [PATCH 089/145] iommu/vt-d: add quirk for broken interrupt
 remapping on 55XX chipsets
From: Kamal Mostafa <kamal@canonical.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, kernel-team@lists.ubuntu.com,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pci@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Arkadiusz =?UTF-8?Q?Mi=C5=9Bkiewicz?= <arekm@maven.pl>,
        Luis Henriques <luis.henriques@canonical.com>
Date: Thu, 18 Jul 2013 11:30:35 -0700
In-Reply-To: <51E7F192.4000004@mageia.org>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
	 <1374101277-7915-90-git-send-email-kamal@canonical.com>
	 <51E7A0F8.9000308@mageia.org>
	 <20130718103739.GA3626@hmsreliant.think-freely.org>
	 <51E7F192.4000004@mageia.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-r1sKegfcGUQvOHDcZTa8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-r1sKegfcGUQvOHDcZTa8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-07-18 at 16:45 +0300, Thomas Backlund wrote:
> 18.07.2013 13:37, Neil Horman skrev:
> > On Thu, Jul 18, 2013 at 11:02:00AM +0300, Thomas Backlund wrote:
> >> 18.07.2013 01:47, Kamal Mostafa skrev:
> >>> 3.8.13.5 -stable review patch.  If anyone has any objections, please =
let me know.
> >>>
> >>> ------------------
> >>>
> >>> From: Neil Horman <nhorman@tuxdriver.com>
> >>>
> >>> commit 03bbcb2e7e292838bb0244f5a7816d194c911d62 upstream.
> >>>
> >>> A few years back intel published a spec update:
> >>> http://www.intel.com/content/dam/doc/specification-update/5520-and-55=
00-chipset-ioh-specification-update.pdf
> >>>
> >>> For the 5520 and 5500 chipsets which contained an errata (specificial=
ly errata
> >>> 53), which noted that these chipsets can't properly do interrupt rema=
pping, and
> >>> as a result the recommend that interrupt remapping be disabled in bio=
s.  While
> >>> many vendors have a bios update to do exactly that, not all do, and o=
f course
> >>> not all users update their bios to a level that corrects the problem.=
  As a
> >>> result, occasionally interrupts can arrive at a cpu even after affini=
ty for that
> >>> interrupt has be moved, leading to lost or spurrious interrupts (usua=
lly
> >>> characterized by the message:
> >>> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> >>>
> >>> There have been several incidents recently of people seeing this erro=
r, and
> >>> investigation has shown that they have system for which their BIOS le=
vel is such
> >>> that this feature was not properly turned off.  As such, it would be =
good to
> >>> give them a reminder that their systems are vulnurable to this proble=
m.  For
> >>> details of those that reported the problem, please see:
> >>> https://bugzilla.redhat.com/show_bug.cgi?id=3D887006
> >>>
> >>> [ Joerg: Removed CONFIG_IRQ_REMAP ifdef from early-quirks.c ]
> >>>
> >>> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> >>> CC: Prarit Bhargava <prarit@redhat.com>
> >>> CC: Don Zickus <dzickus@redhat.com>
> >>> CC: Don Dutile <ddutile@redhat.com>
> >>> CC: Bjorn Helgaas <bhelgaas@google.com>
> >>> CC: Asit Mallick <asit.k.mallick@intel.com>
> >>> CC: David Woodhouse <dwmw2@infradead.org>
> >>> CC: linux-pci@vger.kernel.org
> >>> CC: Joerg Roedel <joro@8bytes.org>
> >>> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>> CC: Arkadiusz Mi=C5=9Bkiewicz <arekm@maven.pl>
> >>> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> >>> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> >>> ---
> >>>   arch/x86/include/asm/irq_remapping.h |  2 ++
> >>>   arch/x86/kernel/early-quirks.c       | 20 ++++++++++++++++++++
> >>>   drivers/iommu/intel_irq_remapping.c  | 10 ++++++++++
> >>>   drivers/iommu/irq_remapping.c        |  6 ++++++
> >>>   drivers/iommu/irq_remapping.h        |  2 ++
> >>>   5 files changed, 40 insertions(+)
> >>>
> >>
> >> This patch introduces this warning on 3.8 series kernels:
> >>
> >> In file included from arch/x86/kernel/early-quirks.c:21:0:
> >> /kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:46:10:
> >> varning: =E2=80=9Dstruct irq_data=E2=80=9D deklarerad inuti parameterl=
ista
> >> [aktiverat som standard]
> >> /kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:46:10:
> >> varning: dess scope-omr=C3=A5de =C3=A4r endast denna definition eller
> >> deklaration, vilket troligen inte =C3=A4r vad du vill. [aktiverat som
> >> standard]
> >> /kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:50:17:
> >> varning: =E2=80=9Dstruct msi_msg=E2=80=9D deklarerad inuti parameterli=
sta [aktiverat
> >> som standard]
> >>
> >>
> >> You need to add this upstream fix too:
> >>
> >> commit 35d3d814cbd46a85bed97cd74ba97fbbb51e0ccd
> >> Author: Joerg Roedel <joro@8bytes.org>
> >> Date:   Fri Apr 19 20:34:55 2013 +0200
> >>
> >>      iommu: Fix compile warnings with forward declarations
> >>
> > I submited a 3.9 backport that included that fix to -stable over a week=
 ago, you
> > should just be able to use that if you want.
> > Neil
>=20
> Almost, but not enough...
>=20
> The patch you refer to was:
> [3.9 stable PATCH] iommu/vt-d: add quirk for broken interrupt remapping=
=20
> on 55XX chipsets
>=20
> and got merged in 3.9.9.
>=20
> And that added a missing: "#include <linux/irq.h>" in
> arch/x86/include/asm/irq_remapping.h
>=20
> But using that patch it still spits out:
>=20
> kernel/linux-3.8.13.5/arch/x86/include/asm/irq_remapping.h:50:17:
>  >> varning: =E2=80=9Dstruct msi_msg=E2=80=9D deklarerad inuti parameterl=
ista [aktiverat
>  >> som standard]
>=20
>=20
> which is why the additional patch is still needed...
>=20
> --
>=20
> Thomas


Ok, I have replaced the queued patch in linux-3.8.y-review[0] with
Neil's backport[1], and added Joerg's patch[2].  These are (still)
queued up for 3.8.13.5 -stable.

Thanks very much for the heads-up folks.

 -Kamal

[0] http://kernel.ubuntu.com/git?p=3Dubuntu/linux.git;h=3Dlinux-3.8.y-revie=
w;a=3Dshortlog
[1] http://kernel.ubuntu.com/git?p=3Dubuntu/linux.git;a=3Dcommitdiff;h=3Daf=
4e6e26bde03f5203c9e366673623f4a3797639
[2] http://kernel.ubuntu.com/git?p=3Dubuntu/linux.git;a=3Dcommitdiff;h=3D36=
68f1f9e97d4ab0007f357e06fc67ce152c3998


--=-r1sKegfcGUQvOHDcZTa8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR6DRLAAoJEHqwmdxYrXhZi5wP+gLAaAfGxBbBMr4xxyrvllqb
L3KRTtzzkKOLACw9AJruJLnziEj/SN3bjL8maBRWL180feaWvO02zj/XfqNTSlDv
+QFPw99/4Urbv1a55bUtCd43mVzFEtBS7wPzFcyuI0XMdF330+iz+Oo76kGv94th
9fXbCd2BI/j1cM2F7ar0tnbaTTaLrrbtvv+1vvLo50b9CEasdEv9RYfJ8aSHyE++
Yf0ZqEzften1bPTXFPvTSVtHeZ1Ed9xH6ttq25hAHPvrKSWZzOvtv1BKbjDikQ1N
IkYvK5L4jpRfn9nhpTuvkYZj0cmE1t6278mo4A1o6pNfn0uLduKBGr7qoJtKaphM
ouLvXKofHXnI7wkePb3VvBqcvMRY3EfVMSZqKAigI4ghG+FdFwYHc1811TYKJ2Ps
x7tfGgyPsFxxnidGoscXyaTNOKirMo1d9+6FGDfhI3HoJ1spsiAEvLEz+rBTGez0
Nohahs3veGpmvb+cpeBel8J+kdSlxFVxa0Bpz7MjLf9hxKBTlXFbW07Ifd8uv3r2
F3zv2y+c58fvGpmdKO69kyplJXhUkIjFbUhSu4hI7754LgeJm7xwC3RJcrVnm6py
mIhp+nsRvKCNI3mUGlL6mHyfB/eC9V3RTz8C4+2878uY/lRKcjOHig8Un7Ie9nag
j2w3YlQ6H0vodcQDZeb8
=SW8U
-----END PGP SIGNATURE-----

--=-r1sKegfcGUQvOHDcZTa8--

