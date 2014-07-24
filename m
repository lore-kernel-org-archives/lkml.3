Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbaGXCDE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 22:03:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:38390 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758588AbaGXCDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 22:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,721,1400050800"; 
   d="asc'?scan'208";a="577988987"
Date: Wed, 23 Jul 2014 21:31:30 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 12/70] x86, pci, amd_bus: _FROZEN Cleanup
Message-ID: <20140724013130.GA2434@gchen.bj.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-13-git-send-email-gong.chen@linux.intel.com>
 <20140723180718.GH21707@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20140723180718.GH21707@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 23, 2014 at 08:07:18PM +0200, Borislav Petkov wrote:
> Date: Wed, 23 Jul 2014 20:07:18 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
>  paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
>  hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
>  linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
>  davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
>  cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
>  JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
>  rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
>  mhocko@suse.cz, david@fromorbit.com
> Subject: Re: [RFC PATCH v1 12/70] x86, pci, amd_bus: _FROZEN Cleanup
> User-Agent: Mutt/1.5.23 (2014-03-12)
>=20
> On Tue, Jul 22, 2014 at 09:58:48PM -0400, Chen, Gong wrote:
> > Remove XXX_FROZEN state from x86/pci/amd_bus.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> >  arch/x86/pci/amd_bus.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >=20
> > diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> > index c20d2cc..30f0fca9 100644
> > --- a/arch/x86/pci/amd_bus.c
> > +++ b/arch/x86/pci/amd_bus.c
> > @@ -341,9 +341,8 @@ static int amd_cpu_notify(struct notifier_block *se=
lf, unsigned long action,
> >  			  void *hcpu)
> >  {
> >  	int cpu =3D (long)hcpu;
> > -	switch (action) {
> > +	switch (action & ~CPU_TASKS_FROZEN) {
> >  	case CPU_ONLINE:
> > -	case CPU_ONLINE_FROZEN:
> >  		smp_call_function_single(cpu, enable_pci_io_ecs, NULL, 0);
> >  		break;
> >  	default:
>=20
> Or you can kill all the switch-case gunk and make it even more readable:
>=20
But what if new action is added? We have to change it back. If you prefer
to use that style I can update in next version.

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT0GHyAAoJEI01n1+kOSLHKekP/3gl9cEIAJ2NpSrdFDG5tAT2
wZ869UMg4Zn0A95PTxIR152xTz9FKHXVRNj0wxnZqQYNQotPHdKxetkFzVARK8Ox
2YnMJXttNK89fcnmm0W70OdKLCT6PKUXFdM6vAvO61lrH0yXyzilBnEmKIe/4Woi
jvfWzV7sRSCCPaEiZ9xMPwLZDIekwwQzwLO9ozMueAeLTMJWqfZGLkrIMtBc4MXv
LVSim6OhtnP+pmNOjFTeVIUgC2VlFJXNHEmkxpIkpJMIcj/aOW62UCK92VbTtdY4
8N5l5IK78+8r+DnVOhM8yNU6//0DiM1LGxgqc9/RywPjzQuVDqbNS3JSNd/P4ELK
U5sjfGs2Ka1KzKVlR8BIsh3stbLMXEp10a7r/cg8c00PztAcJyRHQ+Qv6Ms/POkJ
Z10yT6jQVOLTZ4/PQY/JqANKu7ZMp3XDiaVQDU50WE0qmq6/nTvZNzz2Zoq2CNiK
tR80G2gzSoSZwQbdA5yE2sktEDnpzo6jhXFYpbh7IB19DHif8eRz1z8xW2HZjrK7
x3ZGc1t1vQ4Hol+0Z1PMzyhi80Qa1z9Wt8DrS5ZzEoSxBt1kgWsGBV8+8UgIYRKb
dUpTrhbKdpfTeObNMg+t+bZ3GiBr+jaJ9necZs/UT1Y77k0s07ryOSY0RbYPPIq3
cr9NSP9rZFX2IQoM/qMi
=OOfO
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
