Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaKEUWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:22:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54792 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbaKEUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:22:03 -0500
Message-ID: <1415218907.3398.16.camel@decadent.org.uk>
Subject: Re: [PATCH 3.2 087/102] nEPT: Nested INVEPT
From: Ben Hutchings <ben@decadent.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Jun Nakajima <jun.nakajima@intel.com>,
        Xinhao Xu <xinhao.xu@intel.com>, Yang Zhang <yang.z.zhang@intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@redhat.com>, "Nadav Har'El" <nyh@il.ibm.com>
Date: Wed, 05 Nov 2014 20:21:47 +0000
In-Reply-To: <54579F4B.8050404@redhat.com>
References: <lsq.1414880883.12343835@decadent.org.uk>
		 <5455F35E.1040304@redhat.com> <1415022261.27313.25.camel@decadent.org.uk>
	 <54579F4B.8050404@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LfaSOSMddx/RpE6s1Sre"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LfaSOSMddx/RpE6s1Sre
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-11-03 at 16:29 +0100, Paolo Bonzini wrote:
> On 03/11/2014 14:44, Ben Hutchings wrote:
> >> You can just use the same scheme as your patch 88/102:
> > Why is that?  Why should I not use the upstream version?
>=20
> Because it makes no sense to invalidate nested EPT page tables, if the=
=20
> kernel cannot make nested EPT page tables in the first place.

Indeed, but I didn't realise it wasn't.

> I think that this "if" in your patch should always trigger, thus making
> your large patch equivalent to my small patch:
>=20
> +	if (!(nested_vmx_secondary_ctls_high & SECONDARY_EXEC_ENABLE_EPT) ||
> +	    !(nested_vmx_ept_caps & VMX_EPT_INVEPT_BIT)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
>=20
> ... but without looking at the entire source of vmx.c in the relatively
> old 3.2 kernel, I'd rather play it safe and avoid introducing bugs in cas=
e
> the above turns out not to be true.

I see - only the SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES flag should be
set in nested_vmx_secondary_ctls_high.  I'll use your simple version,
thanks.

Ben.

--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.

--=-LfaSOSMddx/RpE6s1Sre
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFqG4Oe/yOyVhhEJAQpvcxAAuo1SMuwrnQkronEK0TPnT4OwS1OaZy4e
uv3uEKOqmrKNArh5zeDoyPklotSx+SDMjL5X+MYcQGy/wmpr7bOgv5ipX0TDx/da
+B2EUln1ygXj3vsjQLFsDOtQkYJZgdeobKTS/2+5fjF/qjSejmn7K4DOSYH395A3
bQ3pUrwIjRiLhu1yxzycBkWQPDDHFvaUPI+m5vNetwL7jACrCN40Qrw5SibW7hyR
4zQV4sOi3CpQ1a77PigSNHaPatTVZZIVUfRo59dRjPnnucR/UncsnPmkoVZT4vZ0
3zSmLX0p0ntPvHR71llHR202PomVtqOXxlzlSDmL7b9I3VlLM9B2XYk86jouJD/8
Mk3tEF8a7EZUMRuM9i6/oyTUHay7AEuBMfQjtPUy/KytkAcd3SSX8yTTMa0ne/Gz
NnWFClTiHOUF8DBu/aF/SxYbamQ4FiR/FTCoMCKgh8kruPTK52y5RvjZgxtPmpqA
+AWXWvYynMlIzW+TEQJfHaQSDM3AhS9AhriG21GhFunrGPVoC8dBwZViihCg2f0m
4RJQqakMwvULocOmz3luESiIntJTzs1IAKqG5sJ7HvPxe1LQroQXnYMyM/CH89u3
P0pusJld5yiJobhjnug/EpWQPxsci0MQaMZ6RVQ09kWR3KoCPDRCPKHw+XTAN+sp
NiWmMoWGfpQ=
=pEte
-----END PGP SIGNATURE-----

--=-LfaSOSMddx/RpE6s1Sre--
