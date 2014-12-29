Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbaL2QH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:07:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33919 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaL2QHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:07:50 -0500
Date: Mon, 29 Dec 2014 10:06:41 -0600
From: Felipe Balbi <balbi@ti.com>
To: Sneeker Yeh <sneeker.yeh@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Paul Bolle <pebolle@tiscali.nl>, Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
Message-ID: <20141229160641.GD29379@saruman>
Reply-To: <balbi@ti.com>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
 <20141222153730.GA12815@saruman>
 <CAJ1gpc3jVpz=5ME4+wCJDW5NKihvB4xYzwi0co=UuPtG9Ubmjg@mail.gmail.com>
 <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 29, 2014 at 04:07:50PM +0800, Sneeker Yeh wrote:
> Hi,
>=20
> 2014-12-29 14:41 GMT+08:00 Sneeker Yeh <sneeker.yeh@gmail.com>:
>=20
> > Hi,
> >
> > 2014-12-22 23:37 GMT+08:00 Felipe Balbi <balbi@ti.com>:
> >
> >> On Tue, Dec 16, 2014 at 10:10:28AM +0800, Sneeker Yeh wrote:
> >> > Synopsis DesignWare USB3 IP Core integrated with a config-free
> >> > phy needs special handling during device disconnection to avoid
> >> > the host controller dying.
> >> >
> >> > This quirk makes sure PORT_CSC is cleared after the disable slot
> >> > command when usb device is disconnected from internal root hub,
> >> > otherwise, Synopsis core would fall into a state that cannot use
> >> > any endpoint command. Consequently, device disconnection procedure
> >> > might not be finished because sometimes endpoint need to be stop
> >> > by endpoint stop command issuing.
> >> >
> >> > Symptom usually happens when disconnected device is keyboard,
> >> > mouse, and hub.
> >>
> >> you need to point us to the synopsys STARS ticket number. That's the
> >> only way to reference this specific quirk. Add it to a comment
> >> somewhere.
> >>
> >
> > Thanks, we're still waiting for Synopsis STARS ticket number.
> > I'll add it to comment later.
> >
> >
> Sorry I didn't express myself clearly.
>=20
> So far Fujitsu Semiconductor got Synopsys internal case id , that is "
> Case: 8000679552".
> However the contents belongs this id cannot be referred except Fujitsu
> Semiconductor and Synopsys.
> Synopsis decide the official errata (STAR information) will be disclosed
> next February.
>=20
> Would you suggest if this quirk can be accepted with this case ID, or can
> only be accepted with STARS ticket number?

The thing is that without the STARS number I can't really verify which
versions of the IP would be affected. Clearly, it's not only your setup
and I think it's pretty unfair to have "is_compatible("fujitsu")" to
enable the quirk only for you. Isn't there a better way of enabling the
quirk based off of revision detection couple with a look on GHWPARAMS*
registers ?

What's tricking me is this claim that only config-free PHYs would be
affected, why ?

I still have many questions about this patch which are not answered by
commit log nor can I poke around on Synopsys solvnet for answers :-s

--=20
balbi

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUoXwRAAoJEIaOsuA1yqREBpsQALJPdrZ8vpH1bBY08O7kg9vH
6FGwvX+rSuy0ZjLJ9qJDSxJrMrrXVzt9zr5wv/T0HJxMDBCCR5a3isiLSXJU34RD
Cl1+9KPxa8rCkQsUa3UMfF9e0azMLnfhPWW8DNdWE8NHoQRVzCCvIBwAHBbI5yKj
xCfAErr62LbeWm6s3qG5mkcpsLQkrUZjuDU7pqlYd8B3m8CBNMRKGuA5GG7la7Uy
kVKPPjyf0GmHFQx8VPnVzp+84dhXBA2eBpVSX/WW0VxNI4ElJqcpv7UifuyrNaX3
RtwY/O78TIIu/Yo7+LpKFhBwwVWltq37NDmHVIYP3P5Z5YBR5TZbcjvBRbSC6EmY
HNRoO8eDqY57VKZ6wJ2MnZ1Ouqe/zEQLNGil1Ft+/oJ7DSesJbSt8rslgwoUiCdc
+utAHMrjxKvgPtgSf9IS8j1hlcpU/9ZpR7O/A1SPtv4DT50lUl4s1ZWDgmHDqnD5
CMKZ+cvYlt8FqmQUqi7ke+9XS9D7V0M0OeC55j504qEgsX/WneYokWXMClZNpuQy
yVHTPFvbUPLxxj9H08b5JitMRWlFr7RQJiWfDMyv5sEclpbnHWKkpIywo1JkWAMT
cOWho5mOTFx75FyH0GNdHOtkRMmlV9CrNyRL+0VZVu2+ePY5hVLZmcIPfxRRQuMl
nbwvxY/IfDK7TBnZ9Ex8
=4uzM
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
