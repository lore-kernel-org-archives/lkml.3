Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab3I0TBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:01:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab3I0TBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:01:34 -0400
Message-ID: <5245D609.1060809@suse.com>
Date: Fri, 27 Sep 2013 15:01:29 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blktrace: fix race with open trace files and directory
 removal
References: <52425444.204@suse.com> <x49k3i2ds1a.fsf@segfault.boston.devel.redhat.com> <5245D414.1020002@suse.com> <x49eh8adrg3.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49eh8adrg3.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="1oWu9EBEgVSXCU6RwOdK9tWnnVM2N26Oh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1oWu9EBEgVSXCU6RwOdK9tWnnVM2N26Oh
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/27/13 2:56 PM, Jeff Moyer wrote:
> Jeff Mahoney <jeffm@suse.com> writes:
>=20
>> On 9/27/13 2:43 PM, Jeff Moyer wrote:
>>> Jeff Mahoney <jeffm@suse.com> writes:
>>>
>>>> There's a bug in the blktrace client where it will stop and tear dow=
n
>>>> all of the tracing instances for devices it's opened whether it
>>>> successfully completed the setup or not.
>>>>
>>>> By starting multiple blktrace processes on the same device, it's pos=
sible
>>>> to permanently disable blktrace on that device. The cause is that wh=
en
>>>> the first blktrace process to exit tears down the directory structur=
e,
>>>> the trace files are still held open. Debugfs removes the dentries fo=
r the
>>>> open files just fine but the relay implementation doesn't remove the=

>>>> dentries until all of the references to the file are dropped. This m=
eans
>>>> that if there are open files when debugfs_remove is called for the d=
evice
>>>> directory, the directory is not empty and can't be removed. Since th=
e
>>>> shutdown of the blktrace structure xchg's the structure out, there's=
 no
>>>> way to clean up the directory and any new blktrace processes will fa=
il
>>>> to start because it can't create the directory.
>>>>
>>>> This patch adds a kref to blk_trace so that we can release it after =
the
>>>> initial reference as well as all of the references accumulated by th=
e
>>>> relay files are dropped.
>>>
>>> Can't we just do proper unwinding of errors in the do_blktrace_setup
>>> function?  In other words, don't just blindly call blk_trace_free, bu=
t
>>> instead just undo anything we've done.
>>
>> No. It's not the setup that's causing the problem. It's one process
>> holding the trace files open while another process calls BLKTRACETEARD=
OWN.
>=20
> Ah, right.  So, in that case I'd rather restrict the ioctl to just the
> process that setup the trace.  Jens, Tejun, any opinions?

We'd also need to check to see if the task that started the trace is
still around.

-Jeff

--=20
Jeff Mahoney
SUSE Labs


--1oWu9EBEgVSXCU6RwOdK9tWnnVM2N26Oh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSRdYKAAoJEB57S2MheeWy3tAP/1Ag1q3tJSVrwyS7CH/B6fho
EcI6To4ZhluW+KA/1e2b2meYMHEFR7HBgrW9EfRQ/cFmLoFCYFuPRrKNlv/NWyTM
Z4Y1MPmIfT0nIkX72eZ8mJNTbhy94DpxWCmlyfnm7R2LC9K12SNs2krzV1kCc8yC
OdcadrfQB5rNrKnnswpv69kvROyS44kcphf59nH6DVv0B2RT2Dj40nEL0Tu9uZhf
OrxGiFcDIfp4lTeTZ70gFZzLEm+Fze07VlZ/jmyxANUHiLiZEQ2Z9PndPjsciJAv
RcY2Lc8rsv0eNjPtUxEdxM/ytalaW1fz9nb0pHApxVlMfH1KSfkKz6/969nJ8yZT
5pBuH1MwqKQy+ZB3puTuPMTYzgSfHnO/TrQLDmySag/bekc1Kl0CL7wu53EPFzoc
hrVg3vfjO6b7fKnn4uDclWX7eYd92CwE+JaVEwY1r5FM+IfhBrbYPWza3IegNhn7
sL7Kny0bljFP21dxU2QKMxIcriwaDLV5uLzH6pBCBjrdAMDAVnfgQ6vF5KIqUGo+
3XBDZ9mJOUJusgIXw/bwPxCYSKVuqK71DN2CDvcmlTVbt36Zz6umKss8cOoKbcoS
ItlSHygP9VQnXLsHR7OWw432jOJMhtehYRYv5qbgot8kTh0CBJ2la9Lup1m53fh5
yh1kBiy0nzy6PacG4TUv
=+Z7c
-----END PGP SIGNATURE-----

--1oWu9EBEgVSXCU6RwOdK9tWnnVM2N26Oh--
