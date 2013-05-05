Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3EEO2H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 10:28:07 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:33882 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3EEO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 10:28:06 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 May 2013 10:28:06 EDT
Date: Sun, 5 May 2013 16:19:48 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] single_open() leak fixes
Message-ID: <20130505141948.GA30243@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20130505055414.GJ25399@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20130505055414.GJ25399@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2013-05-05 Sunday at 06:54 +0100 Al Viro wrote:
> 	A bunch of fixes for a moderately common class of bugs: file with
> single_open() done by its ->open() and seq_release as its ->release().
> That leaks; fortunately, it's not _too_ common (either people manage to
> RTFM that says "When using single_open(), the programmer should use
> single_release() instead of seq_release() in the file_operations structure
> to avoid a memory leak", or they just copy a correct instance), but grepp=
ing
> through the tree has caught quite a pile.  All of that is, AFAICS, -stable
> fodder, for as far as the patches apply.  =E2=80=A6 =E2=80=A6

Some 40 memory leaks plugged at once =E2=80=A6 quite elegant :)

Additionally maybe your cunning grep commands are checkpatch.pl fodder?
At patch level risk of false warnings probably would be lower than at C cod=
e=20
level.

--=20
Regards
Roland Eggner

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlGGaoQACgkQdN/hKfT7G/IO3gCcCJPJn+xO6RjKLXLjAgpIzz5R
az8AoK87K2oSdVd5dowdEe8vh1ytZSFP
=WfNc
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
