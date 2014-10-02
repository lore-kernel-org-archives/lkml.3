Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaJBVKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 17:10:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35291 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaJBVJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 17:09:46 -0400
Message-ID: <542DBF13.6000305@gmail.com>
Date: Thu, 02 Oct 2014 17:09:39 -0400
From: Daniel Micay <danielmicay@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Evans <jasone@canonware.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v3] mm: add mremap flag for preserving the old mapping
References: <1412052900-1722-1-git-send-email-danielmicay@gmail.com> <CALCETrX6D7X7zm3qCn8kaBtYHCQvdR06LAAwzBA=1GteHAaLKA@mail.gmail.com> <542A79AF.8060602@gmail.com> <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
In-Reply-To: <CALCETrVHgvhAN3neoOpJEk94uM7QKm2izZpp+=1UA6qieaQiTQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="PRlCVIkmvMIs5cCoIexuIIqIjW92QRa2D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PRlCVIkmvMIs5cCoIexuIIqIjW92QRa2D
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 30/09/14 01:49 PM, Andy Lutomirski wrote:
>=20
> I think it might pay to add an explicit vm_op to authorize
> duplication, especially for non-cow mappings.  IOW this kind of
> extension seems quite magical for anything that doesn't have the
> normal COW semantics, including for plain old read-only mappings.

Adding a vm_ops table to MAP_PRIVATE|MAP_ANONYMOUS mappings has a
significant performance impact. I haven't yet narrowed it down, but
there's at least one code path a check of `!vma->vm_ops` for the fast
path. One is for transparent huge page faults, so the performance impact
makes sense. I'll use a simpler implementation for now since the
requirements are very narrow / simple.


--PRlCVIkmvMIs5cCoIexuIIqIjW92QRa2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULb8WAAoJEPnnEuWa9fIqSNAP/A7LCl/XGzXIE2tl5P6OOodp
oTI8okG15yxG4jXYOH7dT5//3qdvkeU5mU86/IOde+qmts2i5W+wNnM1rYHyOZka
hil/u1vF3flo+SiI47r9alh2JOyS7Yl51VFNQZ2ExIX9eUdAAahhdASCAQDia/D8
bITv3Z5XSGPRCxglo6vUYjRgv1l9Hrx+riwcwe9ceyNFx6Q7dD9/FzDs0nAu4Oy7
45caIcaVlBUpKiyhjwWFYF3wFO1J3LTC6zJyaA1TkbCTC5mbokGMDO6ghvGrzLE7
/jZIxJdsoNp3ifjgXlRg+9nO3UAP3LwsueHJlWuC2Xn5iNq9XNWyvxSvtWND/30d
TMwLS4ox1UFfd3TQhla100j2h0kAJECL+l2Rm61uNWlwN3+SdnzhLNHN9nKC2gAA
uuhFaM+jNWwSjN3d8NMM2L01eZZi1Fy18jcb/iGEDAZ3O83rYBIGy2WZJTJVQOnc
xjxyQl7NuBLugIUAkSC5OqJGEQ84ur56wX1HmlRbV7sdd8bbpNuXQS3qZuoY+p8H
fQSCW3w4hJ8mQBS4l5MZ/Oc44XuNNdQbEzL60Af0uxQbC46C83tJyqOUHKLysKnH
7lnEsm7tIXtisw5mg9blovJUSOZ5ZL5MshD0kdSLjkPUhjXm5bBJFsC3b2MsmI/A
MUa1auMJAdsi3LBa3uw6
=mK1z
-----END PGP SIGNATURE-----

--PRlCVIkmvMIs5cCoIexuIIqIjW92QRa2D--
