Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3JXOVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:21:48 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:54101 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab3JXOVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:21:47 -0400
Date: Thu, 24 Oct 2013 16:21:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Rob Herring <robherring2@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Usage of for_each_child_of_node()
Message-ID: <20131024142143.GC25061@ulmo.nvidia.com>
References: <5259B6F8.3070701@roeck-us.net>
 <CAL_Jsq+wBGV6KGo4Ngrxr4_aZ=0eWPTbt0n4bhhrpERB55bQyg@mail.gmail.com>
 <20131023071006.GA7708@ulmo.nvidia.com>
 <20131023161644.GB20675@roeck-us.net>
 <20131024075058.GD9403@ulmo.nvidia.com>
 <52692129.3070207@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <52692129.3070207@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2013 at 06:31:21AM -0700, Guenter Roeck wrote:
> On 10/24/2013 12:50 AM, Thierry Reding wrote:
> >On Wed, Oct 23, 2013 at 09:16:44AM -0700, Guenter Roeck wrote:
> >>On Wed, Oct 23, 2013 at 09:10:07AM +0200, Thierry Reding wrote:
> >>>On Sat, Oct 12, 2013 at 10:15:03PM -0500, Rob Herring wrote:
> >>>>On Sat, Oct 12, 2013 at 3:54 PM, Guenter Roeck <linux@roeck-us.net> w=
rote:
> >>>>>Hi all,
> >>>>>
> >>>>>for_each_child_of_node() and similar functions increase the refcount
> >>>>>on each returned node and expect the caller to release the node by
> >>>>>calling of_node_put() when done.
> >>>>>
> >>>>>Looking through the kernel code, it appears this is hardly ever done,
> >>>>>if at all. Some code even calls of_node_get() on returned nodes agai=
n.
> >>>>>
> >>>>>I guess this doesn't matter in cases where devicetree is a static en=
tity.
> >>>>>However, this is not (or no longer) the case with devicetree overlay=
s,
> >>>>>or more generically in cases where devicetree nodes are added and
> >>>>>removed dynamically.
> >>>>>
> >>>>>Fundamental question: Would patches to fix this problem be accepted =
upstream
> >>>>>?
> >>>>
> >>>>Certainly.
> >>>>
> >>>>>Or, of course, stepping a bit back: Am I missing something essential=
 ?
> >>>>
> >>>>No. I think this is frequently wrong since it typically doesn't matter
> >>>>for static entries as you mention.
> >>>
> >>>Actually, I think it actually happens to be correct most of the time.
> >>>The reason is that for_each_child_of_node() internally calls the
> >>>of_get_next_child() to iterate over all children. And that function
> >>>already calls of_node_put() on the "previous" node. So if all the code
> >>>does is to iterate over all nodes to query them, then all should be
> >>>fine.
> >>>
> >>Good, that reduces the scope of the problem significantly.
> >>
> >>>The only case where you actually need to drop the reference on a node =
is
> >>>if you break out of the loop (so that of_get_next_child() will not be
> >>>called). But that's usually the case when you need to perform some
> >>>operation on the node, in which case it is the right thing to hold on =
to
> >>>a reference until you're done with the node.
> >>>
> >>Unfortunately, there are many cases with code such as
> >>
> >>	if (error)
> >>		return;	/* or break; */
> >
> >Well, a break isn't necessarily bad, since you could be using the node
> >subsequently. I imagine that depending on the exact block following the
>=20
> Correct, but I meant the error case. Randomly looking through several
> drivers, most of them get error return handling wrong. "Winner" so far
> is of_regulator_match(), which doesn't release the node on error return,
> but does not acquire references for use afterwards either.
>=20
> Something to do with my non-existing free time ;-).

Well, that's better than boring, isn't it? =3D)

Thierry

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaSz3AAoJEN0jrNd/PrOhEL4QAKYYfPq8yY3iNBzQVs60JsTz
Q3Q+WSzxqCoMszEmrQrnQkEM8OWdsYxH2mpoDklY7E13XkCE0xrpsHLBzzs27Um9
wo1FBKnn68V8j6ZwqV4ChQPcFQPQdwh5v8pI9hgssOIjoU+NOqJ98gUEk41+JGde
IWtq1rHXS7P9v3pc5pPyM5opdIx2i9yNJWzxlCf9seBpCL3Ogc8JyNxw7F+zsB+c
ZsXaTT2yhQtqAb4gskHD0w7KOHEYzNtMeGbvdpXjwfrvruYQEnafSzt8JGNs+LB2
36mkm4gvbgWaLADw3IX4EqLNJRuZDqE4HBKh5xLjpfH3xYIsA4T7SJBGwmEK1F+m
+ppx1+bjgdRMtEMpP3+4IfRodiNQOxuoi5G6Ig5O+C8CWxWcO/3E4l+SK6T88FIL
Y6o3WCIgwnbEpgsuFLMtJD9vHgKU/nyt9q2sXuAsF92CTGY9APmdedGIoYxE047G
8NgrV2hOYHTd34HhL7WJcDzrxEoet5JhFf+/uK0967JwSQ9cgA64/l8Xy5EjMdpb
ZfdRbRbbEZ3UJTaiq0xlzgiRev+tMFBB9BnIwnUV2nC2Drp7U1pOdsGtuKRsdQLE
E5vWO96iLl8ZZzdB6rh/4CqN9rG1NOUT3kBz5sYXPtNKE9LayY+u98r9MoxFof7s
pe8xSE93wl01pEYdF4ka
=/x3g
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
