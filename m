Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3ARP4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:56:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:20228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3ARP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:56:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,493,1355126400"; 
   d="asc'?scan'208";a="249085744"
Date: Fri, 18 Jan 2013 17:57:25 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: PAGE_CACHE_SIZE vs. PAGE_SIZE
Message-ID: <20130118155724.GA8507@otc-wbsnb-06>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

PAGE_CACHE_* macros were introduced long time ago in hope to implement
page cache with larger chunks than one page in future.

In fact it was never done.

Some code paths assume PAGE_CACHE_SIZE <=3D PAGE_SIZE. E.g. we use
zero_user_segments() to clear stale parts of page on cache filling, but
the function is implemented only for individual small page.

It's unlikely that global switch to PAGE_CACHE_SIZE > PAGE_SIZE will never
happen since it will affect to much code at once.

I think support of larger chunks in page cache can be in implemented in
some form of THP with per-fs enabling.

Is it time to get rid of PAGE_CACHE_* macros?
I can prepare patchset if it's okay.

--=20
 Kirill A. Shutemov

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ+XDkAAoJEAd+omnVudOMzKgP/2i22lky6JJInM7MxXkJFZ1l
/pksssQ6hdHdb+B0QCBjoUDw/ZAUessm0/aDrBwjTmfAGoUbnIWQZf90Hf/ybNV8
e5gh8n73XXVr7irhUJB/7jJPOfMMdU2yw0g3cfr6MC9bzvzt9V8dWmyGnIvUPthG
ZKtwH/Aj2VqkVg7My+Kucy+bM/VT3XwPtVG7CMbk1wpW9TkRWxVBbfQZdxuGHAzC
5dyagwKYltpc9N6zb0WUwmE3HFT1LEKDGdzA3Re20rZSgTcWY2hrrHQQARDVLfyc
SWPaqhXDuKPh9iWn75yJPwvPXv+x/ME6wnh43k8wzX5dSXorohDARO1+Csc+3IJb
tk/sDJK85198Hnpkg0IZE+rfSc+Y18Yy+cYch4nuTYn1BwLWNE6B/2ZaVc/vSbU/
lGD6HLCOtH9sOx/nQ+oopj0swcPXKsGxTV/lfqazPEeASmdVTA2XS99ArFl/Mp71
qTvYgxlp4Nn8+3CgvMwHZQUbW02Xo5RFd9SdaPyhF0kXmbWhnpxFk5N9Hsy70xG4
o7/f6psrC4XkSN8DlHw/2hT32OSrgmnFmttg8L6mcYN6E6cQY8/pJI2WDIGcq8uN
vf8/PzVT/A/NySXrQQkCZNtYmhEW1f/k+NtBJHHuY1nr7qky+uKUM0GJmppW310k
VvAC0r7ef7e8jEFAq43y
=YqYo
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
