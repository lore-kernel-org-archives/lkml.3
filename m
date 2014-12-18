Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaLRTV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:21:26 -0500
Received: from omr2.cc.vt.edu ([198.82.141.100]:35376 "EHLO omr2.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaLRTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:21:25 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Eric Paris <eparis@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>, linux-kernel@vger.kernel.org,
        selinux@tycho.nsa.gov, linux-audit@redhat.com, rgb@redhat.com
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid context at mm/slab.c:2849
In-Reply-To: Your message of "Thu, 18 Dec 2014 11:50:20 -0500."
             <1418921420.5162.19.camel@localhost>
From: Valdis.Kletnieks@vt.edu
References: <2966.1418778594@turing-police.cc.vt.edu> <5444.1418921116@turing-police.cc.vt.edu>
            <1418921420.5162.19.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1418930473_1952P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Dec 2014 14:21:13 -0500
Message-ID: <8832.1418930473@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1418930473_1952P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Dec 2014 11:50:20 -0500, Eric Paris said:
> On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> >
> > > Spotted these two while booting single-user on 20141216.  20141208
> > > doesn't throw these, so it's something in the last week or so..
> >
> > Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> > just fine for several days, but it went around the bend, apparently due
> > to a userspace or initrd change.
>
> $5 says you updated systemd?

Actually, yeah.  yum.log says:

Dec 12 14:08:09 Updated: systemd-218-1.fc22.x86_64

and things started going downhill that evening.  Damned if I know what 218
was doing to cause the issues.  (Other RPM update that looked vaguely
related was for selinux-policy, but again, damned if I know what a policy
file could contain that would change the behavior...)

Is it worth backing it to -217, or do we have a handle on the issue and
systemd is just the messenger?

--==_Exmh_1418930473_1952P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVJMpKQdmEQWDXROgAQJAsQ/+LRyvRpfXxgslVY/iQMIe9Oe1PIcV7vkj
4xEvbLwJ8OTyMcb65u/T0eqbknBBeBpufVsD2U2W2NfobL1J7c9k3UjYEI5L0wd/
6I6KtBmx+OITTkLl0InZmzvAiVUR2/E9QrVxt+LKPySENaHh/+t+vuQ4HanPH8RO
ljQbyCVCs1hDf0IOZQ3Uo8IoTClHYnMB6B/DIDB7lHfH+Fm/bieWC4yNr5ium+Gz
/j+9LYC6TCdPmqt5XJDumKaEAmHmi387SXk+/Bt/1RN5kxqaZWYrZq9YO0yBswBT
n4UaXMMPyYjATa2NJORl/R+XQMdebRXOeaiquGOrNBjjcJhOXCE+bdhU8NWNIuXE
3zATAQsAe7KPdCy/jzBNh/TdVi1lQU3C5ShF4hMVpq2XpREL+yR6YHgrUTs1d7vV
uhuh9c8zarAcCQQUxmfb5AuZ/fxbBAyVBLQsTYHK15JzSRxmHI2hw8+hEZbFKZtV
P0OcnI3HPe0sWatGYhP0wVxLjH3aT0I5lua71oJyySbf77J+JKWsGCBGkF8UHvsO
Q5kG9hhBkzSIu28Gpt9mpCZnewPDyV+RsM2F/CfSFTRrNzVsyvTiiWVAbUbJihFt
FSAsdHThIVFLG+kGfQ0Qv3wuxOSU6eFtsujR9d2oTuci3lKh1Ac3AgKiMQyGBPCK
O+BdHSwKwLo=
=UwHS
-----END PGP SIGNATURE-----

--==_Exmh_1418930473_1952P--
