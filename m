Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaJAH3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:29:24 -0400
Received: from sauhun.de ([89.238.76.85]:46757 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJAH3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:29:21 -0400
Date: Wed, 1 Oct 2014 09:29:50 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over
 I2C
Message-ID: <20141001072949.GA1322@katana>
References: <542A3593.4020108@gmail.com>
 <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
 <20140930211339.GA1264@katana>
 <CAA93t1out+gJO29_0tn1zLJv_MUwJ458XKNT3Lo6WW+mH9XeRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <CAA93t1out+gJO29_0tn1zLJv_MUwJ458XKNT3Lo6WW+mH9XeRQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ...<snip>...
>=20
> +0. Why have an I2C interface to a PCIe switch?
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +Other than the regular PCI express interface, most modern PCIe switches =
(e.g.
> +from IDT and PLX) have an I2C based secondary interface. This interface =
allows
> +access to all the registers of the switch. Some of these registers may n=
ot even
> +be accessible over the regular PCI interface. Also, there are certain re=
gisters
> +that can be written to, using only the I2C interface and may only be rea=
d-only
> +using the PCI interface.
> +
> +This I2C interface is often used in designs involving these switches, an=
d can
> +be used for a variety of use cases where the switch needs to be configur=
ed
> +independent of the PCI subsystem (and likely before PCI enumeration). So=
me
> +examples:
> +
> +* Dividing a PCIe switch into multiple "virtual" switches. Using this fe=
ature,
> +  a switch could be connected to 2 root ports for instance, each managin=
g its
> +  own PCI hierarchy, and the traffic from one virtual switch does not le=
ak into
> +  another.
> +
> +* Managing Transparent / Non-transparent bridging, and changing them
> on-the-fly.
> +  There are ports that can be converted into "Non-transparent" bridge po=
rts.
> +  Essentially this is used to create different domains (not visible to
> +  software). In a dynamic distributed system, it may be desirable to cha=
nge a
> +  transparent bridge to non-transparent or vice versa, for example, to h=
andle a
> +  failover situation.
> +
> +* Buggy hardware / Bad EEPROM configuration. There may be cases where an=
 errata
> +  involving register writes need to be applied before enumerating over P=
CI.
> +  Also these switches are typically attached to an EEPROM that is suppos=
ed to
> +  initialize the switch. If that EEPROM is not present, or contains bad
> +  initialization data, this I2C interface can be used to fix that.
> +
> +* Changing switch configuration on the fly. In a multi-homed or complex
> +  distributed systemsystem, there may be a need to change the switch
> +  configuration (eg. change the upstream port, or the port or lane
> +  configuration etc) to address run time scenarios (CPU plug out etc).
> +
>=20
> ...<snip>...
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> I am myself leaning towards drivers/pci/switch/. And am wanting to
> hear what other think.

I had a closer look and my first question is now if we really need a
kernel driver for this?

The sysfs interface is basically to PEEK/POKE registers of the switch.
How registers get accessed is part of userspace. Well, then it might
even be easier to construct the proper i2c messages in userspace, too,
and send them via i2c-dev (instead of writing to various files in
sysfs).

The Kernel API is also PEEK/POKE register. I am not an PCI expert, but I
can't see a user in this form. What I'd expect would be more like

pci_switch_set_mode(some_device, PCI_BRIDGE_MODE_TRANSPARENT);

and then a shim layer would make sure the proper driver for the switch
sends the proper commands. Again, I don't know if the decision of
setting a mode/creating virtual switches... is even desirable in kernel
space. If so, then this is probably a sub-subsystem
drivers/pci/switches, but needs way more abstraction. Otherwise,
userspace will currently do IMO.

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUK61tAAoJEBQN5MwUoCm2Bl0QAIS02sG+hqwNieDAPGGCEahc
YeBTdv4lgeICqm+ejlYq3pSck66BM7i60pOGq1OXtT5VFPlpR28yw45VvBSecduM
DagLz4OvmWdzUtNCL4jJc5piuOMPdLjQ5c9VO9UQ40bRc/RJy3EJcIBHa/fKLC8d
mvueNlxU3WNtKojEdD0avCfHHz+9ZAo0fQMfXW658h/GH+w6gDi6GpcEmpKUrTQf
GrlWkqDuFmlVvxb7p7ltPuyVC4R853iLzMNFa92IaRnouWcWOde63RPdYRrbQcsv
qNkpTWGudHmMpft6MmmxNCetvnKOyDkwx2JR98UnQX67Rt95yN+kDJyNV9v2X2H3
ln5aU8a/ERxiI2FOmWCikKN4K8RA34owDpvxPS8G5fHPJikwVUZVzasmDxDRukyM
POSRvC38jGgheMkJ+4IHcz+ApZkLaIHSjhvA2gga5SfT4m9D5QoLVxe2hw6KFbwX
XUeiSYBqestWpIJRqxYLYTsRggBft5xIbOb5tFQ5zp/9U3aUoGMRruJNNFRf9jez
hGWJ/4Gp+RaXDqb2LsbICLHZoUpOhxOywtyEPee5NRlL12k2BQTXyrddkISdoJRY
H+zhv5+Jb2DuIkOCUOAc2lXoGi1sItRKBUCG2KzpPUyizuO9JbYkvrRMiOsbry8Q
fDF5WSqu+m920YQLwbUN
=KEHo
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
