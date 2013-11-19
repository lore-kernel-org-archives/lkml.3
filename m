Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab3KSS35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:29:57 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37643 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab3KSS3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:29:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,730,1378857600"; 
   d="asc'?scan'208";a="76066701"
Message-ID: <1384885783.15360.40.camel@Solace>
Subject: Re: [Xen-devel] [PATCH v2 0/2] xen: vnuma introduction for pv guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Elena Ufimtseva <ufimtseva@gmail.com>, <akpm@linux-foundation.org>,
        <wency@cn.fujitsu.com>, <stefano.stabellini@eu.citrix.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <mingo@redhat.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <tglx@linutronix.de>, <ian.campbell@citrix.com>
Date: Tue, 19 Nov 2013 19:29:43 +0100
In-Reply-To: <20131119153837.GA5966@phenom.dumpdata.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	 <20131119153837.GA5966@phenom.dumpdata.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-uNrs0cG+WdZMPcEaml6m"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-uNrs0cG+WdZMPcEaml6m
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On mar, 2013-11-19 at 10:38 -0500, Konrad Rzeszutek Wilk wrote:
> On Mon, Nov 18, 2013 at 03:25:48PM -0500, Elena Ufimtseva wrote:
> > The patchset introduces vnuma to paravirtualized Xen guests
> > runnning as domU.
> > Xen subop hypercall is used to retreive vnuma topology information.
> > Bases on the retreived topology from Xen, NUMA number of nodes,
> > memory ranges, distance table and cpumask is being set.
> > If initialization is incorrect, sets 'dummy' node and unsets
> > nodemask.
> > vNUMA topology is constructed by Xen toolstack. Xen patchset is
> > available at https://git.gitorious.org/xenvnuma/xenvnuma.git:v3.
>=20
> Yeey!
>=20
:-)

> One question - I know you had questions about the
> PROT_GLOBAL | ~PAGE_PRESENT being set on PTEs that are going to
> be harvested for AutoNUMA balancing.=20
>=20
> And that the hypercall to set such PTE entry disallows the
> PROT_GLOBAL (it stripts it off)? That means that when the
> Linux page system kicks in (as it has ~PAGE_PRESENT) the
> Linux pagehandler won't see the PROT_GLOBAL (as it has
> been filtered out). Which means that the AutoNUMA code won't
> kick in.
>=20
> (see http://article.gmane.org/gmane.comp.emulators.xen.devel/174317)
>=20
> Was that problem ever answered?
>=20
I think the issue is a twofold one.

If I remember correctly (Elena, please, correct me if I'm wrong) Elena
was seeing _crashes_ with both vNUMA and AutoNUMA enabled for the guest.
That's what pushed her to investigate the issue, and led to what you're
summing up above.

However, it appears the crash was due to something completely unrelated
to Xen and vNUMA, was affecting baremetal too, and got fixed, which
means the crash is now gone.

It remains to be seen (I think) whether that also means that AutoNUMA
works. In fact, chatting about this in Edinburgh, Elena managed to
convince me pretty badly that we should --as part of the vNUMA support--
do something about this, in order to make it work. At that time I
thought we should be doing something to avoid the system to go ka-boom,
but as I said, even now that it does not crash anymore, she was so
persuasive that I now find it quite hard to believe that we really don't
need to do anything. :-P

I guess, as soon as we get the chance, we should see if this actually
works, i.e., in addition to seeing the proper topology and not crashing,
verify that AutoNUMA in the guest is actually doing is job.

What do you think? Again, Elena, please chime in and explain how things
are, if I got something wrong. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-uNrs0cG+WdZMPcEaml6m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlKLrhcACgkQk4XaBE3IOsS5wQCeO8qcik1SOXMA/gSM6aX6gczM
yJgAnRMYxQmQ9MIzyjLobg67maqtBCEz
=/Plc
-----END PGP SIGNATURE-----

--=-uNrs0cG+WdZMPcEaml6m--
