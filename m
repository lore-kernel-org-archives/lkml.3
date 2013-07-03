Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab3GCF5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 01:57:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53237 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab3GCF5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 01:57:07 -0400
Date: Wed, 3 Jul 2013 15:56:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: linux-next: build warning after merge of the mfd tree
Message-Id: <20130703155655.9fbacfa867af35fd743099e2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Jul_2013_15_56_55_+1000_9WHoPgrGBJJrXYrn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jul_2013_15_56_55_+1000_9WHoPgrGBJJrXYrn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/mfd/ti_am335x_tscadc.c: In function 'ti_tscadc_probe':
drivers/mfd/ti_am335x_tscadc.c:95:27: warning: unused variable 'cur' [-Wunu=
sed-variable]
  const __be32            *cur;
                           ^
drivers/mfd/ti_am335x_tscadc.c:94:27: warning: unused variable 'prop' [-Wun=
used-variable]
  struct property         *prop;
                           ^

Introduced by commit 18926edebcb8 ("iio: ti_am335x_adc: Allow to specify
input line").  CONFIG_OF is not set in this build.

Maybe someone could come up with a way to make these arguments to
of_property_for_each_u32() etc look used in the !CONFIG_OF case.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Jul_2013_15_56_55_+1000_9WHoPgrGBJJrXYrn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR070rAAoJEECxmPOUX5FEgYEQAIgldsuIcLSrnm3Ruxeuc2tl
ohTiJxEh69pt74Xn/59XD3LhkC0Xc5UbIJigFUc5MrFoTmWrYRkdOTIHX9JuA/XW
0WM0w8ax0Py3WXJsBQnEH7NkWhbgmX4UNdy/1okLZ2DlSumjMgEv0GbqoiNTQChf
NO5HcdbJUnEwA59ZSus5D7ttKvWAJXX7IkWN8In29406dyZYKJX4CEochS+MdbRy
ZPSTtnIiu+/6stvwlITHgjRK1o4txUkT56WrfDdzaafS6XudXWMiDEA+OLYqYbBu
R3F/kIOrjEypeEq7YcaCHOa9mPldot741XHmreR2GuwhsXtM0tehXx7mkJcyrPkv
f2DIOavCAfuvuSjcq6BE13n/d4IV5mZSXc8+PWWdc3s7aAgzAJl/vDddzHDVnT9I
xw17mitUg5KNQldlfH+3j9MzfJoi6/Q4v2Y+GIMRr9zB5YtvDRWr4FDa1BoMbt6z
4iNVFb/hsQ1mYW8u1+QDdThXjTC7ljpJ+/rLOt7f2rW3U+510AIedNwqw5c4ONAF
LlSUMDsGJUs2eduX0loQLjdZdzqjDqQ3pBnUFw9UYuXYdFEw3nROo3E3HOkmQ396
Z7NvAsF3xYvZNKkunwPLFxxydBYp4uxplS6i2KdOVXNEJUHrG85j4OiLIv/D6XxB
2x4L9seOgRBTVGY3ts3j
=6vqS
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jul_2013_15_56_55_+1000_9WHoPgrGBJJrXYrn--
