Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759608Ab3HNJHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:07:32 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49732 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759501Ab3HNJH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:07:29 -0400
Date: Wed, 14 Aug 2013 11:07:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 4/5] PCI: mvebu: add support for reset on GPIO
Message-ID: <20130814090715.GA2084@ulmo>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <1376396724-32048-5-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 13, 2013 at 02:25:23PM +0200, Sebastian Hesselbarth wrote:
[...]
> diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
[...]
> @@ -897,6 +904,30 @@ static int mvebu_pcie_probe(struct platform_device *pdev)
[...]
> +			u32 reset_udelay = 20000;
[...]
> +			udelay(reset_udelay);

udelay(20000) is probably not a good idea. You should probably use
something like usleep_range() or msleep() here. Also see:

	Documentation/timers/timers-howto.txt

Thierry

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC0jDAAoJEN0jrNd/PrOhW7oP/3+SkTS8boO9XG2TSPH40IcT
E8vIxPEkW3p5Pgaa6toG3N2GQVPAK9SWFbu3LDkL65vVe2eMgemoRVG2NTc52iO5
HGQjM1+cFcUsN7ic0SWQVeeyBV/4afZdLtjfVDpvkgRZBhc+SFhR0gRvELm/icE5
MJkOUmWrxJPQ+5Hs8zKTbHuTxpzKUKJDaNPBsszQxjixz+ZX8AsM04Iu5qvROGCF
TDLBagNrUyWmdiDti1X4GMtIUD3Y9ThOG5Be0P/yG+EhC46L/VI8421VYvzF1hVR
J0LkpN84bF6fdE/jCJ9J+XxgIIkPMhNn7+irx9uXdop5rBNsusMYmCZia6q1X1IK
Sr5gY24Hl3HR3yYSGgJyuiuoqwjPT3qxP8SjHE1w5wiJdrfS86ewKIoW9lCcDok0
+P6BV+M7gZqfYpFIXgJQSXyafkFVrwf9gvUI0yY4r5zz/A5u2zxf7ZAqS00oMBk6
+Tci8TdcBG3xzyzHkNJ1YIYhzU/WO0uQ6Wwj5gfYwN6bxSIZ5iRuEaCOyW2y1QeQ
rqE+bzr2Y+FjlYgLtTS7hDQnBs1G1F2aln8x9aP0HzRrCBRR9JAVD/uegCKAngEJ
ki6qpOMOEfVPQxs8Up1ptKo7JpX8bE2jLt5ViDvolrtWSgaUEH47hAGH0qmOLhf+
e9QHdYuignO05YsIUsn0
=NH7R
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
