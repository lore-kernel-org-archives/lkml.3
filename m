Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaJ0M6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:58:24 -0400
Received: from sauhun.de ([89.238.76.85]:35707 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaJ0M6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:58:22 -0400
Date: Mon, 27 Oct 2014 13:58:19 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@gmail.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: I2C OF IRQ parsing issue due to probe ordering
Message-ID: <20141027125819.GA12641@katana>
References: <2287003.09eTeKUr1V@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <2287003.09eTeKUr1V@avalon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> The i2c@e6520000 node is probed before the gpio@e6051000 node. The
> of_i2c_register_devices() function tries to register all children, including
> hdmi@39. It tries to parse and map the I2C client IRQ by calling
> irq_of_parse_and_map(), which returns 0 as the interrupt controller isn't
> probed yet. The adv7511 driver later probes the hdmi@39 device and gets
> client->irq set to 0.

I've got this strange feeling of deja vu... Ah, here: Thierry Reding
tackled this problem a year ago. His series:

https://lkml.org/lkml/2013/9/16/111 (of/irq: Defer interrupt reference
resolution)

He did a V2 (which never made it to the i2c list). Seems like the first
two patches made it and the rest got stalled without discussion?

https://lkml.org/lkml/2013/9/18/216

Adding Thierry to the queue. Maybe he can bring some light to what
happened to his series.

Regards,

   Wolfram


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUTkFrAAoJEBQN5MwUoCm2a4IQAIbrQiPsJTA6xoS7X6tkMjjB
5kCBqX7Yq0RFX+NRvQpknjdTs6GhIX6ZlYjqViEu8PxMVVd53yS0MHFZhoWLkzzC
R1XTzwUmqPxy8e2kpPyPhSwxXxoB8C5IB1BXN1UgV1K6sqXpdG8n/LffdCTzTtgV
lBWq6U6j/5LXiEH/NJzf9qLvF7pzjIydlK1BnX/gKGlWV7BxaR+WrtCG+lfnjDcv
6gzN26JDgOLsagQWAFYL9EbRtQZglx/wt1FDvwThWPWc5hP+jwpgUCEhhWoi3fui
wNXB2cdB0kygkSi7jHprTYQTJv373tFqQynU8BcnqbIODDX20ToPSO07ILpfi7M9
X4Pc4AntSCqnbMtRa8cIYBH1fmRpp5u5upFvnDCT9WkYQgRk8Coj2/IY1qpNunLg
xs0PpivoXwofZ42zVujB5NKxn89FnQS12qJhxPIgr7Xe/skbC7SxdNjYSK4d1icl
1i0+52TmcdAVkRzl9hvjwMzai87o7Rge4qW9xClkGi/wOaR7gOMOEF+DpWSE4fgn
ZS+jgYoXvszlVaK04AEvYl1LOaNqexy9wemckLjc0jb7fTHlHiQNGhMUol9a3NlQ
1DaN/ZwoHcozniJiPzQxJrW8fzIgo039Ns+YtkBzlTl1aFkD+ZHSX6kaa0zTVd+K
3e8TAgReMgpNtQcJho/A
=0bkD
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
