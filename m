Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3JDOgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 10:36:10 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43466 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543Ab3JDOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 10:36:08 -0400
Date: Fri, 4 Oct 2013 09:36:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <b.zolnierkie@samsung.com>,
        <m.szyprowski@samsung.com>, <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] USB: gadget: s3c-hsotg: add isochronous transfers
 support
Message-ID: <20131004143602.GF16059@radagast>
Reply-To: <balbi@ti.com>
References: <1380016036-20983-1-git-send-email-r.baldyga@samsung.com>
 <20131001144527.GX1476@radagast>
 <524BF6AD.8000908@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iBwuxWUsK/REspAd"
Content-Disposition: inline
In-Reply-To: <524BF6AD.8000908@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--iBwuxWUsK/REspAd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 02, 2013 at 12:34:21PM +0200, Robert Baldyga wrote:
> On 10/01/2013 04:45 PM, Felipe Balbi wrote:
> Hello,
> >Hi,
> >
> >On Tue, Sep 24, 2013 at 11:47:16AM +0200, Robert Baldyga wrote:
> >>Hello,
> >>
> >>This is update for my proposal for isochronous transfers support in s3c=
-hsotg
> >>driver. I've fixed issuses pointed by Bartlomiej Zolnierkiewicz. For mo=
re
> >>information, please check the change log at the end of the mail.
> >
> >this shouldn't be part of commit log.
> >
> >>This patch adds isochronous transfer support. It adds few modifications:
> >>- Modify s3c_hsotg_write_fifo() function. It actually calculates transf=
er
> >>   size, taking into account Multi Count value, which indicates number =
of
> >>   transactions per microframe.
> >>- Fix s3c_hsotg_start_req() function by setting number of packets to Mu=
lti
> >>   Count field in DIEPTSIZ register for isochronous endpoints.
> >>- Fix s3c_hsotg_set_ep_maxpacket() function. Field wMaxPacketSize of en=
dpoint
> >>   descriptor is now splitted into maximum packet size value and number=
 of
> >>   additional transaction per microframe.
> >>- Modify s3c_hsotg_epint() function. Some interrupts are ignored for
> >>   isochronous endpoints, (e.g. INTknTXFEmpMsk) becouse isochronous req=
uest is
> >>   always transfered in single transaction, which ends with XferCompl i=
nterrupt.
> >>   Add Odd/Even microframe toggle to allow data transfering in each mic=
roframe.
> >>- Fix s3c_hsotg_ep_enable() function by supporting isochronous endpoint=
 type.
> >
> >you're doing way too many things in a single patch.
>=20
> All these changes concerns to isochronous transfers support, and I
> think they should not be splitted into number of patches. This entire
> patch adds one compact functionality and it has no sense to put small
> parts of this functionality to separated patches.

you have at least two bug fixes here which should be splitted into their
own patches.

I'm not taking this patch the way it is.

--=20
balbi

--iBwuxWUsK/REspAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSTtJSAAoJEIaOsuA1yqRESvoQALWp94zqHIekEvM2SOSa03F7
VjlqG8NFpGc6nqcNSzrHmUb6cgVHXtCPPn+2WDmvuqSWtREkN1Oi4aNUHhhB2XjY
LRE76e5Vqvn+vUNHImtNXHOiS/uSlRs5qHaYHXD0pGRcVhrrsSzlc9IG76P8O9xM
s0PQ/X+u7V3dp0WMftPydNlUQ4QhxWaaaEo7dbYEvOuTn2UD+iBWyMY/jNVcMKoJ
wmoePyzZgQeSrlNhBji1kc1lhAT32N8uB8pvwyGZWfXkS0U1ff/7IBwd8pBoudEn
hJMIqf4royIU2Or8rKzSn3+VFLxn4owX1sNNhAR3JC/MeVuk7e58hYQFYIHJzm7x
ZQLY2abmtnKt3YLdo7WNxq6eIWNi4FCbFdAXy2vTjISfyQYot1pnrLQgjtwszLYS
RSAcRbBSnpGG+ZiutPMQv+rOLBf5I+/IWpGg1e40V9CpqPTzxouVcSkJoCtT9bj4
Lw6d2fb7ju3iikt5LGJO/rQZk3lili7yW9XfRl9cnJEWeznf49041er0/ZyJutAL
Ne29Pvn/c+YRwW4AzMZwXlc2LWmHvemCtYlb3rarhP6da9OpajfeDg0+P5S17/hk
slYUmgyXE/5hEIeKrGIJWKrpqxguLiRFS6dgUXUIZmPz0ZC4KV2/0eRN1lp7Awib
3stGW5dnYtB7UYhX2GgP
=NtQ6
-----END PGP SIGNATURE-----

--iBwuxWUsK/REspAd--
