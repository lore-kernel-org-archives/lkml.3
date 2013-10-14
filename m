Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab3JNHWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:22:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:26241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab3JNHWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:22:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,490,1378882800"; 
   d="asc'?scan'208";a="410464555"
Date: Mon, 14 Oct 2013 03:07:27 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
Message-ID: <20131014070727.GE12189@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-9-git-send-email-gong.chen@linux.intel.com>
 <20131011161436.GM5925@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <20131011161436.GM5925@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 06:14:36PM +0200, Borislav Petkov wrote:
> Date: Fri, 11 Oct 2013 18:14:36 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 8/8] ACPI / trace: Add trace interface for eMCA driver
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
=2E..
> > +static void dimm_err_location(struct cper_sec_mem_err *mem)
> > +{
> > +	memset(dimm_location, 0, LOC_LEN);
> > +	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
>=20
> By reversing this test you can save yourself an indentation level and a
> superfluous memset:
>=20
> 	if (!(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
> 		return;
>=20
> 	memset(dimm_location, 0, LOC_LEN);
> 	dmi_memdev_name...
> 	...
>=20
>=20
memset should be called before return, otherwise the values from last time
will happen again in this time.

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSW5gvAAoJEI01n1+kOSLHA7cP/00H7j62IM+atC6sY6HnzYUl
OWy/uj0cIl8zX+A8E4nIx/mHNqgZQgxpHAL/ome8nqHOsJlVCs0ncynfWbVhvlm+
qkKJ+OMZfTSnZNn8SsIkIk6xHTyFadLF8NZBxl695nHrplW8UCWqA2zoqmlJ4T8G
Q9WWg59/SljI4eFq6SPU+0mjmn50HAmAFbq05qqXP0AITYRcAGeZn18k1N+/n37t
4r0Ga+A1HdJnqKjE8N8i/4BaFGmw2NNcalZZbZ4qe+x7jQWOCjcr7UKXAh8c/+N/
mR+KX+MQVwx9l9zNw0crDi5TnOcizdxWetpkc8x2xpbAiH0mc8xlr2eQaVt1Nuhc
VMnqspVv12KzcNvCf3Rajed01qDDUE2kVOP2S5TH0S8tSjaEyldbodTsJhLqiCnw
DCBKxsmclnXFeG7Lf3nQGpNCoLmW85ENSo/+NfVMzb55UkTLusVFfXLe1ONlvP/d
91pJ4F82itbEFRsZGaoG0bHcj7R5yXIW5i1KMu0rjKl+rmwE8ewQIkFLu3a3N5d+
1X2avRbkTkjuyb3n/MqpCEvmaWlkb+fyU6vkBQ2ZV9aT47pWJPBkkdf4/61PQRX/
oXPnj4KRlFbBfoG5qTJs0NPC7PjDmxiBjAI+r3Md8/4zx/zVi0luFvnBB2Oa5ub8
1Y+CbFtqyHQXTFQ8H8HF
=vYVT
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
