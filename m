Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495AbaIIKzq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:55:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:44233 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200AbaIIKzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:55:44 -0400
Date: Tue, 9 Sep 2014 12:55:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 09/22] perf: Support overwrite mode for AUX area
Message-ID: <20140909105537.GJ6758@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-10-git-send-email-alexander.shishkin@linux.intel.com>
 <20140909084436.GY19379@twins.programming.kicks-ass.net>
 <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RlE8T3bLnVJqgX61"
Content-Disposition: inline
In-Reply-To: <87y4ttt9m0.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RlE8T3bLnVJqgX61
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 12:40:39PM +0300, Alexander Shishkin wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> > On Wed, Aug 20, 2014 at 03:36:06PM +0300, Alexander Shishkin wrote:
> >
> >> diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
> >> index 925f369947..5006caba63 100644
> >> --- a/kernel/events/ring_buffer.c
> >> +++ b/kernel/events/ring_buffer.c
> >
> >> @@ -294,9 +295,22 @@ void perf_aux_output_end(struct perf_output_handl=
e *handle, unsigned long size,
> >>  			 bool truncated)
> >>  {
> >>  	struct ring_buffer *rb =3D handle->rb;
> >> +	unsigned long aux_head;
> >> =20
> >> +	aux_head =3D local_read(&rb->aux_head);
> >> +
> >> +	if (rb->aux_overwrite) {
> >> +		local_set(&rb->aux_head, size);
> >> +
> >> +		/*
> >> +		 * Send a RECORD_AUX with size=3D=3D0 to communicate aux_head
> >> +		 * of this snapshot to userspace
> >> +		 */
> >> +		perf_event_aux_event(handle->event, size, 0, truncated);
> >
> > Humm.. why not write a 'normal' AUX record?
>=20
> In this mode, the hardware is running in a circular buffer mode,
> overwriting old data, so we don't actually know the size of the
> snapshot, we have userspace figure it out later on (based on timestamps,
> for example). I didn't want to configure PMI for this mode to avoid
> overhead, but with PMI we can try to keep track of the overwrites and
> try to infer the actual snapshot size in the kernel. For Intel PT. As
> far as I can tell, ARM's scatter-gather trace-to-memory storing block
> does not generate interrupts at all.

Well, wouldn't the 'size' be basically the entire buffer. All you have
to then provide is the head pointer. Ideally you would also provide a
tail pointer so you know when to stop, but I suppose you can infer that
=66rom the data stream itself? If you can provide the tail you can indeed
compute the size etc.. at which point you don't have to rely on parsing
the stream etc.



--RlE8T3bLnVJqgX61
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDtypAAoJEHZH4aRLwOS6++oP/iWS+sdlGqY2WL9wt7wXp0NW
NJ6AgTpI9knf0QVhCFBrd+OZKFY1RRqViTxWT/RRO8PTb6o87iGxB83yxMSllzUQ
TkOiAHLlp/pn7S4dNztMZJpvwBNQNw8dSehXl5C8CXSXktdBhuEiIKomfIEydDZf
84Q1I2Q09eujEStlLg4zMPQp6ofCoaZaWiWOj/eefSMkKvSPi0O6T05ISNgo/roE
HJGrq/xqkz6SI3baAvCaSzL5qkdLQixMdign7yWHcWBM2dMWOc+KSJ+I8pNHnYoy
AraHCer52pHZZ7R9DNy8BL53xTwsT6W1haCUeXnJwp3zkjnCyOaBLlC/K2TDIv3e
KJ9ZSJwVi3ZqRhKjMR8tZQPTQm9n+IMC6dw3YracwGnjb6brgzgLd0Fk+lefPg5F
TjBST/mjBwRLItEgSZPWJyC5SpaZae1jxDgNa7gcORC4tTiA3Suc26DRFb5om9Mz
7UARwIkXdDT2WtkSbb+A7RUjRkhq6Vt91WOCmXQLHKo9ysUsh7Xbi6+aZ1pGqg2X
n+ZDpeZparxkjsHzZD2EYSS8OQZ32+ql27QaCN2Zp0E4lDp/VcCUStz/bWKfsSWX
cr8QBrsLqjUbrXfOzcKjh3NM9Vr0MhNjb410j0LI/RDlwI1mireLlvxbFtkxh2e0
cxER+iqtufs2vlxBKD31
=23+i
-----END PGP SIGNATURE-----

--RlE8T3bLnVJqgX61--
