Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaBRTPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:15:19 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38494 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaBRTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:15:17 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Unkillable R-state process stuck in sendfile
In-Reply-To: Your message of "Mon, 17 Feb 2014 16:51:37 +0400."
             <530205D9.1010908@parallels.com>
From: Valdis.Kletnieks@vt.edu
References: <530205D9.1010908@parallels.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1392750827_2057P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 18 Feb 2014 14:13:47 -0500
Message-ID: <59184.1392750827@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1392750827_2057P
Content-Type: text/plain; charset=us-ascii

On Mon, 17 Feb 2014 16:51:37 +0400, Vladimir Davydov said:

>         out_fd = eventfd(0, 0);
>         if (out_fd < 0)
>                 err(1, "eventfd");
>         ret = sendfile64(out_fd, in_fd, NULL, SIZE);

> I'm not sure if this is actually bad and should be fixed, but perhaps
> it's worth making do_generic_file_read() check for fatal signals pending
> and break the read loop if so?

Why do we even allow an eventfd to be fed to sendfile64 at all? What
does that even *mean*?

--==_Exmh_1392750827_2057P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUwOw6wdmEQWDXROgAQJPHQ//fSAy2nyqJjEFTi9dTytDOwe6tkM3bYeh
4Ue+Wp93o2/qJtum3+AP49WYdA82lDNfGBzsgJAVlsTHN4a6zLMK6rfybgFKApHz
8VOPNsbXF3Tl0goHWm4IDTuJ67yXaWbcHbrKBpN3kZiF5C6oFgDhAlgruDT6pmLG
Ol6Dq6pln/E4HV0CQtnuKSwXpwLVxCUMiPhg8DuCNxmge7+nTEcaO+FOB661G6H9
Jaw/ilCKdOesMtv9T2WwNP6LXBfOGJqgYf+PzAdxTmuoeW+Jpluk4yss/nXFp5t3
8eJlJHFnKnI1YWT28mHMSGCeBLrb3YWt5lfM+atowIiPn8hG4QOmHkOEvUIgl4wG
dnv6BXcDniQwHEC/ES2K3oxIi2KTZ0NCEz7pIY+nEVw1JU4yrKchItRLXD66x75w
PFelYp2hzdvCE8jfLQTJJOfkBQygvH/XU+P/KeYbzMQKAa6O3M6zNiUzWKjx1FG9
eQLHpyQaKXO+ArVr4Wk6fUz2v5FrD2/q1+jZUTuG3hASgc2GWZfzZGtxVTZT/9ZX
q7BRsniKNzBbOoFSxmGXMkrfZ9ILpoJTsHCQALsSvarMCpYy5NLaC66YPK9lKGXQ
y7pgjztOAsTo290S61xhxQ7ILcFGcqmH9dRryTPvOzXEWeenO/H3vFGsd62a1zm8
SvHDTTmElqg=
=8lGY
-----END PGP SIGNATURE-----

--==_Exmh_1392750827_2057P--
