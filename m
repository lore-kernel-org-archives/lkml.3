Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3HLUOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:14:48 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17512 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab3HLUOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:14:47 -0400
X-IronPort-AV: E=Sophos;i="4.89,864,1367971200"; 
   d="asc'?scan'208";a="43548674"
Message-ID: <1376338483.15390.271.camel@Solace>
Subject: Re: [Xen-devel] [PATCH v1][RFC] drivers/xen,	balloon driver numa
 support in kernel
From: Dario Faggioli <dario.faggioli@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Yechen Li <lccycc123@gmail.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 12 Aug 2013 22:14:43 +0200
In-Reply-To: <52092CF9.4050006@citrix.com>
References: <1376316812-30346-1-git-send-email-lccycc123@gmail.com>
	 <52092CF9.4050006@citrix.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-2vqTMsqVe41776K6LAAE"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-2vqTMsqVe41776K6LAAE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun, 2013-08-12 at 19:44 +0100, David Vrabel wrote:
> On 12/08/13 15:13, Yechen Li wrote:
> >   This small patch adds numa support for balloon driver. Kernel version=
: 3.11-rc5
> >   It's just a RFC version, since I'm waiting for the interface of numa =
topology.
> >   The balloon driver will read arguments from xenstore: /local/domain/(=
id)/memory
> > /target_nid, and settle the memory increase/decrease operation on speci=
fied
> > p-nodeID.
>=20
> Its is difficult to review an ABI change without any documentation for
> the new ABI.
>=20
Indeed.

> I would also like to see a design document explaining the overall
> approach planned to be used here.  It's not clear why explicitly
> specifying nodes is preferable to (e.g.) the guest releasing/populating
> evenly across all its nodes (this would certainly be better for the guest=
).
>=20
I see what you mean. Personally, I think they're different things. There
might be the need, from the host system administrator, to make as much
room as possible on one (or perhaps a few) nodes, in which case, the
possibility of specifying that explicitly would be a plus.

That would allow --if used wisely, I agree with you on this-- for better
resource utilization, in the long run.

In absence of this information, it is probably true that the guest would
benefit from a more even approach. What we want to achieve here,
however, is as follows: suppose that a virtual NUMA enabled guest (i.e.,
a guest with a virtual NUMA topology), has guest page X, which is on
virtual node g1 in the guest itself, backed by a frame from host node
h0. Well, we really would like to try having page X always backed by a
frame on host node h1, even after ballooning down and up.

> It seems like unless this is used carefully, all VMs will end up with
> suboptimal memory layouts as they are repeatedly balloon up and down to
> satisfy the whims of the latest VM being started etc.
>=20
I'm not sure I see entirely what you mean, but for sure I repeat that I
agree that more information about the design and intended usage patterns
are needed... Let's see whether Yechen is up for providing that. :-)

Thanks for having a look anyway,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-2vqTMsqVe41776K6LAAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iEYEABECAAYFAlIJQjMACgkQk4XaBE3IOsSeAgCfSjhvbA149VkksFZWghXuI70s
XfoAoJEseLgW4dkB+uKnRnXdtlbdBJkm
=ar80
-----END PGP SIGNATURE-----

--=-2vqTMsqVe41776K6LAAE--
