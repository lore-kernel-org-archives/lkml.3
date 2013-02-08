Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947284Ab3BHWlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:41:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947091Ab3BHWlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:41:16 -0500
Date: Fri, 8 Feb 2013 16:40:25 -0600
From: Clark Williams <williams@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208164025.0d813922@riff.lan>
In-Reply-To: <87sj56pikc.fsf@xmission.com>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130208202314.GF31684@hansolo.jdub.homelinux.org>
	<87r4kqttz8.fsf@xmission.com>
	<20130208212726.GH31684@hansolo.jdub.homelinux.org>
	<87sj56pikc.fsf@xmission.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5UY90IOi+iP8xru2gVurGto"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5UY90IOi+iP8xru2gVurGto
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 08 Feb 2013 14:05:55 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Josh Boyer <jwboyer@redhat.com> writes:
>=20
> >> So it looks mock is taking a buggy untested code path and things are n=
ot
> >> working as it expected.
> >
> > Quite possibly, yes.  I instrumented the kernel a bit and it is indeed
> > failing in the alloc_pid call.
> >
> > Clark, thoughts here?
>=20
> I will just add the solution is probably for mock to fork immediate
> after the unshare succeeds in creating a pid namespace.  With the
> original process waiting for mock to exit and the child process
> doing everything that mock does now.
>=20
> That will allow mock to act as the init process in the pid namespace it
> just created.
>=20
> Eric
>=20

Well, mock is not really setup to act as an init (i.e. reap all the
child processes in the new namespace). Not really sure that's what I
want anyway, verses just nuking CLONE_NEWPID and running in the same
pidspace.=20

I added some debugging output in the code around the unshare() calls and
so far I can't seem to get unshare() to succeed when NEWPID is one of
the flags. I'll admit that I'm running a realtime kernel (3.6.11-rt28
with CONFIG_PID_NS=3Dy) so I'll boot into the latest F18 and make sure of
this, but I'm leaning towards just removing NEWPID, since we weren't
using it right and I'm not convinced that we need it.=20

Clark

--Sig_/5UY90IOi+iP8xru2gVurGto
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVftkACgkQHyuj/+TTEp3pUgCgqq6MYn6v4ANumDmpSgNXm5bc
bhsAoJPcIh2KTpPzgvohYNE3Ry5n4I7p
=Vr74
-----END PGP SIGNATURE-----

--Sig_/5UY90IOi+iP8xru2gVurGto--
