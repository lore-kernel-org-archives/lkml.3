Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3EZKMv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:12:51 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:57678 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3EZKMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:12:47 -0400
Date: Sun, 26 May 2013 12:12:44 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: airlied@linux.ie, linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
Message-ID: <20130526101243.GB1652@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K8nIJk4ghYZn606h"
Content-Disposition: inline
In-Reply-To: <1368791388-31441-3-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K8nIJk4ghYZn606h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 17, 2013 at 02:49:44PM +0300, Arto Merilainen wrote:
> Syncpoint wait returned EAGAIN if it was called with zero timeout.
> This patch modifies the function to return ETIMEDOUT.

This description is a bit redundant, because it repeats in prose what
the code does. I'd rather see a description of why the change is
necessary.

Thinking about it, maybe it would be good to have two separate error
codes. Keeping -EAGAIN for the case where a zero timeout was passed
doesn't sound too bad to differentiate it from the case where a non-
zero timeout was passed and it actually timed out. What do you think?

Thierry

--K8nIJk4ghYZn606h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoeAbAAoJEN0jrNd/PrOhkaYQAKztP0yRn93EaycGhtSuAeRU
9Lg3QSQi4sDFcx8ZsYm7eFNg3QWkgrhFTK2cUzhemhrtfeerBVsCclKb8zf/mG/c
J0hgNhKYihzoJtRwwI4ODNs7revMXcXhWlAb4Yo1K8lIfC9cXtuabBKGQaFIcX8n
3L/1Snwb9fUcwJ2pPPRzdmR9KtcXJuZaPKjO44+YGWRhTeWVwlTDZLDZDsh0+3Bm
8JW7RUGh4is6AueFPDHGKEjfaSMRyj3vmloXPTMw3ao6+frZPtMLlVVFk3AZ8zqS
/fSkn1r/N2u0BbunY2doXNdEjm3gtR+0m39LdvyZAu+8+0IljgWFzm04XlmQZa7N
XSk5AxnqreUVZa+xc8Mq2Iwh5SdYiMMi4swoKIe3ZCvPVCMtBbQF/btgcSsRAQEd
BVQUbqtTlfWuMHkE9AkVI/n5YYQLmx8A/W0yN8Qn4qbEUvuPfnHHnuuDwLsANsHn
axXgDJhf7bNYyMTH6xIXgkxfWqkAQ/y/kXyl9ygYdDHv7GGNdftJPoFRceWTysbd
CzR7bvW67VB8tfDcQB1lzH2aowxn6AYbWw5b4wW52FESO9A/7epFf1JgCK12uYRg
yaIQ7DTihUu3ahHjsETiKGdvzgx1SPSFzi8vmeKRAjq14ENhmaBO3+v+kqcqWxn4
j4mCE6Yalj+FrSRJTxzd
=laJR
-----END PGP SIGNATURE-----

--K8nIJk4ghYZn606h--
