Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3LXDJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:09:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:27610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737Ab3LXDJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:09:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,540,1384329600"; 
   d="asc'?scan'208";a="454872080"
Date: Mon, 23 Dec 2013 21:51:00 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in
 check_irq_vectors_for_cpu_disable()
Message-ID: <20131224025059.GA24419@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@Intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Janet Morgan <janet.morgan@Intel.com>,
	Tony Luck <tony.luck@Intel.com>, Ruiv Wang <ruiv.wang@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
	stable@vger.kernel.org
References: <1387809552-20529-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <1387809552-20529-1-git-send-email-prarit@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Dec 23, 2013 at 09:39:12AM -0500, Prarit Bhargava wrote:
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 7d40698..aed7acc 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -281,7 +281,7 @@ int check_irq_vectors_for_cpu_disable(void)
>  			desc = irq_to_desc(irq);
>  			data = irq_desc_get_irq_data(desc);
>  			affinity = data->affinity;
> -			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>  			    !cpumask_subset(affinity, cpu_online_mask))
>  				this_count++;
Hi, Prarit

I noticed that you don't mention another question I asked in last mail.

"It looks like cpu_online_mask will be updated until cpu_disable_common
is called, but your check_vectors is called before that."

native_cpu_disable
        cpu_disable_common
                remove_cpu_from_maps
                        /*
                         * until here, cpu_online_mask/cpu_online_bits
                         * is cleared
                         */
                        set_cpu_online(cpu, false);

Something I missed?

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSuPaTAAoJEI01n1+kOSLHlEQP+gIknHXPz/Im8iLWBzgVlQeq
NW9DfTMsodimlAV/UjwrFQwBp8k2FqeXcumCCiM7H6ksam7GWyK8bhO+iO94nPdK
YMq+VuyQXcd6Qstz9d68OmuqQ2KpEh0SeYd7Jj38QHzKOpQPwIuOdLjAWDEcoGSv
GNqYQ83zGnRLuC/mvSqvbgMAbyD6rBYHdh2v34Z9Lk61QDvXolJnZGD0g0TkFvJq
XHpGf/9m96w6k9QpsuOzyhqfOpkFgog+aW6qInPNUcau+XxX8bt16PY64cRHId4n
0hOyDoh3K9cYMPCuTBWq4CK3ZIQSIo4GA37NFYY8J0ycbBO5dJDNSGLvO4Vdp+Rf
+mqrzS2uNOkPJ+tt1vhIvenpsfL09yPNzIkuIe9YCux2b1C0hqgcVAc5j/YLxucc
5PesRukmafWLFL1siaCdUkylWLicxFIYPKvZ6QJYchMFirhr22/UL1aJimY0Q/0j
Eilw2MCT3rog4Chqu/yLXM8G5RysS8yGJYdYeZRricoN6l0pNnwbgxaBNfqJPHh2
MB8X2LkipOdV+kgsF0vNajSsIvjJZ/4TFlFMB02Re0/+mud71uAZzW8ruCbHGTAx
gjwIz9hZEM9GfDhuSWE3LXxeid5RvMatQ36jF/Lqm/AkyNprrJoElhJOvKCATHjk
iZ20uZfP4yEq/FM6OMnJ
=gjUo
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
