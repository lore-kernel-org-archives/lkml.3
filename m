Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaGHNFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:05:13 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42904 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbaGHNFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:05:06 -0400
Date: Tue, 8 Jul 2014 15:05:02 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 6/9] ARM: tegra: Export tegra_powergate_power_on
Message-ID: <20140708130501.GC9516@ulmo>
References: <1401881559-18469-7-git-send-email-mperttunen@nvidia.com>
 <539F691E.5030204@wwwdotorg.org>
 <20140617121313.GE18816@ulmo>
 <20140617140146.GH3407@tbergstrom-lnx.Nvidia.com>
 <20140617215119.GC24743@mithrandir>
 <20140618121806.GJ3407@tbergstrom-lnx.Nvidia.com>
 <53A1B252.1030204@wwwdotorg.org>
 <20140619080234.GK3407@tbergstrom-lnx.Nvidia.com>
 <53A3096B.1040409@wwwdotorg.org>
 <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20140623101441.GU3407@tbergstrom-lnx.Nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 01:14:42PM +0300, Peter De Schrijver wrote:
> On Thu, Jun 19, 2014 at 06:01:47PM +0200, Stephen Warren wrote:
> > On 06/19/2014 02:02 AM, Peter De Schrijver wrote:
> > > On Wed, Jun 18, 2014 at 05:37:54PM +0200, Stephen Warren wrote:
> > >> On 06/18/2014 06:18 AM, Peter De Schrijver wrote:
> > >>> On Tue, Jun 17, 2014 at 11:51:20PM +0200, Thierry Reding wrote:
> > >>>> * PGP Signed by an unknown key
> > >>>>
> > >>>> On Tue, Jun 17, 2014 at 05:01:46PM +0300, Peter De Schrijver wrote:
> > >>>>> On Tue, Jun 17, 2014 at 02:13:15PM +0200, Thierry Reding wrote:
> > >>>>>>> Old Signed by an unknown key
> > >>>>>>
> > >>>>>> On Mon, Jun 16, 2014 at 04:01:02PM -0600, Stephen Warren wrote:
> > >>>>>>> On 06/04/2014 05:32 AM, Mikko Perttunen wrote:
> > >>>>>>>> This symbol needs to be exported to power on rails without usi=
ng
> > >>>>>>>> tegra_powergate_sequence_power_up. tegra_powergate_sequence_po=
wer_up
> > >>>>>>>> cannot be used in situations where the driver wants to handle =
clocking
> > >>>>>>>> by itself.
> > >>>>>>>
> > >>>>>>> Thierry, are you OK with this change?
> > >>>>>>
> > >>>>>> I would've preferred tegra_powergate_sequence_power_up() to be u=
sed
> > >>>>>
> > >>>>> I don't think the current tegra_powergate_sequence_power_up() API=
 is very well
> > >>>>> defined though. I don't think the clocks and resets required by t=
he sequence
> > >>>>> should be provided by the driver. For one, there can be several c=
locks and
> > >>>>> resets that need to be controlled for a single domain.
> > >>>>
> > >>>> Do you have any suggestions for what the API should look like? Eve=
n if
> > >>>> we plan to move to some different API, I think there's some advant=
age in
> > >>>> using it consistently if for no other reason than to make it easie=
r to
> > >>>> replace occurrences later on.
> > >>>>
> > >>>
> > >>> I think the API should only have the domain ID as input so:
> > >>>
> > >>> int tegra_powerdomain_on(int id)=20
> > >>>
> > >>> /*
> > >>>  * Prerequisites: domain is off
> > >>>  * Result: domain is on, clocks of the modules in the domain are of=
f, modules are in reset
> > >>>  */
> > >>>
> > >>> int tegra_powerdomain_off(int id)
> > >>>
> > >>> /*
> > >>>  * Prerequisites: all clocks of the modules in the domain are off
> > >>>  * result: domain is off
> > >>>  */
> > >>
> > >> That doesn't make sense; the PMC doesn't have access to the clock and
> > >> reset IDs - that's why the API requires them to be passed in.
> > >>
> > >=20
> > > We should make driver look them up by name then. It doesn't make sens=
e to
> > > move this knowledge to the drivers as there can be several modules in=
 1
> > > powerdomain. So every driver would then need to have access to all cl=
ock
> > > and reset IDs of the modules of the domain?
> >=20
> > Having the drivers know the clocks, resets, and power domains that
> > affect their HW module seems perfectly reasonable.
> >=20
>=20
> Yes, but the problem is that you also need clocks and reset of other modu=
les
> in the same domain to safely control the domain's status. Eg: the ISPs, V=
I and
> CSI share a domain. VI and CSI are useable without ISP and the ISP lacks
> public documentation. So it's not unlikely a VI and CSI driver will upstr=
eamed
> someday which means we would need to control the domain and therefore wou=
ld
> need to tell that driver about the ISPs clocks and resets even though the
> driver doesn't know anything about the ISP hw otherwise.

Can't we make powergates reference counted so that they don't get
disabled as long as there are any users? Looking for example at the
display controller driver, modules don't seem to care overly much about
the powergate's state except that it needs to be turned on before they
touch some of the registers.

=46rom a bit of experimentation it also seems like the sequence encoded
within tegra_powergate_sequence_power_up() isn't at all necessary. I
couldn't find an authoritative reference for that either, so I'm tempted
to conclude that it was simply cargo-culted from the dark-ages.

So I'm thinking that if we ever move to use power domains for this, we
may be able to just drop any extra handling (well, we'd need to keep it
for backwards-compatibility... *sigh*) and let drivers handle the clock
and reset resources.

On the other hand, given that we already need to keep the existing code
for backwards-compatibility, I'm not sure there's a real advantage in
turning them into power domains, since we'd be adding extra code without
an clear gains (especially since it seems like we'd need even more code
to properly handle suspend/resume in drivers that need powergates).

> > Do we actually have any case where unrelated modules are in the same
> > power domain /and/ there's some need for those drivers to manipulate the
> > power domain?
> >=20
>=20
> According to the TRM, the reset state of the power domains is undefined. =
While
> that seems unlikely, I do think the kernel should not assume any domain i=
s on
> apart from the obvious ones (like the CPU domain it is running on),

Hm... I thought I had seen some documents specifically giving the reset
states of the power partitions. Perhaps it wasn't in the TRM, though.
But I agree that drivers generally shouldn't be assuming anything about
the power partition states.

Thierry

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTu+x9AAoJEN0jrNd/PrOhu1oP/1RrjaHYZgBcwLXPbGW1/TTP
oiLhsGQpQ7JpB5s/6aQxz+9iLu7NAdou5GfJLKzgSCUjrp/uKRjoIFIqif5EbcDH
vvjQ/zm/NLqFKR39P3YGnsLFfMXBEGVDev5YOsPP6stMfcW7QfcZK3Z7rbbcxxUI
4igRjInxIdxkwn6kZwoH5LhggU59JxRbxldDq786v9jS9QR4Dv3hEYLD2ghwb/2+
F02kgpoNWbCQeDJtXAHJ2GHIl3Mv36eTCHJTNK4bwPSbPAxz+1kCIj7NQueaV8Ow
yLlleTzZbTL+UrU0xbebkz2Wvu6Ddtt+EQtpOjRqHglqHGzP11+0M3gU8xgbAfaf
2YA7ydt94cIDT+hzF9Vh+5PzXN9QMm+VKsJuy2X9jXESDOHksOuzkK/BoRcJ183o
aAZWxAITDOaGHLTUTlHoxc1lESreH0c151YwQhVvzU+N/DjuQOGW17ZMIP0z+KTo
BznMp7P6eHHqrVZ5atdkvPyyxCYIveVqPdCvcf4fpxgsSje9unLjrosol3zCioDs
J8G8eIuVD43C2C3FflYWdrr4Gw2dIK3NrtInXgxFCljVtsuECK2TJJKpTutDteoW
Fv+VkPuQDNMpD/JTQjNYGb5/CxWtxu8BrVQehHu77f43QBnvWpkzPeStPmAYrrSj
3iqJ0wu2dZufCJ0Py13o
=Gbeg
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
