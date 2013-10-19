Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3JSLl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 07:41:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:22139 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab3JSLl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 07:41:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,528,1378882800"; 
   d="asc'?scan'208";a="309896404"
Date: Sat, 19 Oct 2013 07:26:58 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com, m.chehab@samsung.com,
        arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
 output format
Message-ID: <20131019112658.GB16597@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	m.chehab@samsung.com, arozansk@redhat.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
 <1382084624-10857-9-git-send-email-gong.chen@linux.intel.com>
 <52612311.2000303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <52612311.2000303@linux.vnet.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2013 at 05:31:21PM +0530, Naveen N. Rao wrote:
> Date: Fri, 18 Oct 2013 17:31:21 +0530
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
>  bp@alien8.de, joe@perches.com, m.chehab@samsung.com
> CC: arozansk@redhat.com, linux-acpi@vger.kernel.org,
>  linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v3 8/9] ACPI, APEI, CPER: Cleanup CPER memory error
>  output format
> User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
>  Thunderbird/24.0
>=20
[...]
> >
> >@@ -358,17 +349,21 @@ void cper_estatus_print(const char *pfx,
> >  	struct acpi_generic_data *gdata;
> >  	unsigned int data_len, gedata_len;
> >  	int sec_no =3D 0;
> >+	char newpfx[64];
> >  	__u16 severity;
> >
> >-	printk("%s""Generic Hardware Error Status\n", pfx);
> >  	severity =3D estatus->error_severity;
> >-	printk("%s""severity: %d, %s\n", pfx, severity,
> >-	       cper_severity_str(severity));
> >+	if (severity !=3D CPER_SEV_FATAL)
>=20
> Shouldn't this just be (severity =3D=3D CPER_SEV_CORRECTED)?
>=20
> Thanks,
> Naveen
>=20
IMO, only fatal error can't be handlered gracefully in current
kernel plus H/W. Once it can be recovered by H/W and OS, we
can call it recovered.

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSYmyBAAoJEI01n1+kOSLHKbwQAJdMyxObPFUOv4LyuLwtgygS
DJbTklev4xdNjP7Vg7LNQ6R4d7zCjAJ9stziGfH8/EYxqFHit9LYDZ1xi8khCmpc
wYUMEg3SO3yOLUMBzX6FRrsqVz8bkym+IR1HqskcxrdzPNV+WTlT0VI0Ih1avQLu
hzA0WpE5dO0Q3m/K2peE+4nQAqmnUcFfiDVfGum14CzJABmhKNtSXTh9ozb1ZdXw
ifM4C45HxcqnNn6UGMlpv0mKvfB9ASzH3/jdRlPLqhntmS+vXo1JOcisAGuWBE/2
CgtY+D/0fK2qdS4ZmOknXsDit5Gh+TCqJV4j8MJNZ9PbA7+Kaoj1oKoXFkDiHgH2
t4oFCVmCTYkhU1m+e+RYeUOt6tzaNYpB6P5mFTZYKCQznJ3dQ6xYO0ORlITTwrUq
m1P0L3yRtBrX/F07KLWZjYkJgNBGYjOcsA6SQqYipUTfvXOqhxzF48bFkQ2JXeF8
veit/lDej3yTbPrlmW+CPJZO7ZMjSR2O7PGKM8W3AMTxrUTsqF4iabhwaFaizLSQ
Jszanx+raJE2mnIh2Nh+wGPhGZfuOUttu0M13r+hNX8ZpR2lmqSe+AqwAULnttAP
vc3kWyvOlIIWExB233P31cNTKP24hbG86gojPJzia2R/VhWnlgN5c+e05dTOmz/Z
hffIVt6mpgKsygsc8feM
=8gID
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
