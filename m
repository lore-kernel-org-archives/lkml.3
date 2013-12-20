Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab3LTPjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:39:00 -0500
Received: from smtp.citrix.com ([66.165.176.89]:25417 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab3LTPi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:38:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,521,1384300800"; 
   d="asc'?scan'208";a="86590905"
Message-ID: <1387553932.23792.75.camel@Solace>
Subject: Re: [Xen-devel] [PATCH v2 0/2] xen: vnuma introduction for pv guest
From: Dario Faggioli <dario.faggioli@citrix.com>
To: Elena Ufimtseva <ufimtseva@gmail.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <akpm@linux-foundation.org>, <wency@cn.fujitsu.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>, <mingo@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>
Date: Fri, 20 Dec 2013 16:38:52 +0100
In-Reply-To: <CAEr7rXjnkeYSCRmvvFyx06Q4rccfBD__-GzkrbJhUeEOjsT8Pg@mail.gmail.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	 <20131119153837.GA5966@phenom.dumpdata.com>
	 <1384885783.15360.40.camel@Solace>
	 <CAEr7rXiCL-MagPwn76ZdTOJH03M8GCrKF2fGw0YWdnPZK332CA@mail.gmail.com>
	 <CAEr7rXjgFi17vuV91R7=U4rkOKCMOw95kgWu0A0+yrfgHpR6Ow@mail.gmail.com>
	 <1386206018.3926.138.camel@Abyss>
	 <CAEr7rXiOeBCzSmbkKDPqaSt3H85wciOiG0z=-Lbi73_Lx6AkVg@mail.gmail.com>
	 <CAEr7rXjnkeYSCRmvvFyx06Q4rccfBD__-GzkrbJhUeEOjsT8Pg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-i50Dk+erqDRCabyQ4SpP"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
MIME-Version: 1.0
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-i50Dk+erqDRCabyQ4SpP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On ven, 2013-12-20 at 02:48 -0500, Elena Ufimtseva wrote:
> On Fri, Dec 20, 2013 at 2:39 AM, Elena Ufimtseva <ufimtseva@gmail.com> wr=
ote:
>
> > Dario, what tools did you use to test NUMA on xen? Maybe there is
> > something I can use as well?
> > Here http://lwn.net/Articles/558593/ Mel Gorman uses specjbb and jvm,
> > I though I can run something similar.
>=20
> And of course, more details will follow... :)
>=20
Yeah, well, during early investigation, I also used basically just
SpecJBB. See here:
http://blog.xen.org/index.php/2012/04/26/numa-and-xen-part-1-introduction/
http://blog.xen.org/index.php/2012/05/16/numa-and-xen-part-ii-scheduling-an=
d-placement/

For benchmarking our NUMA aware scheduling solution, in Xen, I used
SpecJBB, sysbench and LMbench:
http://blog.xen.org/index.php/2012/05/16/numa-and-xen-part-ii-scheduling-an=
d-placement/

The trickiest part is have the benchmark(s) of choice running
concurrently is a bunch of VMs on the same host. I used some hand
crafted scripts at the time, very specific to my own environment.

I'm working on abstracting that and putting together something more easy
to be shared and used outside my attic. :-P

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
-----------------------------------------------------------------
Dario Faggioli, Ph.D, http://about.me/dario.faggioli
Senior Software Engineer, Citrix Systems R&D Ltd., Cambridge (UK)


--=-i50Dk+erqDRCabyQ4SpP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iEYEABECAAYFAlK0ZIwACgkQk4XaBE3IOsRR7wCfQ/T8h6m1DknPlY0+g1Bp0RNB
cO8AnR1+v9xJoDvNQqWDxu4VDC5QIUOR
=oQPk
-----END PGP SIGNATURE-----

--=-i50Dk+erqDRCabyQ4SpP--
