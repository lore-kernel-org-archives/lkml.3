Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaETBSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:18:46 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:33961 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaETBSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:18:44 -0400
Message-ID: <1400548481.3540.247.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Mon, 19 May 2014 21:14:41 -0400
In-Reply-To: <87mwedfh7c.fsf@x220.int.ebiederm.org>
References: <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com> <20140516014959.GD22591@ubuntumail>
	 <20140516043532.GA14149@kroah.com> <20140516140607.GA23902@ubuntu-hedt>
	 <20140516185749.GA5131@kroah.com>
	 <1400268515.2221.91.camel@dabdike.int.hansenpartnership.com>
	 <20140516201841.GC23902@ubuntu-hedt> <87mwedfh7c.fsf@x220.int.ebiederm.org>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-u+xmrFhXS33seiGou38s"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4K1Efq0022923
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1401153306.26065@zsInz7s2hwIsHok1osYUMg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u+xmrFhXS33seiGou38s
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-05-19 at 17:04 -0700, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
>=20
> > What I set out for was feature parity between loop devices in a secure
> > container and loop devices on the host. Since some operations currently
> > check for system-wide CAP_SYS_ADMIN, the only way I see to accomplish
> > this is to push knowledge of the user namespace farther down into the
> > driver stack so the check can instead be for CAP_SYS_ADMIN in the user
> > namespace associated with the device.
> >
> > That said, I suspect our current use cases can get by without these
> > capabilities. Really though I suspect this is just deferring the
> > discussion rather than settling it, and what we'll end up with is littl=
e
> > more than a fancy way for userspace to ask the kernel to run mknod on
> > its behalf.

> A fancy way to ask the kernel to run mknod on its behalf is what
> /dev/pts is.

> When I suggested this I did not mean you should forgo making changes to
> allow partitions and the like.  What I itended is that you should find a
> way to make this safe for users who don't have root capabilities.

I like to think in terms of the "rootless" configurations where "root"
per se is not absolute and everything is framed in terms of
capabilities.

> Which possibly means that mount needs to learn how to keep a more
> privileged user from using your new loop devices.

Not sure I got that one.  As user with "more" privileges may or may not
have access dependent on the congruence of the privileges.  They're not
heiarchial.  If someone has that "priv" then they have access.  If they
do not, they do not.

> To get to the point where this is really and truly usable I expect to be
> technically daunting.

Most technically non-trivial problems generally are.

> Ultimately the technical challenge is how do we create a block device
> that is safe for a user who does not have any capabilities to use, and
> what can we do with that block device to make it useful.

Concur.  It boils down to privilege management and access.  Absolutely
concur.

> Only when the question is can this kernel functionality which is
> otherwise safe confuse a preexisting setuid application do namespace
> or container bits significantly come into play.

Ah...  Admittedly it's not as late as our conversation at LinuxPlumbers
last year in NOLA but...  Maybe late at night but I failed to parse the
above.

> Eric

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-u+xmrFhXS33seiGou38s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3qsgcDrlnVnRif/AQhDHAf8CKAniUWvkf904NiKAWQl+zFmWRKl3Tjd
80+xNOjxMVCenX30TE04v47ftlTH8b00q3JG9Oen4Nikmd181xFfiYGSnLQCElNU
+v6NwuJIY0GtahS9rwbO3p0Vu+APXTmQ3+hK8NWLgt9GF7RYlwwmVtx3SmI8yL5y
5uqt+guniLCRifTcFmuZ0vpO96T+tgMgF0ZiAzas+MU+ou8rOqAXJvuD41f7JWIk
vfVJgeEQV1GLOIjwOzBYAkgSynSPk0dr/IaFHL0YgQvNLxH185jAe+v1yAP7alob
v+6Lgu9ABvaPlgfFT/K7WqEhmBFjwtp/KLvdqkRih7D4Jp3+VZ49gA==
=WNSJ
-----END PGP SIGNATURE-----

--=-u+xmrFhXS33seiGou38s--

