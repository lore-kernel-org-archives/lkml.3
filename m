Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaGGMua (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:50:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57738 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaGGMu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:50:28 -0400
Date: Mon, 7 Jul 2014 14:50:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH v5 0/2] lockdep: add support for queued rwlock
Message-ID: <20140707125012.GP6758@twins.programming.kicks-ass.net>
References: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vrcq/LprQzvw2eZB"
Content-Disposition: inline
In-Reply-To: <1403804351-405-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vrcq/LprQzvw2eZB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 26, 2014 at 01:39:09PM -0400, Waiman Long wrote:
> v4->v5:
>  - Add patch 2 to update the locking selftest code to handle recursive
>    read_lock correctly. Patch 1 has no change.

I removed all CONFIG_QUEUE_RWLOCK dependencies and made lockdep
unconditionally assume the stronger constraints.

Since we want all code 'clean' for the strongest possible
implementation, everybody should run with those semantics, it doesn't
make sense to have that configurable.

Eg. someone on (say ARM, which doesn't -- yet -- have QUEUE_RWLOCK)
could unwittingly introduce faulty code.

--Vrcq/LprQzvw2eZB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTupeEAAoJEHZH4aRLwOS6hKQP/2H6lUxKHSUOtNxGQPX9cwQQ
3rrXspYRp0iE0Oae8Wg8jBxXahw3nJqZXCuxZLdC+YHv7Libt3etCEJD+aVhjRVi
mLeJ8BXu/08Xr/azYl0ZhNO/kNB6mA8PN/Y4/JlDOjimgCiCgB/OlzYmLWl9UquD
98gXT3Ai2j5DymGhvfLJ5KkZVfR7P9oovhpzypgORDDg1wXa/XPR9PgN3F4MNPtL
b9rZ7plLdg1k3MXoec3QKPj8vrdhzxEPSl5h9FU6z/zl8FidVAQBj5iE9jUQQ+bn
d/slHl2rlW7pD2XSGXKVjvcqDHry0Po9eMQMABHvsKioAKGyUvHWvCBhd8hL/RPS
5vh8/McOSae4JTFk/McBAxZsOax3PwKUTXlEVv9W8SRg+o6PbFxVd9gD5v96nWw7
5xC08FmoJVCEaX20tz2j99VkhZNG4ZAqZ2Z5xSnOSqtQ/yFoOeGKZBHhv/8Swilm
hn2rYBFt4g/8Wo+XFChXal9XzNV0lDHSTwCZF4imCVlMQKGk9GZ05Tskbu15QTJh
kGuwu/ISfvJrHxtXKdk1Fi9yfPwA0SQYyvtgjUIW3ClpdC8dl50UjgghK8PcBTKH
Gs3bKC2nJ2JoH7lvqk+LlzHe6Y1eFo3hml3684rTP2zVSCnhChvIMFOmS4D/Q5AH
ZtzA8G4TY+IOJCRMaERx
=+Axx
-----END PGP SIGNATURE-----

--Vrcq/LprQzvw2eZB--
