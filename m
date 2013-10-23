Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3JWKLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:11:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57862 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab3JWKLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:11:47 -0400
Message-ID: <5267A0DF.7080604@ti.com>
Date: Wed, 23 Oct 2013 13:11:43 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Kevin Hilman <khilman@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Archit Taneja <archit@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Async runtime put in __device_release_driver()
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="JaDPebUTu3lVRTkBrFt7IUfn4N9Rga64f"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JaDPebUTu3lVRTkBrFt7IUfn4N9Rga64f
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I was debugging why clocks were left enabled after removing omapdss
driver, and I found this commit:

fa180eb448fa263cf18dd930143b515d27d70d7b (PM / Runtime: Idle devices
asynchronously after probe|release)

I don't understand how that is supposed to work.

When a driver is removed, instead of using pm_runtime_put_sync() the
commit uses pm_runtime_put(), so the runtime_suspend call is queued. But
who is going to handle the queued suspend call, as the driver is already
removed? At least in my case, obviously nobody, as I only get
runtime_resume call in my driver, never the runtime_suspend.

Is there something I need to add to my driver to make this work, or
should that part of the patch be reverted?

 Tomi


--JaDPebUTu3lVRTkBrFt7IUfn4N9Rga64f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIbBAEBAgAGBQJSZ6DfAAoJEPo9qoy8lh713OMP+PqYlLhXVMlChOoaFa3uZpfH
sI5o8IBp2HUIer8LceP4TChs15XOWBpWuZwUhSPt7ntvYjOhi5rN+6kgPHoeUaoj
uA9sj11dtwEp+f1LgMgO/kzRsZDPO1ZE1EIByNN+LJeUPVtlO082G/ql3QuC6QZY
/rzoOTbfXrmlfT5vYe5ca/pBFthbI9cyvmaNmZSFAYUL5cvBoi9fKFPPLK/tDO4P
Uz3FOM+7GqQAVWdv+lnkUmsmR6qY1xkUx9i8WAD4LAXcutnkfo9NZAeBeO0m/Bbn
N7zS50fmabNhHWvM5Zhsu49UrvjFzpglXqxip/0Q/0495Q/8HX+tnevX659wOLZc
daxWS9kVzykTAoT0qlGVPZiZHiJiURZbr9e9PgWakRgl9PKc77E0qSTZLu71ZTsP
2tgUgLPlMXW407elAU7tBgKVD6KyZ+dF3A5TEMmuIzm4bhpqU5kcZ3MMfwSjmKFr
gdAz1YWD9dwYB9F2LSJPu6HdswHtpF9wMeHG7slBZqcoAOPMwnYqq/XV0y4rPrXw
k30c664wNfRFXalrEhNHXE5It0GfCbsQlO1/cToq+JdJGsPZQ6rQkS/PqSLGlvxt
VssK9hS1Jc21SNNnzPtLmMkCRLv9r8amXIUPimCQoXzMmaZ+AwBwlo49bzhu0LlH
+Z3A+O6SQoOWt4nO2SY=
=0Fw2
-----END PGP SIGNATURE-----

--JaDPebUTu3lVRTkBrFt7IUfn4N9Rga64f--
