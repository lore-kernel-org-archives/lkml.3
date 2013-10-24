Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3JXJT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:19:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38087 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482Ab3JXJT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:19:26 -0400
Date: Thu, 24 Oct 2013 10:18:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Tero Kristo <t-kristo@ti.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20131024091857.GG31415@sirena.org.uk>
References: <1382605668-31395-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <1382605668-31395-1-git-send-email-t-kristo@ti.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.186.44
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: debugfs: Fix a boot time crash with early regmap
 init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 24, 2013 at 12:07:48PM +0300, Tero Kristo wrote:

> +	if (!regmap_debugfs_root) {
> +		struct regmap_debugfs_node *node;
> +		node = kzalloc(sizeof(*node), GFP_KERNEL);
> +		if (!node)
> +			return;
> +		node->map = map;
> +		node->name = name;
> +		list_add(&node->link, &regmap_debugfs_early);
> +		return;
> +	}
> +

init is somewhat parallel so I'd be happier if we locked the list to
make sure that we don't corrupt the list.

We also need something to handle removal of items from the list if the
regmap is destroyed prior to the initcall running (for example in error
handling cases), otherwise we could end up creating debugfs files
pointing at devices that no longer exist.

--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaOX+AAoJELSic+t+oim90DoQAIcsAJJqOmoW/AozGyHGlxM0
k+qQAlfKySMwwWPH+aA9WWJ5Yj6NZeigz7QkcvqX6cpqybQUnAQzcjxKITrYwJ0/
s2ZlvaGzL0XnHnoL99or7suTrIJ6aok+xbcO6p0lm+Zs4kV/MQTV84xIUPiwXHgq
/KPkF7vHRSt0oXgTKbs2AymxwIGnyj3w3L3YmvGKWO98JL8kajpEzJFomAglQvau
TOLIht4fKY1kVGSg06C7/jesGRGRrJgApwKxRwJQnGsqNUjmRf+xuXB6J+ZclVMq
pPaO4yBKZhXM8s8Odc0RIOyUkBIIKkoXyLruBUciZfklTNPjcCEUTUlhsCcptzye
HZcL2YkOdhclISa88BikMZWgZmsus03/GKRuFyfyxEXaqlnQWOkC9BWDG7q7DIUA
KrQsA+yWChol6azmgnbCH0WNcvDMY/ogHDtgOZgbMvRPo72LlaXU76v+O8pvoCWG
qLwEIbTOJ8Aox2hjOv/EzMNDUEJihvz52pbNz0PShc7kqHodXOzx6A6pgA1DZ6LL
t4aP9wpz8BQjTh8AXpBoYWNO354gWkpaO6N4teTyyaF61rQ11q2R+XBBZhuZHZuM
gApdyGlpxs8dFiCZdzWuVidqGFlwR447Cot29RqNfwONxHhYiRTYUuYttZcbEK8Y
8oBC9M/ivLKUVEHDQUXz
=USkd
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
