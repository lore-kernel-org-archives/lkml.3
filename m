Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaFLHhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:37:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58030 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:37:23 -0400
Date: Thu, 12 Jun 2014 09:37:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: acme@kernel.org, mingo@redhat.com, paulus@samba.org, hpa@zytor.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        matt@console-pimps.org
Subject: Re: [PATCH] perf/x86/intel: ignore CondChgd bit to avoid false NMI
 handling
Message-ID: <20140612073716.GR6758@twins.programming.kicks-ass.net>
References: <20140611073028.9847.65622.stgit@localhost6.localdomain6>
 <20140611085448.GI3213@twins.programming.kicks-ass.net>
 <20140611115413.GE3588@twins.programming.kicks-ass.net>
 <20140612.160011.167980216.d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q6K/XF9FZiHksLwH"
Content-Disposition: inline
In-Reply-To: <20140612.160011.167980216.d.hatayama@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q6K/XF9FZiHksLwH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2014 at 04:00:11PM +0900, HATAYAMA Daisuke wrote:
> Also, I checked cpuid on the system with Neharlem processor where I
> have never seen CondChg bit is set.
>=20
> [root@localhost ~]# ./cpuid -r
> CPU 0:
>    0x00000000 0x00: eax=3D0x0000000b ebx=3D0x756e6547 ecx=3D0x6c65746e ed=
x=3D0x49656e69
>    0x00000001 0x00: eax=3D0x000206e6 ebx=3D0x40200800 ecx=3D0x00bce3bd ed=
x=3D0xbfebfbff
> <snip>
>    0x0000000a 0x00: eax=3D0x07300403 ebx=3D0x00000044 ecx=3D0x00000000 ed=
x=3D0x00000603
>                     ^^^^^^^^^^^^^^
> So, cpuid tells that CondChg bit is supported on this processor, too.

Yeah, I can't remember ever seeing that bit on nhm/wsm either. Weird
stuff that.

> > In any case, the proposed patch seems fine, just needs a better
> > changelog.
> >=20
>=20
> I see.
>=20
> I'll write that the problem is that any NMI could be robbed by NMI
> watchdog explicitly. Now only patch title says this explicitly. This
> is your first comment.

Yeah, since that is the actual problem, its good to be clear on that.

> About CondChgd bit, I cannot write more than I see on actual
> system. If it's necessary to describe more about CondChgd bit, it
> would be appreciated if someone tell me more information about it.

I think we've found all 2 sentences the SDM has about that and unless
someone from Intel is going to come and explain why they wasted precious
silicon on this I suppose it will remain a mystery. No need to update on
that.

--Q6K/XF9FZiHksLwH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmVisAAoJEHZH4aRLwOS6dsUP/0T1ajDJFlu3LEz1wHvDk2+Z
CJ8LIq6AMftZ+FFw6nXZni7xclaRRZ9vu0AT7QkEAmzNygxkVkVLili4f4QFahxM
Di7i9jv1sWE6VmbU04EJnXitLSaLzn93yy227bcdvnndfwSLOuD9dZH7eQ/kdnFU
KyNyh3yMXYBF0hw1e6bLZDIQxP08Q6bxjXokhSnvp3peYA4CuOabQfbbzn3ZE7sO
s62YoB7+kVwCxxwuvio8XgwXw8zbMasvA8pnc6wiCOs1uaa2As+skV2T/52s7ivC
8Glu7R4j2qU5e6p9or6Ug/zv2GgTPqq/h3ym/1pztbI2Dp0sUWsGcR93nCVk0HtK
r51300EwLXO7pmwRcC7hJCQQx1rnLTS8nwCmqJfJviTES0lSHYKhZsGUwuuN+Utr
9XMIATrrJcBdTzBJgTxRS9GEZtbVdHnVFHqRUVpr8g3RSk0AtI2uHgUxACg+hlFH
I7CAeq/KQRp2mcuJzQBfFYpSin+df4CycKZZlcIGvauOxkda2N9KyrL4CyLElSB3
A7SCdzOkWiWzpC7WZzcwEhbdKRCJxnOWlmAKdmFZZZgehPGEejbKLzx+wI17wyBQ
b5dEv6Lqsn2SwICtjJ02lgSURRKtoHHVY5Txtnx8yNbvlIxPrlUxkXRYQpQLYUd+
/c0X3TUTnYgVxp2K8sw/
=D0/9
-----END PGP SIGNATURE-----

--Q6K/XF9FZiHksLwH--
