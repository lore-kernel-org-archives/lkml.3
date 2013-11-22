Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab3KVDwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:52:21 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45816 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab3KVDwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:52:20 -0500
Date: Thu, 21 Nov 2013 21:51:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: Joel Fernandes <joelf@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <benoit.cousson@linaro.org>,
        <santosh.shilimkar@ti.com>, <jgchunter@gmail.com>, <rnayak@ti.com>,
        <balbi@ti.com>
Subject: Re: [PATCH 5/8] ARM: OMAP2+: timer: Introduce OF-friendly
 clocksource/clockevent system timers
Message-ID: <20131122035127.GA1417@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-6-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <1385085414-9034-6-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 21, 2013 at 07:56:51PM -0600, Joel Fernandes wrote:

[...]

> New functions for OF-only boot are introduced, and we can soon delete the=
 old
> versions once we migrate all platforms. Currently only AM335x is migrated=
 and

actually, you don't need to initialize .init_timer at all in DT boot.
Just use CLKSOURCE_OF_DECLARE() and pass your omap_generic_timer_init()
as argument (although, I'd call it omap_of_timer_init()).

That will put of_device_id structure on a special section
(__clksource_of_table) and pass your function as a data argument. That
function will be called automatically during init.

--=20
balbi

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSjtS/AAoJEIaOsuA1yqREKcYP/2GYbNpgOpiH/l8sQDIW5DEr
gzgopEW5qGhz6DQx1jPQe7F169WIvvz1mXQ7717OKFiOA0YQifxIcoTmdqXzcKAh
q3+gOrKb2m8t4D/4tHFH6FmjjwQIAzzJbNygMLV58qDWICrWPfQ2vxoJGKhw8OAR
/0hiCOyWk5CMBIyseHiENw3Wnj0dN/eHvcYY0W5Sm6FLT0El1pwRrzKK0MchpYW2
LmPv4FJH2KzkQSPolQp0FYVlKJ2f6IbPhzGusY9GQGOr00QDm2J+cH+WR9R2WMoh
ZD7xjcHSRs7MgRlockUykZ/zqc34F8XNiA3qZSjrrO9KAsw/ttF8tjPD7RCoz8yd
v2WbrFp/Wd2J+6CSoJ8nzAzCseWh/UuvZ4oF1RSHl9XFTIk7Stpwtk3VhxuQisgE
lTyzA4z7Xoq8zTCwVt7CVASJdthUb4mqr9p1xLbqmQS3/n1MeB1wm2VdH5KB8BEq
9vw8jqpT7ie26Vjf+vA328Up7rTkQlifAVwYvWF7w1ZAvDRgDXkqGVuIpHwj1BGc
iQshAE/4KTdtDnLyW5RmOg0pdqkYog3k30S0hK5hlbZHF/YUi0k9IrG2cW60KYqI
bi2Jxwe1op2FODBrFD6n5or1GgJlLB/fGCvPVy/WbHlBBd8EejydkK/+6Qb8QER7
lCHVOuB3Fx17QxQN6+aI
=0c5Q
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
