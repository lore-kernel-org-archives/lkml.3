Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab3AQWyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 17:54:09 -0500
Received: from frost.carfax.org.uk ([85.119.82.111]:39255 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab3AQWyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 17:54:06 -0500
X-Greylist: delayed 2142 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2013 17:54:06 EST
Date: Thu, 17 Jan 2013 22:18:19 +0000
From: Hugo Mills <hugo-lkml@carfax.org.uk>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: btrfs userspace question - where's the utility to dump/restore?
Message-ID: <20130117221819.GA5406@carfax.org.uk>
Mail-Followup-To: Hugo Mills <hugo-lkml@carfax.org.uk>,
	Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	linux-kernel@vger.kernel.org
References: <6196.1358453135@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <6196.1358453135@turing-police.cc.vt.edu>
X-GPG-Fingerprint: 8C59 86C7 81F3 93FE BB02  DDB1 20AC B3BE 515C 238D
X-GPG-Key: 515C238D
X-Parrot: It is no more. It has joined the choir invisible.
X-IRC-Nicks: darksatanic darkersatanic darkling darkthing
User-Agent: Mutt/1.5.21 (2010-09-15)
X-frost.carfax.org.uk-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 17, 2013 at 03:05:35PM -0500, Valdis Kletnieks wrote:
> So I'm looking at playing with btrfs, and I start looking at the
> userspace pieces I'll need.  What I can't find is an equivalent
> of the ext[34] "dump/restore" package to dump data to an external
> backup device. Is 'tar cf --acls --selinux --xattrs /external/fs.dump'
> as good as it gets, or is something else recommended?

   tar doesn't handle reflinks(+), so the above won't quite give you a
complete duplicate. In the btrfs tool, there's send/receive, which
should(*) be sufficient to deal with reflinks.

   Hugo.

(+) aka CoW copies, or snapshots
(*) I regret to say that I've not had the opportunity to play with
send/receive myself yet, so I can't advise on the details of making it
work yet.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
               --- Prisoner unknown:  Return to Zenda. ---               

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUPh4q79z9OVl50rAAQK3ohAAjEVEmrowrTAIcUkPuTQtd8GJsg3HPWjC
DlPTK3kKU5wP9LCQmlRCsgqGYBosOlj17jeNsY+utjOaHOAmD4Q8zx9d/luRxt1S
L4roAi9SIjrr65ASle22fmvebyQoiUY/A5Iw6cwVqDdA5LS2vhbi+uFh8xgZbqEW
Rdsmi8yM6lO7wDWGNivQxeV1wurwKZL9aG1UR+UNeS+6ULFo2ZwFmN052jrJqjIr
vVtdCUS6o8aRjsrbe5nqeaQR/BhUB0tUnfNZdO+d+ZNRfSrRyYFq2x6oJrj37Dwq
ep1LA5uWhvRttjjfj+HzcKul/pidG1jE03DqD5HPxsDkIjY9mBERhZvCqfBFk71a
iCZ8WMXUd5ttPrehSNL+7+N1fX/4xt4JLazguLAl5JhWgfTk++M+3izH1oqNoXmh
vEBz/Ij8EpW6MaWFpWIlu1F9qnnWg1vBkMteX2Ff2uevQG4MkRfdPZD6jmnR2e+L
Z1Q1eugRMCpRrv64o2awGpkrfr9s4utj1mnI5fhkysYkB/sdOtKbYQkaQf5fStQy
atO0vFRdp89oZkdmUJBYvAClD8VHX33wU6HkqGZNa0opeGStI9Ef/dVlZlnswld1
w3ua3L8a5CxgR1FdWBrgElbIwPTlMBkVCLVF9HFReBgQyiHsp+76Pw1EQ8O2hBj9
TsRDb7JvT0E=
=H8Ur
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
