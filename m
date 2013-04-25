Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932831Ab3DYTgG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:36:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932250Ab3DYTgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:36:05 -0400
Date: Thu, 25 Apr 2013 14:35:53 -0500
From: Clark Williams <williams@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Suspend on 3.8.x-rtY (was: Re: [ANNOUNCE] 3.8.4-rt2)
Message-ID: <20130425143553.1d11603b@riff.lan>
In-Reply-To: <20130425131459.59fc5249@riff.lan>
References: <20130326201722.GA14220@linutronix.de>
	<CAP=VYLoXfECaSBuvYdZ3qbsnR9QMYpoRnKGZdY=P6zS_TYOcCA@mail.gmail.com>
	<20130408183012.GA5778@linutronix.de>
	<20130408152558.627dc8b1@riff.lan>
	<51794718.5040703@linutronix.de>
	<20130425131459.59fc5249@riff.lan>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/unwhBzJLR9veVgy6V0pL+5F"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/unwhBzJLR9veVgy6V0pL+5F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Apr 2013 13:14:59 -0500
Clark Williams <williams@redhat.com> wrote:
> I notice that nouveau is in there and yes, my laptop uses nouveau as
> well. First thing I'll try is some of the pm-suspend quirks regarding gra=
phics devices.
>=20
> If that doesn't change anything I'll try swapping  out the graphics card =
in that test box and see
> if that makes a difference.=20
>=20
> Clark

As a reminder to anyone reading, this is RT specific. Suspend to Ram
works fine on vanilla 3.8.x.

I tried 'pm-suspend --quirk-save-pci' and that locked up on resume (13
minutes and no activity). I then remembered something Thomas said (see
Thomas, my head is not *completely* full of hot air) and ran this:

[root@rhelrt-7 ~]# for i in core processors platform devices freezer
> do
> echo $i
> echo $i > /sys/power/pm_test
> pm-suspend
> done
core
processors
platform
devices
freezer
[root@rhelrt-7 ~]#=20


So all the pm_test modes passed.=20

I replaced the nVidia adapter with an ATI Rage card I had laying around
and that did not change the behaviour noted previously (i.e. pause of
nearly 10 minutes on resume). So, something is wedged in the resume
code and times out after nearly 10 minutes and lets the resume
continue.  I think I'm going to have to take a long stroll through the
resume path code and look for likely candidates.=20

Debugging suggestions welcome.

Clark

--Sig_/unwhBzJLR9veVgy6V0pL+5F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlF5hZ4ACgkQHyuj/+TTEp3oWwCdEkNjAb03+lJPb/yYFvgkbiUC
ynAAoKHUUEMZ9ZRUdUVmSUy0xtdyq0C2
=U1O5
-----END PGP SIGNATURE-----

--Sig_/unwhBzJLR9veVgy6V0pL+5F--
