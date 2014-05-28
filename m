Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaE1RWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:22:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaE1RWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:22:49 -0400
Date: Wed, 28 May 2014 19:22:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [RFC][PATCH] tracing: Print nasty banner when trace_printk() is
 in use
Message-ID: <20140528172239.GX30445@twins.programming.kicks-ass.net>
References: <20140528131440.2283213c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6PH4sE4TNvTKzKhJ"
Content-Disposition: inline
In-Reply-To: <20140528131440.2283213c@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6PH4sE4TNvTKzKhJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 01:14:40PM -0400, Steven Rostedt wrote:
>=20
> trace_printk() is used to debug fast paths within the kernel. Places
> that gets called in any context (interrupt or NMI) or thousands of
> times a second. Something you do not want to do with a printk().
>=20
> In order to make it completely lockless as it needs a temporary buffer
> to handle some of the string formatting, a page is created per cpu for
> every context (four per cpu; normal, softirq, irq, NMI).
>=20
> Since trace_printk() should only be used for debugging purposes,
> there's no reason to waste memory on these buffers on a production
> system. That means, trace_printk() should never be used unless a
> developer is debugging their kernel. There's macro magic to allocate
> the buffers if trace_printk() is used anywhere in the kernel.
>=20
> To help enforce that trace_printk() isn't used outside of development,
> when it is used, a nasty banner is displayed on bootup (or when a module
> is loaded that uses trace_printk() and the kernel core does not).
>=20
> Here's the banner:
>=20
>  ****************************************
>  ** NOTICE NOTICE NOTICE NOTICE NOTICE **
>  ** trace_printk() being used.         **
>  ** Allocating extra memory for it     **
>  ****************************************
>=20
> Hmm, maybe I should add "Not for production use" to scare people even
> more?

Does that really stop people from doing stupid? Wouldn't it be better to
make sure nobody merges a trace_printk() user in mainline? You can set
up a commit hook and check for +.*trace_printk or so.

--6PH4sE4TNvTKzKhJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThhtfAAoJEHZH4aRLwOS6haIP+wfmP+jTl88GUoUr2AbbE1ht
wv4Fd4t1A2tGUyKHLTieryaLCmxvmx22nIbqnIm+c+ICXLxz6m009uw0dIZzsitR
fx2R1yGF5sJaZBKQUPbyHCsPLymVrFfHxLSdBRvwx5dZ85VUEX2aG2lRUJku2++G
qa9bFDuKF3kKLaX/ya7Ect0/N2HYlnTFV/TUhD3kLExsRSeDyMV9G3N6uKjC+I9n
T5YXGImn/5Yq/5mdSuvsCqToA4mpmw0MF7S1kxUOUQiZC0lu+S3kcXiY/D9qA6sZ
dv5JXtTXfz3in8/fqNhMvUjuBL77VscFCBKccCcpCMcPRapxc9OmMTgVy1HmsyhQ
TM1cWi3k0j/+D38iEGC1tXDNjrUaVn9vmEf3C9lj7vAvvpppuD9nRvSjswmXkwk0
CYo4hYH4SNBP8zIKepVN3kDMQYmXTyvJ6eOwC3kiUzp4M7a0TrVr3koF63mAuH9n
KV2KWx4wyxX4zP3GnsK8FTd1J3s4xmuQlZWXbQD/rpbKZC/6DW1qlNkSk7h0u7Kg
RBpuaOXHwr1afs/11jgv4fU0rZQ0zaThVtMgFtUXC4WYb5bb+gTW6117WYDCvA4+
zS2CrJJwLgcWsIOkDgO9WcLZvMLFYHj9e6Mn51601PHSkIpD2Y4NEPWtIMzu3v7k
udnouoetURKgu9VuWqfB
=MW/O
-----END PGP SIGNATURE-----

--6PH4sE4TNvTKzKhJ--
