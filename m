Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3LTHgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:36:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:47569 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab3LTHgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:36:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,519,1384329600"; 
   d="asc'?scan'208";a="329237363"
Date: Fri, 20 Dec 2013 02:18:20 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
Message-ID: <20131220071820.GC4571@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	Tony Luck <tony.luck@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	X86-ML <x86@kernel.org>, Michel Lespinasse <walken@google.com>,
	Andi Kleen <ak@linux.intel.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	janet.morgan@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
 <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
 <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
 <52B336D4.8010809@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da4uJneut+ArUgXk"
Content-Disposition: inline
In-Reply-To: <52B336D4.8010809@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--da4uJneut+ArUgXk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 19, 2013 at 01:11:32PM -0500, Prarit Bhargava wrote:
>=20
> Yep.  The question really is this: is the irq mapped to a single vector or
> multiple vectors. (I think)
>=20
> P.
>=20
Yes, this is the original thought I want to express on the bugzilla. On an
ideal environment, without irq balance, all vector_irq should own same
values, say, 0xffffffff. So when one CPU is off-lined, your patch will
considers no places to contain these to-be-migrated irqs but the fact is
they are shared on different CPUs. So if we can answer this question,
the answer will be clear :-).

--da4uJneut+ArUgXk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSs+88AAoJEI01n1+kOSLHnoQP/1SX85O4Zgdi7duhLhcXVmu8
cffN1N15mfgQe+AH3Z9MyqaB7dP64DavR7YsoGHIz4XUMgsr255+NiDIov8HmgKt
7Cf8T/MFQ6Orp/+iV6wZK/fahQqRP58j4o3R0yY7wvggV77t8CyEtUfilHxANaen
veONg2ai7wfD/QRz866MqiN073FHLWB6On9Oyuf9t/3CACWp34+57WJXLNaPJfrK
0OmbSD/XM2nPnz/u4096sEDAz+kXfW04sMuc3WDD6+M+S3su22SEdvNvKOPJRWH8
5gSu4fPSSan1LEqUfsqBTrqBRgzEZJCXnJeIQCuequvhy0L47qxcHjzNMlHFLmhw
X+bCNwrqeirra0YdvSOSyoSn5/I17j1nrozrJYUAOy9dX6PS6HZPIuIm+mz9GTvi
IcsTJ6n4wlWJZLAiwCTplj2/FWyKkprJPkKdsdIL+IVlRxwBK4VRi4Rw/CXFqSGO
Ni16qxJsxFJKCMzUtAAYZYj/UrpLn/kIDnAeJJDs4wAhMvgIYHgF80LgK/8BceP3
Q9recg3flG2N3GION+6tJsFsqp20FjcsbkEuk/yGn7HjUdXDj/Z6dj4FRqoueQiT
+XHBMFshfsg3lqTW6ZdAVnyUhHcxFlwM4tygJWn+LUe8/0Wj+7NpqO/MrBKKOPHz
XDJsHr6sG7iAqN3L15nT
=UJJS
-----END PGP SIGNATURE-----

--da4uJneut+ArUgXk--
