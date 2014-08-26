Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbaHZG5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:57:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:34064 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349AbaHZG5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:57:35 -0400
Date: Tue, 26 Aug 2014 08:57:31 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Message-ID: <20140826065729.GC15573@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org>
 <1408381705-3623-3-git-send-email-abrestic@chromium.org>
 <53FB8820.4010202@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <53FB8820.4010202@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
[...]
> >+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
>=20
> >+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >+	if (!res)
> >+		return -ENODEV;
>=20
> Should devm_request_mem_region() be called here to claim the region?
>=20
> >+	mbox->regs =3D devm_ioremap_nocache(&pdev->dev, res->start,
> >+					  resource_size(res));
> >+	if (!mbox->regs)
> >+		return -ENOMEM;
>=20
> Is _nocache required? I don't see other drivers using it. I assume there's
> nothing special about the mbox registers.

Most drivers should be using devm_ioremap_resource() which will use the
_nocache variant of devm_ioremap() when appropriate. Usually the region
will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
remapped uncached.

Thierry

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/C/ZAAoJEN0jrNd/PrOh+FEP/iBrDm8It9BvNIgaJPQyAur+
ITotMb7ok+lntJDe1U5k+zDjUL6oz+V9/VSXXoJ1aVK0yMSlaQh8J1kVyY/ng692
9v7xlHlvd4wTdvh5yMcR1rXq6t5RYOR9olRTt9Ueu8DLjge3YP+UfDZ88pG611o8
peGAZ9UmlsiepbAOaqyaeqGWynd7SbNMKDSTtppnviZNJlxfKh3I+JMetYYbYut8
uBNBRnaOlWqWNoYFoL2DPVk2SRQnndY4v+KuYyh/isFei4yGMtUsHzTk8sHuzqqh
OyhLjWDk8caodmKEIIABlZiMXQFGkxhwbd+jADOFwO+d9D/oEQFRMw0kZydpy0Ob
YAZFQSn8/LZHDhwFMv8+u/JClFddUS0nmit1M0/fB2tm8rAc6G810wD816SPPtsg
IPUZt9DA6YE3rOIuC4oGvl2IzQjDn+cPlWmEJp89r4BzMjlZU9vje7TJ+gCBjlqV
+/tuC/xnrWBpSfZ6rIwVkW0K9xJM/wtjTbZxEfPLvtdmVFjl9rhUEcYDc3P8rIY0
kAz5M8nGS5L72Vc+C5sq+6u2zmtTpA2KvHoPGCdczMqFxfoovHVYOrdFM8Jbncxy
1PG6+vo8Ihm4LE8d0Wa+xnJ6OkCpsVQ+5VrJ9rUFlKd1yo8VWtAvpl5oAtIfSwV5
162sIf1/+ckqFd+bKVSJ
=4K+c
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
