Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaCQJAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:00:05 -0400
Received: from ozlabs.org ([203.10.76.45]:44141 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421AbaCQJAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:00:02 -0400
Date: Mon, 17 Mar 2014 19:59:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the powernv-cpuidle tree with the
 powerpc tree
Message-Id: <20140317195955.f7b50aa835d281caf5725610@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_19_59_55_+1100_MJm+zueLLJeqRQCd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_19_59_55_+1100_MJm+zueLLJeqRQCd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the powernv-cpuidle tree got a conflict in
arch/powerpc/include/asm/opal.h between commit c7e64b9ce04a
("powerpc/powernv Platform dump interface") from the powerpc tree and
commit 97eb001f0349 ("powerpc/powernv: Add OPAL call to resync timebase
on wakeup") from the powernv-cpuidle tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/include/asm/opal.h
index 2636acfcd340,c71c72e47d47..000000000000
--- a/arch/powerpc/include/asm/opal.h
+++ b/arch/powerpc/include/asm/opal.h
@@@ -159,15 -154,10 +159,16 @@@ extern int opal_enter_rtas(struct rtas_
  #define OPAL_FLASH_VALIDATE			76
  #define OPAL_FLASH_MANAGE			77
  #define OPAL_FLASH_UPDATE			78
+ #define OPAL_RESYNC_TIMEBASE			79
 +#define OPAL_DUMP_INIT				81
 +#define OPAL_DUMP_INFO				82
 +#define OPAL_DUMP_READ				83
 +#define OPAL_DUMP_ACK				84
  #define OPAL_GET_MSG				85
  #define OPAL_CHECK_ASYNC_COMPLETION		86
 +#define OPAL_DUMP_RESEND			91
  #define OPAL_SYNC_HOST_REBOOT			87
 +#define OPAL_DUMP_INFO2				94
 =20
  #ifndef __ASSEMBLY__
 =20
@@@ -888,13 -862,11 +889,14 @@@ extern void opal_get_rtc_time(struct rt
  extern unsigned long opal_get_boot_time(void);
  extern void opal_nvram_init(void);
  extern void opal_flash_init(void);
 +extern int opal_elog_init(void);
 +extern void opal_platform_dump_init(void);
 =20
  extern int opal_machine_check(struct pt_regs *regs);
 +extern bool opal_mce_check_early_recovery(struct pt_regs *regs);
 =20
  extern void opal_shutdown(void);
+ extern int opal_resync_timebase(void);
 =20
  extern void opal_lpc_init(void);
 =20

--Signature=_Mon__17_Mar_2014_19_59_55_+1100_MJm+zueLLJeqRQCd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJrmPAAoJEMDTa8Ir7ZwV4HIP/Alc3en+bBqvm4nsO7nlLkPU
0xqWYU8MQYTuQ0Ak9LABXYQ1JE6m6MvMIFunXzhOy6J6gBACieJjbHT3lilq/ZH6
FSVyLJEjMW3HVAAiP/ljGtcLpBoaUxIKxLAijNWLHrpSpPC5zAFh/mt7eQHtbVAi
Yw0SYY5sqSW3jeO+BfnPttCjLijltyAEaFGPUoY5PqudooImy6uRKQ2TDw2qgyBz
SOlwdbx/rklgnE0FpNRGQ/+Njq1vDQDcPh2gYDgwQBMQOCcnq6YQJ22DA9Rpa0ha
SnoSegEjkwuUCWOFikz0Lq/KX8k7L86rtkuclsWt1rIsh/JvTX2oUlpKea/5jxbv
EpTavAeR/NuSm+/5fN6P/BXz6+5NAw0B2lKEQOzUScD4VvZkL/QiU79ukyzOJjZi
RsMOv7g03R+JADfjD68pQJIZPqgSAwPfKpOHCjtCWHE/DutM6D0+RBCGgI6y71ND
VS36N7Y6LLTRQfGBOQly/MXmSTZQcSxxK1tbEbx034B1TwPBVnZL/zq/2z8oU2Jv
LePgRdRTc5Ve78AderfM7WkPCk+axAyL0GDr1hq5FB/oJ/e3q5aN+DcNTc5utcUz
Qk1wX6iMVi/Ft834lYW200CoeJHLMUAKgGLlR5QLSaWDUJymtQqVtoSbvgz7Z0bC
PvsdQx3nF6yXiYiFmFL2
=EYhw
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_19_59_55_+1100_MJm+zueLLJeqRQCd--
