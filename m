Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3JWHMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:12:42 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:44376 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3JWHMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:12:41 -0400
Date: Wed, 23 Oct 2013 09:10:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Usage of for_each_child_of_node()
Message-ID: <20131023071006.GA7708@ulmo.nvidia.com>
References: <5259B6F8.3070701@roeck-us.net>
 <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2013 at 10:15:03PM -0500, Rob Herring wrote:
> On Sat, Oct 12, 2013 at 3:54 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Hi all,
> >
> > for_each_child_of_node() and similar functions increase the refcount
> > on each returned node and expect the caller to release the node by
> > calling of_node_put() when done.
> >
> > Looking through the kernel code, it appears this is hardly ever done,
> > if at all. Some code even calls of_node_get() on returned nodes again.
> >
> > I guess this doesn't matter in cases where devicetree is a static entit=
y.
> > However, this is not (or no longer) the case with devicetree overlays,
> > or more generically in cases where devicetree nodes are added and
> > removed dynamically.
> >
> > Fundamental question: Would patches to fix this problem be accepted ups=
tream
> > ?
>=20
> Certainly.
>=20
> > Or, of course, stepping a bit back: Am I missing something essential ?
>=20
> No. I think this is frequently wrong since it typically doesn't matter
> for static entries as you mention.

Actually, I think it actually happens to be correct most of the time.
The reason is that for_each_child_of_node() internally calls the
of_get_next_child() to iterate over all children. And that function
already calls of_node_put() on the "previous" node. So if all the code
does is to iterate over all nodes to query them, then all should be
fine.

The only case where you actually need to drop the reference on a node is
if you break out of the loop (so that of_get_next_child() will not be
called). But that's usually the case when you need to perform some
operation on the node, in which case it is the right thing to hold on to
a reference until you're done with the node.

Thierry

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSZ3ZOAAoJEN0jrNd/PrOhEGUP/1RaUAUcOIe3ixiw5iFlpaSJ
uaF31EJUwcrOa83F6hSDRMhkmjuywy+2EXKXnpvOZ6cvG+VuB72XYqi5T//+r7G6
Ygg4oTrqDXRRy0YT2TUcO0u4WqMATWoBGYssC84gu8oWsKmv11QYIi2rQuBtE6Df
fET8i32n6ckWGlowyaPynrARyMvmwXUh4dkJM+7hqw89P6LA345+RjOqJ4N1RLs1
cDFfaF9hKV5hM95FfTf2f8DPWqgciF2tVVNHWcVzzMM9JphAH8s+BLqjfFjpZxAY
PWDQa3MM75vYGd1Comk1m16jzFnh6sEOIGEAwKk2ICWhnwUjzQl1i+BKO0/ZcPdn
TR/qBowsdlRp/mCk0nfeEPBG8TTwLjpvXqRAJMesGFg+UkPMx4m4PpxplBZiRJSw
6cR4SLW4dqZUC795mfxzuCvKooVtA4i1Z/BENCobPdozSCerBVGTjopsMDpkqkQU
RLCgDPOMc65JCsSgEjT9obVODjpzerwpiqcHsUO2v43hUkzE3Lc19BQL4DZsxr5A
VS+l2eL8f22EH8N+Ih4w9b5XZjtFb4k8l7FrumatbK6rjUezMIRcivNTv1TLTKIt
GCnulJaBE+XsIUvoBW0fl9hZsKW06ymfiWYvwE8d4oOK5nS61XlMJkJqNM9tpuxx
f1zi2c8sXgfzS0ekDP2m
=0FWF
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
