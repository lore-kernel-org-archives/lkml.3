Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab3A0H3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 02:29:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33346 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075Ab3A0H3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 02:29:50 -0500
Date: Sun, 27 Jan 2013 15:29:33 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Boot crashes due to global async pending list
Message-ID: <20130127072931.GA32135@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Booting current -next causes crashes during regulator_bulk_enable() in
the async code (the function uses an async domain to run multiple calls
to regulator_enable() in parallel, synchronising the domain to finish
them).  Reverting commit 9fdb04 (async: replace list of active domains
with global list of pending items) causes the problem to go away.

I've not got any sensible diagnostics at the minute, the crash was in
async_entry_function() in one of the list_del_init() calls suggesting a
locking issue but everything looks in order there.  Will try to
investigate properly when I get time, I appreciate that this isn't an
awesome bug report.  If there's any diagnostics that'd be helpful please
let me know.

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBNcyAAoJELSic+t+oim9ja0P/iwXYIZGYIJVexsRyJEDVS6o
4RzM634Zo0Lns7IHY8LAF2NaNitjV41m/nFp5UijtbcOcEOy3kBzl1rOr58GKXkK
hIbmpYc4nnhi3vwG4ZrXxUGNfv5o+DI1VHVfLc+j2CwJ0nW3QPBYQXRglBBKzgi/
iACybF4MrrVRqtW+OV7izyXmIG5kV7a4RA1cYP9gODfddO2xPMOvlHtxPtNqZT3u
Sthu//+5DzhDlH8Tfs8P8KZN8WKs7ax3irLKFE8F3ImDDy+KIEw6b07ifkdRbgir
+Q2Y2JCcUa5CCdDyHVf74iW3PpcjB9vzjPprEMAXxplWx1SR+GjpsVbNQCsy/7Pg
Aar/JvGq8yH9BGYl46QyId4pEjrVjrmUeQ2rq02q+3zauUeuTTyIergjnhZD5GqB
SqydYbmSW/Rx36ViRsPK5hszTfbWkP8riwNha+Hrv0PWTDDqsg5dYqb1N23Ccyp0
ELKN7w6V6B/BNX03DMGqunSPL4hMNjLoK6Pgft4bzUJaCz6Apbp0dNxnQ9o+oG81
Au5S1peXMwptlgQwJb5hF7ADqHZQPehUz2EaaAnrn34oQJxbWbc0xEvedkFPsZsu
kajQf1o423zsybhYZSqQJlSooVR4CnUkdUVDZt0aKOV42QSZ4v4/HFq0UQl4Mj3R
GYI3bQEdkaovGBxKqQjr
=MVop
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
