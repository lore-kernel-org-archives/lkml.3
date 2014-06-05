Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990AbaFEAbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:31:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756956AbaFEAbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 20:31:07 -0400
Date: Thu, 5 Jun 2014 02:31:03 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Ian Campbell <Ian.Campbell@citrix.com>, luto@mit.edu,
        Keir Fraser <keir@xen.org>, Tim Deegan <tim@xen.org>,
        Ian Jackson <ian.jackson@eu.citrix.com>, linux-kernel@vger.kernel.org,
        systemd-devel@lists.freedesktop.org,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        Jan Beulich <jbeulich@suse.com>, xen-devel@lists.xenproject.org,
        morgan@kernel.org
Subject: Re: [systemd-devel] [PATCH v5 12/14] autoconf: xen: enable
	explicit  preference option for xenstored preference
Message-ID: <20140605003103.GB22052@wotan.suse.de>
References: <1400589095-3872-1-git-send-email-mcgrof@do-not-panic.com> <1400589095-3872-13-git-send-email-mcgrof@do-not-panic.com> <1400687040.7272.28.camel@kazak.uk.xensource.com> <20140521230233.GA13289@wotan.suse.de> <1400753147.14637.10.camel@kazak.uk.xensource.com> <20140523232031.GA26450@wotan.suse.de> <1401269449.24800.7.camel@kazak.uk.xensource.com> <20140529232918.GG26450@wotan.suse.de> <20140601061547.GC16257@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20140601061547.GC16257@tango.0pointer.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 01, 2014 at 08:15:47AM +0200, Lennart Poettering wrote:
> On Fri, 30.05.14 01:29, Luis R. Rodriguez (mcgrof@suse.com) wrote:
>=20
> > I'm cc'ing a few security folks as I'd appreciate review on the ideas h=
ere,
> > in particular that of a launcher idea on system to replace alternatives=
 on the
> > ExecStart=3D line of a systemd service unit file, alternative ideas are=
 of
> > course welcomed. I'm also Cc'ing systemd-devel as this subject was revi=
ewed
> > a little while ago with nothing concrete being recommended but instead =
a few
> > options being now archived as possibilities. I'm looking for a bit wider
> > review of the approaches and recomendations.
> >=20
> > Some general background for non xen folks: old xen requires the launch =
of
> > a daemon which implements supports of the xenstore, which is the databa=
se
> > that xen uses for information about guests / dom0. There are two suppor=
ted
> > daemons, xenstored (C version) and oxenstored (Ocaml version) but they =
do the
> > same thing. Right now old init lets you override which one you pick thr=
ough
> > an environment variable on /etc/{sysconfig,default}/xencommons, the scr=
ipt
> > will use the appropriate on there. Systemd doesn't let you use variable=
s on
> > the ExecStart line of a service unit file so alternatives are required.
> >=20
> > The reason I'm being very careful here this could set a precedent and at
> > least for the launcher idea it'd require the usage of getenv() and exec=
ve(),
> > and secure alternatives for these (secure_getenv(), execve_nosecurity())
> > have either been merged or suggested before for Linux. The systemd disc=
ussion
> > is only specific to Linux but if we have a launcher we could consider i=
t for
> > other supported OSes. All that said I'd like proper review of the secur=
ity
> > implications of *all* strategies but obviously in particular the launch=
er
> > idea. I want to tread carefuly before setting precedents.
>=20
> You can also just invoke a shell script from ExecStart=3D. I mean, we try
> to deemphesize them in the boot process, but there's nothing wrong with
> using shell, if you need to parse shell configuraiton fragments and just
> want to execute on ot another program...

I tried this and it didn't work given that systemd expects sd_notify()
to be called from the parent process, in this case the shell script.

Anyway -- time has passed folks and we need to pick something, I really
rather not spend any more time on this series unless a decision is made.
My preference stands as the launcher with getenv() and execve() but I
have also listed all other options available. Please feel free to pick
one but just let me know.

> That said, I'd certainly make a clean cut and drop support for
> /etc/sysconfig from any project I see, earlier rather than later, since
> it's just cruft, a bad idea and should really just go away.

We can use for example something like:

# The RPM way
EnvironmentFile=3D-/etc/sysconfig/xencommons
# The Debian way
EnvironmentFile=3D-/etc/default/xencommons
Environment=3DXENSTORED=3Doxenstored

And with time this lets us with time get rid of EnvironmentFile.

> But then
> again, I would also just not do the thing with supporting two
> implementations at the same time...=20

:)

  Luis

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAEBAgAGBQJTj7pHAAoJEPep4JnvMe6zSgQQAIbgt9yhlH6lFs4MPsy9hkpR
cBYG6HvN2ep6dor/EjLIh5R0Voqz64OdnU4oys6HmjZNkuKjLpAv1lhQyYx1Xvx4
KhNeYUKHy3ms5Za7oQa7GG3E2C3juR3qpa7H9XcC2BK5rUHLZ77Yme1aIBXlWj2n
GVl8754YOKtj79XmHxJobQtO22gxVC/UL6zLMX5v63JNSv2ZmSKbSjfbIooomjuP
r82fx+kyU/Ai7WrbgW0F9t+bNKq6tbY8vSzBucGKVqITD0BGgCujsNnsKxZqXSKI
5f8P8GggegslRcPbtqaQqXNdC7KaMJ1hYAluXd7cTYB4dQwFtvjwWaGalYbRNP+Q
ohrfYwHzw9PmNIoOMeg7NPnAit5/a54L4Zq+m2l9QT7B2pi2pJzmbskDImYMhzUA
rkXHEUtU0pAXLdT6LYVr+FeR16zMsSMDnp4ygIRO71ffvEbojXzFFEaN4d0g6f86
Mlxr16oJnWyZq9x5PO5kTfZGC3iAYCQ9CSc1aAYQ66LO5kHFN0xtJ8UWSLIrrW7s
dU9XWoxhNi5YIMoAh5FzRhpLzdxuHkUVqdsDh9dXhWqdCAURTxkjkyWhhGnoNdAs
A/eT+uwDI8njPavjwlb4IAnGOSckIKvVkCLyTOOETnsdIdecMiz7jPQhmhkJQx47
KrzqxMzwePoX/o5s84OI
=6Niz
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
