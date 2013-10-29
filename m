Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775Ab3J2Gdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:33:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53081 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3J2Gdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:33:38 -0400
Date: Tue, 29 Oct 2013 17:33:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chen, Gong" <gong.chen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: linux-next: manual merge of the tip tree with the pci tree
Message-Id: <20131029173311.1872490e2255157a5528d405@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Oct_2013_17_33_11_+1100_N+qGZw1O+lzBdCEJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Oct_2013_17_33_11_+1100_N+qGZw1O+lzBdCEJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
include/linux/acpi.h between commit c8678473609b ("ACPI: Tidy acpi_run_osc
() declarations") from the pci tree and commit 4b3db708b114 ("ACPI, x86:
Extended error log driver for x86 platform") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/acpi.h
index 35e68358ad06,c30bac8503bc..000000000000
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@@ -294,33 -294,32 +294,34 @@@ void __init acpi_nvs_nosave_s3(void)
  #endif /* CONFIG_PM_SLEEP */
 =20
  struct acpi_osc_context {
 -	char *uuid_str; /* uuid string */
 +	char *uuid_str;			/* UUID string */
  	int rev;
 -	struct acpi_buffer cap; /* arg2/arg3 */
 -	struct acpi_buffer ret; /* free by caller if success */
 +	struct acpi_buffer cap;		/* list of DWORD capabilities */
 +	struct acpi_buffer ret;		/* free by caller if success */
  };
 =20
 -#define OSC_QUERY_TYPE			0
 -#define OSC_SUPPORT_TYPE 		1
 -#define OSC_CONTROL_TYPE		2
 -
 -/* _OSC DW0 Definition */
 -#define OSC_QUERY_ENABLE		1
 -#define OSC_REQUEST_ERROR		2
 -#define OSC_INVALID_UUID_ERROR		4
 -#define OSC_INVALID_REVISION_ERROR	8
 -#define OSC_CAPABILITIES_MASK_ERROR	16
 -
+ acpi_status acpi_str_to_uuid(char *str, u8 *uuid);
  acpi_status acpi_run_osc(acpi_handle handle, struct acpi_osc_context *con=
text);
 =20
 -/* platform-wide _OSC bits */
 -#define OSC_SB_PAD_SUPPORT		1
 -#define OSC_SB_PPC_OST_SUPPORT		2
 -#define OSC_SB_PR3_SUPPORT		4
 -#define OSC_SB_HOTPLUG_OST_SUPPORT	8
 -#define OSC_SB_APEI_SUPPORT		16
 +/* Indexes into _OSC Capabilities Buffer (DWORDs 2 & 3 are device-specifi=
c) */
 +#define OSC_QUERY_DWORD				0	/* DWORD 1 */
 +#define OSC_SUPPORT_DWORD			1	/* DWORD 2 */
 +#define OSC_CONTROL_DWORD			2	/* DWORD 3 */
 +
 +/* _OSC Capabilities DWORD 1: Query/Control and Error Returns (generic) */
 +#define OSC_QUERY_ENABLE			0x00000001  /* input */
 +#define OSC_REQUEST_ERROR			0x00000002  /* return */
 +#define OSC_INVALID_UUID_ERROR			0x00000004  /* return */
 +#define OSC_INVALID_REVISION_ERROR		0x00000008  /* return */
 +#define OSC_CAPABILITIES_MASK_ERROR		0x00000010  /* return */
 +
 +/* Platform-Wide Capabilities _OSC: Capabilities DWORD 2: Support Field */
 +#define OSC_SB_PAD_SUPPORT			0x00000001
 +#define OSC_SB_PPC_OST_SUPPORT			0x00000002
 +#define OSC_SB_PR3_SUPPORT			0x00000004
 +#define OSC_SB_HOTPLUG_OST_SUPPORT		0x00000008
 +#define OSC_SB_APEI_SUPPORT			0x00000010
 +#define OSC_SB_CPC_SUPPORT			0x00000020
 =20
  extern bool osc_sb_apei_support_acked;
 =20

--Signature=_Tue__29_Oct_2013_17_33_11_+1100_N+qGZw1O+lzBdCEJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSb1arAAoJEMDTa8Ir7ZwV0Y8P/RHLRvGInWxT1GIOQH0irC8V
rJU2cp7mbCACILbzve7SEAJDGcdUm4bVSgSSptM4SpzEuVASv49XGwJ5BExzgK69
WxkJfSX1/OpcQ4uilO2Bqy5wR9Y4lXcDhCWKTTljhD4mtlAP2EP/Lj/yfJ4BDrnE
PsLs9vXuP1YldBC7jY4TUeWXdoMndPECW58wooXoaC4WOwkgBifwRAuwDhQ5IZHK
NVvLgBJd/GWdqOf8BXAb42J9dI8OyohUrthOn3T66SA8Y0dSBcCd31zEz0P4nsOo
1F38IIgudPxI51hhkSh2Ip12v1CTYpjDavbPI23h5uvT7/8ZcpEyju6Pu+o24twd
L6Gu5qK238MtJHeMHzSKfaSPLFKb61HM1MJPNme7nfI05scBdUL1bcpsPnGFbaRs
3xbAeI274g+pvJdRSpUNgaRVuKIY/FSToTYCjbci2CG5Tb0PSkzsd+AP8ae0FKEn
QMdlpyuw0fPTakmIm+zs7Vg7+e/0cFe1rl9CbQRJL7jj48y9Y01eZKaIpwtqNXwj
HsrsE38bE/qicR8Zk7dMs+4tTgYV02gVrfob+pyr1h6kYxOvAXA6EuQoXz2y0oMs
i+5W1TvJQ0/8B3JMmc+CnzktKjscxxTv5Tp52sc1s1qxdO8x9B5PdwuJnw8CjkTx
wc5kWhoC7mY+b9gKTrcQ
=ZbFF
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Oct_2013_17_33_11_+1100_N+qGZw1O+lzBdCEJ--
