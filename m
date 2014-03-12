Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaCLWSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:18:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56056 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaCLWSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:18:48 -0400
Date: Wed, 12 Mar 2014 22:18:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312221828.da7bffd214e9749a5652ff22@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_22_18_28_+0000_qsdKRJrhV+y.GV_c"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the tip tree with the pci tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_22_18_28_+0000_qsdKRJrhV+y.GV_c
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in arch/x86/include=
/asm/topology.h between commit 25453e9e521382 ("x86/PCI: Remove mp_bus_to_n=
ode[], set_mp_bus_to_node(), get_mp_bus_to_node()") from the pci tree and c=
ommit 36fc5500bb1907bea7e ("sched: Remove unused mc_capable() and smt_capab=
le()") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).


diff --cc arch/x86/include/asm/topology.h
index c840571afa4e,9bcc724cafdd..000000000000
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@@ -131,13 -131,19 +131,7 @@@ static inline void arch_fix_phys_packag
  }
 =20
  struct pci_bus;
 +int x86_pci_root_bus_node(int bus);
  void x86_pci_root_bus_resources(int bus, struct list_head *resources);
 =20
- #ifdef CONFIG_SMP
- #define mc_capable()  ((boot_cpu_data.x86_max_cores > 1) && \
-                       (cpumask_weight(cpu_core_mask(0)) !=3D nr_cpu_ids))
- #define smt_capable()                 (smp_num_siblings > 1)
 -#ifdef CONFIG_NUMA
 -extern int get_mp_bus_to_node(int busnum);
 -extern void set_mp_bus_to_node(int busnum, int node);
 -#else
 -static inline int get_mp_bus_to_node(int busnum)
 -{
 -      return 0;
 -}
 -static inline void set_mp_bus_to_node(int busnum, int node)
 -{
 -}
--#endif
--
  #endif /* _ASM_X86_TOPOLOGY_H */

--Signature=_Wed__12_Mar_2014_22_18_28_+0000_qsdKRJrhV+y.GV_c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIN00AAoJELSic+t+oim9ALAQAJ0vEsQXiqaS4DE71EHZIrpG
HlflXLb+rsvo/93ctkgfPEbKbgzAjgU+c3ywTeS9DC5Qa4+IvAhdf7mwosiyPHzn
jrS6BgUjKgObISrvHCc5BAvTmz2+C6I7LL/oNx2oRpSEIt5fQqpJsw47Apr+X7Px
9DJQhI32yeWtPh65GpQLQPz8KQnq9c6Za9wjW7UnxMXMPi5vLfiD+vfAcl79PLZE
Cs1HGRcrWKxkLOPE5EgMt84gpPLcHT40FoNCtnAOgUW+Q6iVWewPSIjW/YmzY4T6
1LHsvB1qbPe09XG7BnvGGByIsJdKzFxixACBe6ggmNGuPkvdpTIV7K3sL11S/mxl
qUD4eErJ+PWn0vh3SQ/pX2fYxJQ3Be/mUObLBXNxKaztMdmJR83uFSm042sMJN6r
rkEeHWVbDWaXy+s8jy4jJHQLLEUbIgZXtEMrhvTAjTldtFUTx00w4M9a5EyiwU4Z
YWmCSLlFJGgt6lIpngnvxnZmeBtfGF4h9ZOuMYSb14IABhB6Jnp7nfnyhN6G+gwa
lHBQ2mzYkzsYi7tqlKLn1bJ/N5/wiv05F+HOQ1pK8fnSCwTmzgBIE7h5ycAmWYXc
3+wPhYkTkAzPMJ2v9SFcXDjWguCJAXUZNXucNvOhm+TpN5kHCg7hXmwrPfJFf9uX
mqz/sUaDebZFegWu+zdy
=zsPZ
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_22_18_28_+0000_qsdKRJrhV+y.GV_c--
