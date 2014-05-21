Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaEUJ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:29:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:38859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaEUJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:29:42 -0400
Date: Wed, 21 May 2014 11:29:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] ptrace: task_clear_jobctl_trapping()->wake_up_bit()
 needs mb()
Message-ID: <20140521092932.GH30445@twins.programming.kicks-ass.net>
References: <1399974350-11089-1-git-send-email-mgorman@suse.de>
 <1399974350-11089-20-git-send-email-mgorman@suse.de>
 <20140513125313.GR23991@suse.de>
 <20140513141748.GD2485@laptop.programming.kicks-ass.net>
 <20140514161152.GA2615@redhat.com>
 <20140514161755.GQ30445@twins.programming.kicks-ass.net>
 <20140516135116.GA19210@redhat.com>
 <20140516135137.GB19210@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N/xU+6Hp+kBwyaPu"
Content-Disposition: inline
In-Reply-To: <20140516135137.GB19210@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N/xU+6Hp+kBwyaPu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 03:51:37PM +0200, Oleg Nesterov wrote:
> __wake_up_bit() checks waitqueue_active() and thus the caller needs
> mb() as wake_up_bit() documents, fix task_clear_jobctl_trapping().
>=20
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Seeing how you are one of the ptrace maintainers, how do you want this
routed? Does Andrew pick this up, do I stuff it somewhere?

> ---
>  kernel/signal.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/kernel/signal.c b/kernel/signal.c
> index c2a8542..f4c4119 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -277,6 +277,7 @@ void task_clear_jobctl_trapping(struct task_struct *t=
ask)
>  {
>  	if (unlikely(task->jobctl & JOBCTL_TRAPPING)) {
>  		task->jobctl &=3D ~JOBCTL_TRAPPING;
> +		smp_mb();	/* advised by wake_up_bit() */
>  		wake_up_bit(&task->jobctl, JOBCTL_TRAPPING_BIT);
>  	}
>  }
> --=20
> 1.5.5.1
>=20
>=20

--N/xU+6Hp+kBwyaPu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfHH8AAoJEHZH4aRLwOS6b/wQALZkfgxJ4sPJJVf0xH/Kht5b
DQZDZftR1C4MFxt8oSj86XFTIM4mF8A7iTD3ZJMTteDGnQJD/9yfAZnfwnLJvRff
yVRX/+MSpkHEzpLyHE1Be/7v9Tllc/Sc23R0jaYefpfDzwe0zwPq6ZrvV0s4BlM9
B+8k7CrHbZpCSP3B/xj1gJIsW2yS+3/a99fS/1SQcb/FVoFDNFYQJJGf5a30+hKg
9Vieg4HWLUVb+QOAfPEgkz+NyUgURHcVL6IWVNkOCsvFoHPGgHtom67ZczRFeD/0
zGrkTLC5bsg7qbIkRfeTP6NfmUkDBaDgnzaomkAkYIXQv/385qNj8vgcpGPQFrds
COWalwk1lhxGMOFRRIMwoYAYPhtgLhngKUZzPfzuNrLJj8xXDSQtVEKx+FfS3PfG
6ktwptdLcU1BDodvP4IGV3x1fMhusuRPcpHKyyqWerkufjYervt3iMntwA1UUuDy
HAw0I2zIRfH1hcXotjcu27OlcqC+PQZ4U2JkVcAp0QIZfhwdnN6mvm8sSbgscFjk
ZctrPcwW3QNHUEEKm77YxiZang3ZUfQ4n6LTHfIZ975L68zNu5XZEfwy7NNFEzXf
TH2OA6J5E6a1E5rSWwhCEjeOjYRobl3L4ISIxiNLZXuh+E8j+ku3J/YOX23RdcOe
IhSKOiKVG4y4pqhccpav
=A4Gu
-----END PGP SIGNATURE-----

--N/xU+6Hp+kBwyaPu--
