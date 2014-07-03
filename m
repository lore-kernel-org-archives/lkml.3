Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaGCHcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:32:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:36267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbaGCHb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:31:59 -0400
Date: Thu, 3 Jul 2014 09:31:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, Waiman.Long@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, hpa@zytor.com, andi@firstfloor.org,
        James.Bottomley@hansenpartnership.com, rostedt@goodmis.org,
        tim.c.chen@linux.intel.com, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Cancellable MCS spinlock rework
Message-ID: <20140703073148.GT19379@twins.programming.kicks-ass.net>
References: <1404318070-2856-1-git-send-email-jason.low2@hp.com>
 <20140702162749.GP19379@twins.programming.kicks-ass.net>
 <1404320356.3170.12.camel@j-VirtualBox>
 <20140702172333.GQ19379@twins.programming.kicks-ass.net>
 <1404322203.3170.17.camel@j-VirtualBox>
 <1404362358.8764.6.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a+0P3INHs7aeI7wh"
Content-Disposition: inline
In-Reply-To: <1404362358.8764.6.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a+0P3INHs7aeI7wh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 09:39:18PM -0700, Jason Low wrote:
> And due to padding, the additional modification below reduces the
> size of struct rw_semaphore by 64 bits on my machine  :)
>=20
>=20
>  struct rw_semaphore {
>  	long count;
> -	raw_spinlock_t wait_lock;
>  	struct list_head wait_list;
> +	raw_spinlock_t wait_lock;
>  #ifdef CONFIG_SMP
> +	struct optimistic_spin_tail osq; /* spinner MCS lock */
>  	/*
>  	 * Write owner. Used as a speculative check to see
>  	 * if the owner is running on the cpu.
>  	 */
>  	struct task_struct *owner;
> -	struct optimistic_spin_tail osq; /* spinner MCS lock */
>  #endif
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>  	struct lockdep_map	dep_map;
>=20

Right, that might make sense.

--a+0P3INHs7aeI7wh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtQbkAAoJEHZH4aRLwOS6qs4P/i7JeWnipGu4SMYsMH00LW/a
EPpgosbOfiEXLvmPTABKjSlXFcr6/RQzvA8P+/3PCiDx9luqpHirlbPOGjKH30pe
0MRIv1M5aVOJkdMcUFO+G1ZETTPn6odhl/qS/RuH0+R/Uf7NujbYaSgjlLgfR1R9
vMLUVzHBI4/ubOB/UHYkpJV8rLEMrjmqd2wnDj41EFF8h66LhQkJmRp40aL8SZ3g
UvLEcYDLGWZc5pC/84BV8NAZbmadJC/lC1gAID/4G7a2O8rQrD0ZEfHYTB4e0j0O
n5KGJizJD9KlTdoQw5MdXqtHrA+kzTgllAEH3N46dmimfDWgcLrxlADkeBKBdhwZ
okG3GAoatVqsdROJmH/7/HzJGgtOKCqpm/x7LS+vKebli+jxcyzMclqgfrtVypVR
xhnkv0aM2KsThb4T+ayStXxcnADWRW9eDCDbMYMCFtDOtqGC059WACcosJV0kxiV
qpPlxzU4K2PPqTG6WiUfIfgW+cWHVD56XBIlz+XuqiSeykWdmgfL2REOb43UFXjF
Z7aEPuXdgjZY45ekBXEalOU4vUyOGLvxLjj3WeDMW0pWkW6aYjEG+u/WoIoIv1FG
3VXcY/XF2XoCBtI6fF/+/VneMSoxwjieQ3JhMcdT/CRTLg08eIhfjwZyCsa/SktT
Th+8IBsE1VJycrzBt0ov
=EUv8
-----END PGP SIGNATURE-----

--a+0P3INHs7aeI7wh--
