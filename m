Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbaLWXs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:48:58 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45712 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbaLWXs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:48:56 -0500
Date: Tue, 23 Dec 2014 17:48:37 -0600
From: Felipe Balbi <balbi@ti.com>
To: Carsten Behling <carsten.behling@ridgerun.com>
CC: <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: usb: musb: Scheduling of interrupt endpoints
Message-ID: <20141223234837.GB32702@saruman>
Reply-To: <balbi@ti.com>
References: <54947E99.4010908@ridgerun.com>
 <5499835B.508@ridgerun.com>
 <20141223182737.GF9147@saruman>
 <5499CDB9.6050602@ridgerun.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <5499CDB9.6050602@ridgerun.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 23, 2014 at 02:16:57PM -0600, Carsten Behling wrote:
> >On Tue, Dec 23, 2014 at 08:59:39AM -0600, Carsten Behling wrote:
> >>Would it help if I send a patch as a suggestion and as basis for
> >>discussion?
> >yes, it would also help if you didn't top-post :-)
> >
> So would you suggestion be to port that feature from the old
> linux-2.6.32.17-psp03.01.01.39
> kernel from TI or should we rather add a tree based implementation as done
> for OHCI?

quite frankly, I don't know and, because of my email domain, I can't
really say out loud what I really think about those old TI releases :-)

IMHO, the best thing would be to completely ignore old kernels and
have a critical look at that part of the code on MUSB Host. Right now,
MUSB has a really brain dead endpoint allocation algorithm and it only
works for bulk (dynamic allocation, that is). Interrupt and isochronous
are left out of dynamic allocation which, IMHO, makes no sense
what so ever.

I guess the users of MUSB would benefit a whole lot more if someone were
to redesign that logic altogether so that all endpoints can be
dynamically allocated.

One easy way to test things out is to attach a ton of hubs and several
USB Serial adapters to a single MUSB port. All hubs and all USB serial
adapters - of course, as long as you follow USB spec's limitation on
maximum tier level and maximum number of devices.

cheers

--=20
balbi

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUmf9VAAoJEIaOsuA1yqRE6mgP/j6CdQde/y1iDbNBEzdCRiyS
BQDG8Yl++Ng8GNf6q47lurg0hvGWcFVf6J7TYVNNKnKAzBt8Vlu3go4/yW80Tox3
ypRU+hOWPWlYbILghIkfyOmvqDvYh3wl3bqeoLa/t9J8Iv1FtCe9heB4VZr1yNo0
+5/AZiqLV6Du9q/Ek8CpaVPjEcxUkF6gsIZzCtLrhXbMNPUfiqWECayZWzM6dxSj
686CwcOG4YCDeB9FgcB+1wVqzaq///0Sz4D9UmYV8zzEc03tYIBSQywSS/D1lERw
gFgJs5szjDdWlJzTqQ3YSqJDrbkH0+60lNOGE+SgyZKpfJ1eMW8T8Q7xd1loA3/K
//X3nuA8ThcsUhV2nhfNqic9f1vWfMiPsJvqvhQ2nh+yFQHSR785z1YyftfkiM6c
kKaEiVmO7w9nd0POurBXqpE14Fd/ujH9rrqPUyWa4Pv8nvvii7Dn6yKmeI46BxhQ
x7VEMXXW0nZq+A91BPxICXjgCDD4/vMYngWRgRwQNUgzCqMZX9epJ2RVETPtjNYB
vSEeT337cCU/lobV4k6Ex/w4+LFw9g5a/qjfYsPSlju+60WS9qz4TeY00xY91CIe
yzRzCXsL688KTWvA08xPcB57sqsIkSLejzly52bI7F5SqFJT8BGsEaqUnBCYhYuN
z9HZJGCkqgWWfRfjQpaX
=AmTV
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
