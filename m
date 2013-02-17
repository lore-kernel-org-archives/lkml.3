Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3BQNmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 08:42:55 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36159 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab3BQNmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 08:42:53 -0500
Date: Sun, 17 Feb 2013 14:42:48 +0100
From: Jann Horn <jannhorn@googlemail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] posix timers: Add syscall that works on timer
 sigevent
Message-ID: <20130217134248.GD13378@debjann.fritz.box>
References: <511D0E50.7090505@parallels.com>
 <511D0EA1.9060704@parallels.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
Content-Disposition: inline
In-Reply-To: <511D0EA1.9060704@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 14, 2013 at 08:19:45PM +0400, Pavel Emelyanov wrote:
> +	struct sigevent event;
[...]
> +	event.sigev_notify = timer->it_sigev_notify;
> +	event.sigev_signo = timer->sigq->info.si_signo;
> +	event.sigev_value = timer->sigq->info.si_value;
> +	event.sigev_notify_thread_id = pid_vnr(timer->it_pid);
[...]
> +	if (old_event && copy_to_user(old_event, &event, sizeof(event)))

Won't this leak uninitialized kernel stack data to userspace? As far as I can
see, the _sigev_un union is bigger than the _tid field in it, so the rest of
it will be copied over without initialization, right?

Jann

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIN5XAAoJEGhmizV0f2d1omkP/3aYg8NWXKJAywJymFPipKyq
PyhAhup8mGOnurcQuX84rmQP51P9wzXC1nOotfspkGvvougk1NGHX6Ns/t84qDhE
711xvW28OmJjNyQ+YZyPXwVKMu8cXPmy+yUI42c7zW78MxHdSk50Qf9OeBgTsjcw
RJs6D6jH7+F5uNKa0UxPKPh5Ji1TBTeJzolBIdfzy8OYA6vJ6/GtrpnotDBrDtaR
o2bOpmOADLI9Q48fg9SPy7jAEfS2Z8ULg0vwBixqFC/7+RIUOj1hgro0UgiIdpnT
6/vA9GXotjzDFfl9V7NE0ohLFeDvuirjkhkDmICpS4o5YosigsWYzXbKJ44dw9XP
R/H3lUBfkppS5dik1jmSIIRHWB+wNMLcy+CYqqcQc85BZ0mGchxpGAlzvQb4jMsa
vwXj9KXTcnmGqKkkApdZVtNk1elpd+g408xy1o9ouwuT6XQxHbpshEjBg1WFXh00
lhpCAqkbHfjtCV6gMZhhw34G0TKOfKXOQ5z2XqruOl5XSkjhTTdvZ/PnIzKVve/F
8xNdvCORRQJXmnDrcJePQiyIVv/g68lI2YbwR/pFbR9iGzeBCdg+TkgA+Z5aJrSU
lkpf8lKsssGNuMKiAtV2oUWO572Me4jJeEZzYMOBMtuxXfd0vObXt4BKj1OiE8Ny
mVnRFz9Hy401I5VyIAAm
=6AOp
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
