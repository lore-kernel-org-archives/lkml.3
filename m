Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaFJTps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:45:48 -0400
Received: from sauhun.de ([89.238.76.85]:37868 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbaFJTpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:45:45 -0400
Date: Tue, 10 Jun 2014 21:45:11 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
Message-ID: <20140610194511.GC3122@katana>
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com>
 <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HG+GLK89HZ1zG0kk"
Content-Disposition: inline
In-Reply-To: <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HG+GLK89HZ1zG0kk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

compiling this driver gives me:

drivers/i2c/busses/i2c-sun6i-p2wi.c: In function 'p2wi_probe':
drivers/i2c/busses/i2c-sun6i-p2wi.c:272:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
drivers/i2c/busses/i2c-sun6i-p2wi.c:272:13: warning: assignment makes pointer from integer without a cast [enabled by default]

> diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c-sun6i-p2wi.c
> new file mode 100644
> index 0000000..4f7b93f
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
> @@ -0,0 +1,356 @@
> +/*
> + * P2WI (Push-Pull Two Wire Interface) bus driver.
> + *
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2.  This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + *
> + * The P2WI controller looks like an SMBus controller which only supports byte
> + * data transfers. But, it differs from standard SMBus protocol on several
> + * aspects:
> + * - it supports only one slave device, and thus drop the address field
> + * - it adds a parity bit every 8bits of data
> + * - only one read access is required to read a byte (instead of a write
> + *   followed by a read access in standard SMBus protocol)
> + * - there's no Ack bit after each byte transfer
> + *
> + * This means this bus cannot be used to interface with standard SMBus
> + * devices (the only known device to support this interface is the AXP221
> + * PMIC).
> + *
> + */
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>

Unneeded. Please check other includes, too.

> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/reset.h>
> +

...

> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	p2wi->regs = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(p2wi->regs)) {
> +		ret = PTR_ERR(p2wi->regs);
> +		return ret;
> +	}

return PTR_ERR(...)?

> +
> +	snprintf(p2wi->adapter.name, sizeof(p2wi->adapter.name), pdev->name);
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(dev, "failed to retrieve irq: %d\n", ret);
> +		return irq;
> +	}
> +
> +	p2wi->clk = devm_clk_get(dev, NULL);
> +	if (IS_ERR(p2wi->clk)) {
> +		ret = PTR_ERR(p2wi->clk);
> +		dev_err(dev, "failed to retrieve clk: %d\n",
> +			ret);

dangling ret.

> +		return ret;
> +	}
> +

...

> +MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
> +MODULE_DESCRIPTION("Allwinner P2WI driver");
> +MODULE_LICENSE("GPL");

"GPL v2"

Thanks,

   Wolfram

--HG+GLK89HZ1zG0kk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTl2BHAAoJEBQN5MwUoCm2wtkP/3+cULS3I7KVt7Ey5jylyXg5
jMRr8tOzYmwVpX1qGvNxPZJSgwd+8pVDJ8T4Biwx1CAumbisFopxSV7m3yoGM2gt
yFPE7qs4DlOlLTrua6p/hafBoTiyGCQhHJKojYd0zDetKuqij9QrtgUsQQr+cwu4
LxjVUyXKOte6dRBCLCU29pWzQKSZpQ+knHdpZeNKPkGoiVZn0MK1mWhp1R9uwxxI
oXo1cuB14qeN5QD2rzvIGK3xwYqR+WZBJZq9JVLxdvCvylYD5x+P7cIka0/nSGQy
HowkB8ax3kDsxN13mFAcp/hxxnfZAbvmW7WF+ZaM13+4FQ6Bo7UKTB6AdkkcewN5
jhbecPAtZNkJw+UK42QD545JOUDX7Rdy6FqWawrImckwfx99uB2v2lLa07RnoTkg
DWOjV8/lRSuuFriu9kqhA7p8KFSboh8gnLWnYnqcoRKHYQ/WzebqUrPahZvim45X
HwGBXH2S1KxOCMNGO0OsgOV7K3OsbHe24Eb+dkHSinsVuiiIKwiQ12jdavaF1L+Q
qLdzROYlEMzohWRybz2KZ6xujeNxB7CDLhWoCCTIv2oKgHY4ipBnesiHeNFm7t68
VtbTMtpGaW1VrnaTWbesiXytpiokVw7fkro1mACRO/UgIkaGeIjWKbKnX0ATRu6u
al39h7tQ8m28fefG6Qki
=5ZK7
-----END PGP SIGNATURE-----

--HG+GLK89HZ1zG0kk--
