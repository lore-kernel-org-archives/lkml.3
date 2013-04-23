Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab3DWHRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:17:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58326 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3DWHRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:17:17 -0400
Date: Tue, 23 Apr 2013 17:17:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20130423171701.00996503300c975a39ccea63@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Apr_2013_17_17_01_+1000_GiRRvw639wSzD5JG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Apr_2013_17_17_01_+1000_GiRRvw639wSzD5JG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
kernel/posix-cpu-timers.c between commits a85721601ad2 ("posix_timers:
Kick full dynticks CPUs when a posix cpu timer is armed") and
555347f6c080 ("posix_timers: New API to prevent from stopping the tick
when timers are running") from the tip tree and commit "posix_cpu_timer:
consolidate expiry time type" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/posix-cpu-timers.c
index 84d5cb3,e5286b5..0000000
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@@ -155,22 -106,7 +108,22 @@@ static void bump_cpu_timer(struct k_iti
  	}
  }
 =20
 +/**
 + * task_cputime_zero - Check a task_cputime struct for all zero fields.
 + *
 + * @cputime:	The struct to compare.
 + *
 + * Checks @cputime to see if all fields are zero.  Returns true if all fi=
elds
 + * are zero, false if any field is nonzero.
 + */
 +static inline int task_cputime_zero(const struct task_cputime *cputime)
 +{
 +	if (!cputime->utime && !cputime->stime && !cputime->sum_exec_runtime)
 +		return 1;
 +	return 0;
 +}
 +
- static inline cputime_t prof_ticks(struct task_struct *p)
+ static inline unsigned long long prof_ticks(struct task_struct *p)
  {
  	cputime_t utime, stime;
 =20
@@@ -1408,8 -1312,8 +1354,8 @@@ void set_process_cpu_timer(struct task_
  		}
 =20
  		if (!*newval)
 -			return;
 +			goto out;
- 		*newval +=3D now.cpu;
+ 		*newval +=3D now;
  	}
 =20
  	/*

--Signature=_Tue__23_Apr_2013_17_17_01_+1000_GiRRvw639wSzD5JG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRdjVtAAoJEECxmPOUX5FE5FEP/jS+Xr+XgteKoaB9o8Sz0lrC
bm/y2jdjIUYPwMS4wt6aHZJAcFD7gBeHnCaGCOP7UGhWkW9zbkqUXrCbxXAiMTSI
jBifn7AZ7wlpvHTia/R/w38Uk+IpLWewmqyavMt3qdMCd/YXnjE2rIeOuf9WE7YB
F4dXtL9FmGtA4RtFP0kECVGcJ/tXIt7nGCVtgXG1IQkw1QLaNEV+8dzQTYhyY7er
tEi7VUJKihoOXZUDmb5JgSm1FfHuLPXrfDXk0dvIWSeWUkTasy0CTmBHHiAtgUkY
VS355o/l5YmfncRcl7bXOzjOPJ+neW8h0sSLDL2AtTcmGUhR0yTgvmrfFXVv/tfS
L3YfnqWs/uxkrZX4ntsQfelYoznKxOzkpefmB1EWmPrLmpY4dIzXOug6/vDpn26m
ARHb2hfq45hOebTcaib0qGg+ZDYavyWUMxvD+KAKqHZ1BqpYuBsPPwZoXPaoALro
UrzY/O3bONepLE5HgRaCvbP385RSj8HP5A2zWgPn1KZdURR8ojlCg7VNkCNXuGWM
CVGMzWfV+Cffjyk/5dW9Es4ImwHI7QK1QspYUI09bXidgbaXHJqXNO/BRtLQkOae
Os5G4ncidtKAP64BxmEgu1qfXgiJB3iWjImCOzdHGXSsMvKBoVFBSYgzMeC9PHUN
sYauyL2KY6yPM+vNeeBg
=wv1+
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Apr_2013_17_17_01_+1000_GiRRvw639wSzD5JG--
