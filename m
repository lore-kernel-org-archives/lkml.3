Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaDNSnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:43:41 -0400
Received: from home.keithp.com ([63.227.221.253]:42978 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaDNSnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:43:40 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 14:43:40 EDT
From: Keith Packard <keithp@keithp.com>
To: Steven Noonan <steven@uplinklabs.net>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: REGRESSION 3.14 i915 warning & mouse cursor vanishing
In-Reply-To: <20140414164010.GA1019@falcon>
References: <20140414164010.GA1019@falcon>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 14 Apr 2014 11:35:05 -0700
Message-ID: <867g6ryd2e.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Steven Noonan <steven@uplinklabs.net> writes:

> Was using my machine normally, then my mouse cursor vanished. After switc=
hing
> to a VT and back to X11, my cursor came back. But I did notice a nasty tr=
ace in
> dmesg (below).

I don't think the trace below is related to the cursor disappearing.

I found a pair of bugs (one in the intel driver, one in the X server)
which can cause cursor disappearances. I just sent an intel driver patch
to the intel-gfx list with the subject:

        [PATCH] load_cursor_argb is supposed to return a Bool, not void

I've posted the X server patch once, and will respond to some review
comments. Either is sufficient to get a cursor back, the intel driver
one means you get a working hardware cursor again, rather than using a
software cursor by mistake.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBU0wqWdsiGmkAAAARAQgksw//STLtx9MaoAyKFelY1bfgnC4ZyAYeY4IF
dnWcRttzqSay16NtyyP0fYEDr7GdV1OQqgWHmQcqAgmO5C0nY5HaFobG2n7r6+B9
zzdC7MYwgDheUiRb/5uZxm/L6joCdk/H1bvBBdWdNfGTvQ1DY5fmV58mobe72Yv6
TZfSujFQ0WKYWmBedsrs0JJPLyG5E7QQJY2PhZg6V4mgdocK+o1hgfrW/6MMjkpY
VTNFr0bKOquZjHz8/wHofHluMm+QU4Ryyu1oyk0cbfhBCHcDcsCs/QMvSvmE9WbV
Q7SfnvZr8ZYKJqyvYxbHpIYmW9XqtQ9lQKPWnMHxbnntq9kZThimUswNy5Cc+NwU
VSquOTULGkcqPtueFJEyHN+WZReF/3Bqjgfeflh0gz/lm2IAAhEBPHzKqKb7xLyF
0xrcubQwcDI+W+aj5fo7HzwU+QL8cUnkPO3vX299jSH1bd2QeEPUtGpqZcVKff1b
sNDMYFytJOK935deuIfCQ3t2MR28/G8KG41E2IH5m8ii/NrYEphQTaqZYXoQIr/B
1G0YprgsrWASI3k+NfpExgwQQFBDKDS9BX3+7LOfAKdkRzXsh74SAEAyOI6ymfqt
nNHiBhuSZU3tCvFn3IdvVNJ3jU9NqrB7T3Ijoxvk0aPMW0Cdv9OwNlcM8NxEeun5
u4lkloR7tK0=
=uirL
-----END PGP SIGNATURE-----
--=-=-=--
