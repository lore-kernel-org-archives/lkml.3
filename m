Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab3AVECw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 23:02:52 -0500
Received: from ozlabs.org ([203.10.76.45]:36027 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab3AVECs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 23:02:48 -0500
Date: Tue, 22 Jan 2013 15:05:24 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>
Subject: Re: [PATCH 5/6] OF: Introduce Device Tree resolve support.
Message-ID: <20130122040524.GG23500@truffula.fritz.box>
References: <1357327870-13615-1-git-send-email-panto@antoniou-consulting.com>
 <1357327870-13615-6-git-send-email-panto@antoniou-consulting.com>
 <20130121044836.GB24829@truffula.fritz.box>
 <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vSsTm1kUtxIHoa7M"
Content-Disposition: inline
In-Reply-To: <EEEDB0B2-7410-456B-BED7-89FD5E407553@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vSsTm1kUtxIHoa7M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 12:59:15PM +0200, Pantelis Antoniou wrote:
> Hi David
>=20
> On Jan 21, 2013, at 6:48 AM, David Gibson wrote:
>=20
> > On Fri, Jan 04, 2013 at 09:31:09PM +0200, Pantelis Antoniou wrote:
> >> Introduce support for dynamic device tree resolution.
> >> Using it, it is possible to prepare a device tree that's
> >> been loaded on runtime to be modified and inserted at the kernel
> >> live tree.
> >>=20
> >> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >> ---
> >> .../devicetree/dynamic-resolution-notes.txt        |  25 ++
> >> drivers/of/Kconfig                                 |   9 +
> >> drivers/of/Makefile                                |   1 +
> >> drivers/of/resolver.c                              | 394 +++++++++++++=
++++++++
> >> include/linux/of.h                                 |  17 +
> >> 5 files changed, 446 insertions(+)
> >> create mode 100644 Documentation/devicetree/dynamic-resolution-notes.t=
xt
> >> create mode 100644 drivers/of/resolver.c
> >>=20
> >> diff --git a/Documentation/devicetree/dynamic-resolution-notes.txt b/D=
ocumentation/devicetree/dynamic-resolution-notes.txt
> >> new file mode 100644
> >> index 0000000..0b396c4
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/dynamic-resolution-notes.txt
> >> @@ -0,0 +1,25 @@
> >> +Device Tree Dynamic Resolver Notes
> >> +----------------------------------
> >> +
> >> +This document describes the implementation of the in-kernel
> >> +Device Tree resolver, residing in drivers/of/resolver.c and is a
> >> +companion document to Documentation/devicetree/dt-object-internal.txt=
[1]
> >> +
> >> +How the resolver works
> >> +----------------------
> >> +
> >> +The resolver is given as an input an arbitrary tree compiled with the
> >> +proper dtc option and having a /plugin/ tag. This generates the
> >> +appropriate __fixups__ & __local_fixups__ nodes as described in [1].
> >> +
> >> +In sequence the resolver works by the following steps:
> >> +
> >> +1. Get the maximum device tree phandle value from the live tree + 1.
> >> +2. Adjust all the local phandles of the tree to resolve by that amoun=
t.
> >> +3. Using the __local__fixups__ node information adjust all local refe=
rences
> >> +   by the same amount.
> >> +4. For each property in the __fixups__ node locate the node it refere=
nces
> >> +   in the live tree. This is the label used to tag the node.
> >> +5. Retrieve the phandle of the target of the fixup.
> >> +5. For each fixup in the property locate the node:property:offset loc=
ation
> >> +   and replace it with the phandle value.
> >=20
> > Hrm.  So, I'm really still not convinced by this approach.
> >=20
> > 	First, I think it's unwise to allow overlays to change
> > essentially anything in the base tree, rather than having the base
> > tree define sockets of some sort where things can be attached.
> >=20
>=20
> One could say that the labels define the sockets. It's not just things
> to be attached, properties might have to change, or something more comple=
x,
> as we've found out in practice.

Hrm.  I know a number of these have come up previously in that big
thread, but can you summarise some of these cases here.  If things
need modification in the base tree that still seems to me like the
base tree hasn't properly described the socket arrangement (I realise
that allowing such descriptions may require extensions to some of our
device tree conventions).

> As far as the unwise part, a good deal of care has been taken so that=20
> people that don't use the overlay functionality have absolutely no
> overhead, or anything modified in the way they use DT.

Yeah, that's not what I'm concerned about.  I'm concerned about hard
to debug problems because some subtle change in the base tree or the
overlay or both causes the overlay to alter something in the base tree
it really shouldn't.

> > 	Second, even allowing overlays to change anything, I don't see
> > a lot of reason to do this kind of resolution within the kernel and
> > with data stored in the dtb itself, rather than doing the resolution
> > in userspace from an annotated overlay dts or dtb, then inserting the
> > fully resolved product into the kernel.  In either case, the overlay
> > needs to be constructed with pretty intimate knowledge of the base
> > tree.
>=20
> Fair enough, but that's one more thing of user-space crud to drag along, =
which
> will get enabled pretty late in the boot sequence. Meaning a whole bunch =
of devices,
> like consoles, and root filesystems on the devices that need an overlay t=
o operate
> won't work easily enough.

Hrm.  But doesn't your scheme already require userspace to identify
the hardware and load the overlay?  So why is having it resolve the
overlay significantly harder?

AFAICT devices wanted early can be handled in several possible ways
without having the resolved in kernel: an initramfs is the most
obvious, but for things you want really early, it should be possible
to do the resolution from the platform's bootloader update tool - so
the pre-resolved overlay gets bundled with the kernel/initrd/whatever
to get fired up from the bootloader.

>=20
> > That said, I have some implementation comments below.
> >=20
> > [snip]
> >> +/**
> >> + * Find a subtree's maximum phandle value.
> >> + */
> >> +static phandle __of_get_tree_max_phandle(struct device_node *node,
> >> +		phandle max_phandle)
> >> +{
> >> +	struct device_node *child;
> >> +
> >> +	if (node->phandle !=3D 0 && node->phandle !=3D OF_PHANDLE_ILLEGAL &&
> >> +			node->phandle > max_phandle)
> >> +		max_phandle =3D node->phandle;
> >> +
> >> +	__for_each_child_of_node(node, child)
> >> +		max_phandle =3D __of_get_tree_max_phandle(child, max_phandle);
> >=20
> > Recursion is best avoided given the kernel's limited stack space.
> > This is also trivial to implement non-recursively, using the allnext
> > pointer.
>=20
> The caller passes a tree that's not yet been inserted in the live
> tree.

Um.. isn't this used to find the max phandle in the base tree, so how
is it not inserted in the live tree yet?

> So there's no allnodes pointer yet.=20

I would strongly suggest populating that in the subtree as you build
it, then.  Except that I don't think it is a detached subtree in this
case, though it is in some of the cases below.

> Care has been taken for the function
> to not have excessive local variables. I would guess about 20-32 bytes for
> the stack frame + the local variables, so with a 4K stack we would overfl=
ow at a=20
> nest level of 128, which has a pretty slim chance for a real system.

Hrm.  Recursion still makes me nervous.  I believe there are platforms
that have a non-trivial lower-bound on stack usage per frame, even
with few local variables.

> >> +
> >> +	return max_phandle;
> >> +}
> >> +
> >> +/**
> >> + * Find live tree's maximum phandle value.
> >> + */
> >> +static phandle of_get_tree_max_phandle(void)
> >> +{
> >> +	struct device_node *node;
> >> +	phandle phandle;
> >> +
> >> +	/* get root node */
> >> +	node =3D of_find_node_by_path("/");
> >> +	if (node =3D=3D NULL)
> >> +		return OF_PHANDLE_ILLEGAL;
> >> +
> >> +	/* now search recursively */
> >> +	read_lock(&devtree_lock);
> >> +	phandle =3D __of_get_tree_max_phandle(node, 0);
> >> +	read_unlock(&devtree_lock);
> >> +
> >> +	of_node_put(node);
> >> +
> >> +	return phandle;
> >> +}
> >> +
> >> +/**
> >> + * Adjust a subtree's phandle values by a given delta.
> >> + * Makes sure not to just adjust the device node's phandle value,
> >> + * but modify the phandle properties values as well.
> >> + */
> >> +static void __of_adjust_tree_phandles(struct device_node *node,
> >> +		int phandle_delta)
> >> +{
> >> +	struct device_node *child;
> >> +	struct property *prop;
> >> +	phandle phandle;
> >> +
> >> +	/* first adjust the node's phandle direct value */
> >> +	if (node->phandle !=3D 0 && node->phandle !=3D OF_PHANDLE_ILLEGAL)
> >> +		node->phandle +=3D phandle_delta;
> >=20
> > You need to have some kind of check for overflow here, or the adjusted
> > phandle could be one of the illegal values (0 or -1) - or wrap around
> > and colllide with existing phandle values in the base tree.  dtc
> > (currently) allocates phandles from the bottom, but there's no
> > guarantee that a base tree will only have low phandle values - it only
> > takes one node with phandle set to 0xfffffffe in the base tree to have
> > this function make a mess of things.
>=20
> Correct, I'll take care of handling the overflow.
>=20
> >=20
> >=20
> >> +	/* now adjust phandle & linux,phandle values */
> >> +	for_each_property_of_node(node, prop) {
> >> +
> >> +		/* only look for these two */
> >> +		if (of_prop_cmp(prop->name, "phandle") !=3D 0 &&
> >> +		    of_prop_cmp(prop->name, "linux,phandle") !=3D 0)
> >> +			continue;
> >> +
> >> +		/* must be big enough */
> >> +		if (prop->length < 4)
> >> +			continue;
> >=20
> > If prop->length !=3D 4 (including > 4) something is pretty wrong, and
> > you should probably bail with an error message.
>=20
> OK, just playing it safe here.
>=20
> >=20
> >> +
> >> +		/* read phandle value */
> >> +		phandle =3D be32_to_cpu(*(uint32_t *)prop->value);
> >> +		if (phandle =3D=3D OF_PHANDLE_ILLEGAL)	/* unresolved */
> >> +			continue;
> >> +
> >> +		/* adjust */
> >> +		*(uint32_t *)prop->value =3D cpu_to_be32(node->phandle);
> >> +	}
> >> +
> >> +	/* now do the children recursively */
> >> +	__for_each_child_of_node(node, child)
> >> +		__of_adjust_tree_phandles(child, phandle_delta);
> >=20
> > Again, recursion is not a good idea.
> >=20
>=20
> No other way to handle it. This is not a node that's in the live
> tree yet.

There's always another way to handle it, although it may be less
elegant.  In this case it should be easy though - populate the allnext
pointers when you unflatten the tree.  Or, have the offset applied
when you actually apply the overlay rather than as a separate pass.
=20
> >> +}
> >> +
> >> +/**
> >> + * Adjust the local phandle references by the given phandle delta.
> >> + * Assumes the existances of a __local_fixups__ node at the root
> >> + * of the tree. Does not take any devtree locks so make sure you
> >> + * call this on a tree which is at the detached state.
> >> + */
> >> +static int __of_adjust_tree_phandle_references(struct device_node *no=
de,
> >> +		int phandle_delta)
> >> +{
> >> +	phandle phandle;
> >> +	struct device_node *refnode, *child;
> >> +	struct property *rprop, *sprop;
> >> +	char *propval, *propcur, *propend, *nodestr, *propstr, *s;
> >> +	int offset, propcurlen;
> >> +	int err;
> >> +
> >> +	/* locate the symbols & fixups nodes on resolve */
> >> +	__for_each_child_of_node(node, child)
> >> +		if (of_node_cmp(child->name, "__local_fixups__") =3D=3D 0)
> >> +			break;
> >> +
> >> +	/* no local fixups */
> >> +	if (child =3D=3D NULL)
> >> +		return 0;
> >> +
> >> +	/* find the local fixups property */
> >> +	for_each_property_of_node(child, rprop) {
> >> +
> >> +		/* skip properties added automatically */
> >> +		if (of_prop_cmp(rprop->name, "name") =3D=3D 0)
> >> +			continue;
> >=20
> > Ok, so you're interpreting any property except name in the
> > __local_fixups__ node in exactly the same way?  That's a bit strange.
> > Why not just have a single property rather than a node's worth in that
> > case.
>=20
> It saves space. For example you might have to resolve a label reference
> more than once. So instead of doing:
>=20
> 	label =3D "/foo:bar:0";
> 	label =3D "/bar:foo:4";
>=20
> You can do this:
>=20
> 	label =3D "/foo:bar:0", "/bar/foo:4";

Um.. you seem to have read me as saying the exact opposite of what I
said.  I'm _suggesting_ that you use:
	__local_fixups__ =3D "/foo:bar:0", "/bar/foo:4";
Since the 'label' name has no meaning in the case of local fixups.

> >> +		/* make a copy */
> >> +		propval =3D kmalloc(rprop->length, GFP_KERNEL);
> >> +		if (propval =3D=3D NULL) {
> >> +			pr_err("%s: Could not copy value of '%s'\n",
> >> +					__func__, rprop->name);
> >> +			return -ENOMEM;
> >> +		}
> >> +		memcpy(propval, rprop->value, rprop->length);
> >> +
> >> +		propend =3D propval + rprop->length;
> >> +		for (propcur =3D propval; propcur < propend;
> >> +				propcur +=3D propcurlen + 1) {
> >> +
> >> +			propcurlen =3D strlen(propcur);
> >> +
> >> +			nodestr =3D propcur;
> >> +			s =3D strchr(propcur, ':');
> >=20
> > So, using strings with separators like this doesn't sit will with
> > existing device tree practice.  More similar to existing things would
> > have NUL separators and the integer values in binary, rather than
> > text (and yes, there is precedent for mixed string and integer content
> > in properties).
> >=20
>=20
> Hmm, I guess it can be done, but I wouldn't expect any space savings.

I'm not after space savings, just least-surprise by matching existing
common practices.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--vSsTm1kUtxIHoa7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD+EAQACgkQaILKxv3ab8a6qwCgibTKLFLGleoV5q11GVB9+VAd
6nwAn1qTps//ADvT/fKB4PjGH9PPLziy
=uZw6
-----END PGP SIGNATURE-----

--vSsTm1kUtxIHoa7M--
