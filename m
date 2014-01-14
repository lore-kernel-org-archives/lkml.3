Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaAND0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 22:26:44 -0500
Received: from ozlabs.org ([203.10.76.45]:44322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaAND0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 22:26:42 -0500
Date: Tue, 14 Jan 2014 14:26:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20140114142627.537a702607e703c6eff63640@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__14_Jan_2014_14_26_27_+1100_Dfl7rtkbotIs5xjd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jan_2014_14_26_27_+1100_Dfl7rtkbotIs5xjd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/cpufreq/speedstep-lib.c: In function 'speedstep_get_freqs':
drivers/cpufreq/speedstep-lib.c:467:2: error: implicit declaration of funct=
ion 'preempt_check_resched' [-Werror=3Dimplicit-function-declaration]
  preempt_check_resched();
  ^

Caused by commit 62b94a08da1b ("sched/preempt: Take away
preempt_enable_no_resched() from modules") interacting with commit
24e1937b2386 ("speedstep-smi: enable interrupts when waiting") from the
pm tree.

For now, I have reverted that pm tree commit.  Please sort this out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__14_Jan_2014_14_26_27_+1100_Dfl7rtkbotIs5xjd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1K5nAAoJEMDTa8Ir7ZwV3QwP/iDrm/iLU/rN7TZbD4vHqSsj
p27fBoppSfK+JTrgLllProzxVoDQhHOUid2C/A5AOxijBlC/8c+QfHGlfVJy2p1G
lDDhmFV9H2U0ceN+l/xv0WWJY/7gfwj+d7S5cZupsRIT5BekBfILLKaLCVof3g7J
V9U0QH+3Y0Zk/GDPqXtupoOUr8NDdZPmIHVvN6lSomgX2aHuK3yEXctrUNIqi17I
3de7OU/qtc9d+7T+WxpTcAkuDnHfTF8eUwjQi+L+y7tDkPdbrFD8Hzj9TGhIkf8G
Iw3bamRPsit8q8NmbM/cqGtjInllutKkhH7gd7/WnLMfliAaTgy6uNLrc+BRdZ2H
phZfCpT8m0u6Qq3ecZzMgCQA60DHFordGjd4rp2vJa95/ND87UE0xg+i+EMRo2Q4
kd85IXtqA8dDEjz4VpEl2P9+CzBGnEq2Wv0zdcjKnCz24Vj1PXe0j2106CvQqNV8
02ra7JdHORyu7KCXNtsA8zi2zW4GTA54FvFFPqHDMaUy07OAEjtX37RYwR5VsOin
e9OlWU9h8CaBxHAWVp260degWEXZkT1MIKERdHS9lxJhtKqGTqv0LHXlA9W+OI/O
37ZtjT9NgPcynKjEL93EMdSHUlEO5/iROHp9YrjK32IBQKHxzr9kvALJ9NFAf2uR
KCNaU/k/YSD7gJfUDB2i
=+Aqw
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jan_2014_14_26_27_+1100_Dfl7rtkbotIs5xjd--
