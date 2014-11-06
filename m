Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaKFQNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:13:32 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57423 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKFQNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:13:30 -0500
Date: Thu, 6 Nov 2014 17:13:24 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] core: Add generic object registry implementation
Message-ID: <20141106161321.GB14873@ulmo.nvidia.com>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
 <20141104163845.GA369@kroah.com>
 <20141105091351.GA12033@ulmo>
 <20141106021815.GA17253@kroah.com>
 <20141106102531.GI26297@ulmo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20141106102531.GI26297@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 11:25:32AM +0100, Thierry Reding wrote:
> On Wed, Nov 05, 2014 at 06:18:15PM -0800, Greg Kroah-Hartman wrote:
[...]
> > Sure, document it better if you want, but I think something needs to be
> > done differently if at all possible.
>=20
> try_module_get() is the only way I know of that ensures that the code of
> a module stays around. Everytime we give out a new reference to a record
> we also need to increment the module reference count accordingly to make
> sure the underlying code doesn't go away all of a sudden.
>=20
> I guess that's not entirely accurate. The module reference count doesn't
> have to be increment for every record reference, it only needs to track
> each record. So the try_module_get() and module_put() could move into
> registry_add() and registry_get(), respectively. But the ->owner field
> would still be in the record structure.

On further thought I don't think this will work either. Given that the
record can be removed from the registry while somebody else still has a
reference to it, the module owning the record must stay around as long
as there's a reference to the record.

Maybe the module reference count needs to be incremented when the record
is initialized and decremented when the record is released.

Thierry

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUW54hAAoJEN0jrNd/PrOhOBMP/itWpUWFfunCxM47G+CqbOHL
QHU+cl11FinQDha4RdZqriHguYCoo78FQA+g89GkimdQmgRSbmCtV51IFVrv0X2i
aLVhZdVpCBocAyhqm5RtnoQwT/H1EEEytjEjoTKfMUY8Oj1b2QL/uyV2E57j4nKh
C+WDvqXRnT82DJG/PwkhWvmFJaW1n4qRfGVDXHa0MZixaHUY009kklI8ijgY2sox
opeXlojx2+xLMOQsUzxdRHroC5v2Uip2jnPZN26l5f92/bdsZoU/oAV8aUrDki3x
vBQK+yGvxgD4heSxd1MWixlzfbdaWdpuNs2rM9o1wvaRhMdILVTnwbCn1fBqM+zQ
XcGB4cYVkZ4trvLTxOMNgdxzUWhs89nqNmPEMAPgiahNNqdN/9DO9x7Wwe1zWPXZ
ti61SqjsAUIaQZd7H3Ecb9L8zqimBlB4ZaxIA1m5QqiQrgj1hDKUAjwns33ISzsK
4VU8chNXneZBD9tkCkq7J/dnm9NA+zkV9Q1/ob6garCClyu7+lBhpITMlFdaQAFP
TSz+LJRj9eDbSol0/HZ1PpH0Cej2FbD3DL0fltflViaLuanqX/0Y17+li0S0I8IZ
DFymEUQQHn0eiodVSC3wvClWTuGw6FbukPFXR6kMNXxYS1IHcRU1N1qyV875PUsw
a2Aa0DVelF9mSeqTAMfp
=sSSM
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
