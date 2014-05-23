Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaEWG2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 02:28:55 -0400
Received: from ozlabs.org ([103.22.144.67]:53094 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbaEWG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 02:28:53 -0400
Date: Fri, 23 May 2014 16:28:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        AKASHI Takahiro <takahiro.akashi@linaro.org>
Subject: linux-next: manual merge of the tip tree with the arm64 tree
Message-ID: <20140523162844.05e6ac65@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/qoZaKI.ox=EhOqq1DryYSkL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/qoZaKI.ox=EhOqq1DryYSkL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/arm64/include/asm/thread_info.h between commit 449f81a4da4d
("arm64: make a single hook to syscall_trace() for all syscall
features") from the arm64 tree and commit 842514849a61 ("arm64: Remove
TIF_POLLING_NRFLAG") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/include/asm/thread_info.h
index 9c086c63f911,7b8e3a2a00fb..000000000000
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@@ -103,12 -99,7 +102,11 @@@ static inline struct thread_info *curre
  #define TIF_SIGPENDING		0
  #define TIF_NEED_RESCHED	1
  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 +#define TIF_FOREIGN_FPSTATE	3	/* CPU's FP state is not current's */
  #define TIF_SYSCALL_TRACE	8
 +#define TIF_SYSCALL_AUDIT	9
 +#define TIF_SYSCALL_TRACEPOINT	10
 +#define TIF_SECCOMP		11
- #define TIF_POLLING_NRFLAG	16
  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
  #define TIF_FREEZE		19
  #define TIF_RESTORE_SIGMASK	20

--Sig_/qoZaKI.ox=EhOqq1DryYSkL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfuqhAAoJEMDTa8Ir7ZwV9BkP/0EV8EuvWkiC/PVB8K6a7bHJ
vlJVVNIJkwD8jLdhjhwTr3S5Dt2NwaBZNt1I5zC4y+ADqOp/RLPlnmK6pKDUUmx+
BcCPcXOtNcsY4Kr00slmYbJyIa56Qq2ZqF1WUvKzQb+plwfsEVbQGrlxPa8q3BiK
DQ1a5evq+ToX7xnj1GHdz9FBl8MHomdaYZKUIMJLfJbhY7NfH5WNomcXoWma4mtz
xVX7Tqxid0ozLXrq8h0dOt0Q+m8jyXtnY8FqWpLoQX5k+8IHPx5kDtsyWfITAPEZ
U6nRP7k19TzLviVbkzQy9raeNP4emdVQFSKVs9Zr8AjsUqqyzYWgr0VmPxyUL9v6
1d7LzyG4mxwCVvDm8XIN+0BpmW+Z77+HMy0j06hi+9y/GbHp096SWjwrZms6fl9q
LeM7INPsMNfptszxfO2yr1NViGz4TE5MvmFwDRmZiwNOZ7nTUNvGx2nTNzny9CmR
nW4GwwUj6Tgfzdaho09C8YpilaLteO0dAaT35/3ZVbWc7hOXnlg95sLpfKqoz5dk
6WjZYGqLuwFnA4Gin8zQ5qZX7cFJcs90MHmDnlzLEcc1Wnh9QbVd6SIAYBrwUH6z
oGqk8MukiqCktghDVc4GEPOReJUvC6GtCyUeh7g5GucDI45+SXdjvmCyV9koQAvG
mrvADaRLG9/FVFpfjcfq
=uaWo
-----END PGP SIGNATURE-----

--Sig_/qoZaKI.ox=EhOqq1DryYSkL--
