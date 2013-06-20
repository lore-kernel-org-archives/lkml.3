Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3FTHO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:14:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33579 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3FTHO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:14:57 -0400
Date: Thu, 20 Jun 2013 17:14:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Baruch Siach <baruch@tkos.co.il>
Subject: linux-next: manual merge of the arm-soc tree with the tip tree
Message-Id: <20130620171452.365bf173b71870c690d52e27@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_17_14_52_+1000__RzWCn5H2QvaK9Z7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_17_14_52_+1000__RzWCn5H2QvaK9Z7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/clocksource/dw_apb_timer_of.c between commits 0a0a7e66fa26
("clocksource: dw_apb: Remove unused header") and 38ff87f77af0
("sched_clock: Make ARM's sched_clock generic for all architectures")
from the tip tree and commit a8b447f2bbbb ("clocksource: dw_apb_timer_of:
add clock-handling") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/dw_apb_timer_of.c
index d9a1e8d,cef5544..0000000
--- a/drivers/clocksource/dw_apb_timer_of.c
+++ b/drivers/clocksource/dw_apb_timer_of.c
@@@ -20,8 -20,11 +20,9 @@@
  #include <linux/of.h>
  #include <linux/of_address.h>
  #include <linux/of_irq.h>
 +#include <linux/sched_clock.h>
+ #include <linux/clk.h>
 =20
 -#include <asm/mach/time.h>
 -#include <asm/sched_clock.h>
 -
  static void timer_get_base_and_rate(struct device_node *np,
  				    void __iomem **base, u32 *rate)
  {

--Signature=_Thu__20_Jun_2013_17_14_52_+1000__RzWCn5H2QvaK9Z7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwqvsAAoJEECxmPOUX5FEHcQP/Rhz488ZSwLQvftg+jDr1xPR
gWvG6wuKc4sH4+T5N5WZAB9axvdfNiUx2LlfbB4ClgLM+9b/d8lYSXs5JAP/e+HB
ZWFZQxXMvBsio20uCmIyeKo+YnplbsP9K737BlACelJFN4kWpuku4A1Df8e6aBd6
hvKxVRttg9ij88wuLU8lNGixlupzvgokxCZ81XhkbZhY+EmnUMw5+C6OP5XHCo8y
hWFed327qJM440Mrr81ZhntNSLAUrPev8HHXtiymwZpUR0zw4/hBNQx1E27NF+9Q
6FMY5UJjIOGnkquXKtsL63HMJz58CG+TXuiOucS3ygpPFN6XvbugL8CfHAzDz4OT
ZsfpR5GfAdZ4PmrHeSFAibCwcmNzp1lQxhZv/HkF2pCAmwOSKCMRe6Pm7oz8naHK
SR65VmxVL98yQmJpe4H85QOSwjBmXkkBrlgVAkIHX7STpRIDZq290yp5my9YR07a
UdFUGwEefX047aRhtHsWduzKO0s+JhxmMdPER1pdUxLHk8fCGqjQzVARYKaOUXHS
+fGZaON65ohm98J0N9xSnnjyLUKeitsJTZld/rNS8mwwed1QTfK6p/cQwas1gZXh
YiOZF3CFvJxPfrwQmo1yZSpyUs2ivJ7ZxXz0iDxLaWrv7tzEOadfWEZ97igP1eoW
qRInWLsFi805ZRYVko9O
=x30r
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_17_14_52_+1000__RzWCn5H2QvaK9Z7--
