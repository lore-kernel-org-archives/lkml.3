Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3KNLs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 06:48:56 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:2139 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab3KNLsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 06:48:54 -0500
X-IronPort-AV: E=Sophos;i="4.93,699,1378857600"; 
   d="asc'?scan'208";a="71866650"
Message-ID: <1384429730.29902.129.camel@Abyss>
Subject: Re: [Xen-devel] [PATCH 1/2] xen: vnuma support for PV guests
 running as domU.
From: Dario Faggioli <dario.faggioli@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: <ian.campbell@citrix.com>, <wency@cn.fujitsu.com>,
        <stefano.stabellini@eu.citrix.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <mingo@redhat.com>, <tglx@linutronix.de>,
        Elena Ufimtseva <ufimtseva@gmail.com>, <hpa@zytor.com>,
        <xen-devel@lists.xenproject.org>, <akpm@linux-foundation.org>,
        <boris.ostrovsky@oracle.com>
Date: Thu, 14 Nov 2013 12:48:50 +0100
In-Reply-To: <5284B238.6020601@citrix.com>
References: <1384400179-24404-1-git-send-email-ufimtseva@gmail.com>
		 <1384400179-24404-2-git-send-email-ufimtseva@gmail.com>
	 <1384414000.29902.25.camel@Abyss> <5284B238.6020601@citrix.com>
Organization: Citrix Ltd
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-Gp7q+zuZ0WYQwMHMyskE"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-Gp7q+zuZ0WYQwMHMyskE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On gio, 2013-11-14 at 11:21 +0000, David Vrabel wrote:
> On 14/11/13 07:26, Dario Faggioli wrote:
> > IIRC, it's more something that was already happening (the breakage, I
> > mean), than a "safety net" for the unforeseeable future. Might be worth
> > giving some context about it, perhaps referencing the email thread or
> > the git commit hash in the comment.
>=20
> Yes, a comment like:
>=20
> /*
>  * Set a dummy node and return success.  This prevents calling any
>  * hardware-specific initializers which do not work in a PV guest.
>  */
>=20
> is better.  No need to refer to any specific threads.  It's pretty clear
> that any hardware-specific init isn't appropriate for a PV guest.
>=20
Ok.

> >> +	if (rc !=3D 0) {
> >> +		for (i =3D 0; i < MAX_LOCAL_APIC; i++)
> >> +			set_apicid_to_node(i, NUMA_NO_NODE);
> >> +		nodes_clear(numa_nodes_parsed);
> >> +		nodes_clear(node_possible_map);
> >> +		nodes_clear(node_online_map);
> >> +		node_set(0, numa_nodes_parsed);
> >> +		numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
> >> +	}
> >> +	return 0;
> >>
> > Ok, so, we always return 'success', as we were saying during last round=
.
> > However, we do not call dummy_numa_init() directly, and instead we do
> > all these stuff, with the last two statements being exactly what
> > dummy_numa_init() does. Reason is linking, i.e., the fact that
> > dummy_numa_init() is not exported and you can't reach it from here,
> > right?
>=20
> I think this bit is fine as-is.
>=20
Ok, cool. :-) Shouldn't we then kill or reformulate the comments where
dummy_numa_init is explicitly referenced then?

E.g., this one: /* will pass to dummy_numa_init */

It might be me, but I find it rather confusing. After seeing that, I'd
expect to see that, at some point, either the function returns failure
(which of course we don't want), or a direct call dummy_numa_init().

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-Gp7q+zuZ0WYQwMHMyskE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKEuKIACgkQk4XaBE3IOsRVjACfb2PL3nON9u1oC/1kTCL8T30f
BhcAnRSpihw8iKude65Ph2G1eozGy05i
=v/x9
-----END PGP SIGNATURE-----

--=-Gp7q+zuZ0WYQwMHMyskE--
