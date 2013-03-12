Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933357Ab3CLTKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:10:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070Ab3CLTKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:10:31 -0400
Date: Tue, 12 Mar 2013 19:10:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        ldewangan@nvidia.com, j-keerthy@ti.com, gg@slimlogic.co.uk,
        rpurdie@rpsys.net, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        sameo@linux.intel.com
Subject: Re: [PATCH v2 1/2] leds: Add support for Palmas LEDs
Message-ID: <20130312191029.GC19942@opensource.wolfsonmicro.com>
References: <1362064909-634-1-git-send-email-ian@slimlogic.co.uk>
 <CAK5ve-+-=R-f1KpEWD=4J3ia+QXmgnGvhDMV9tNf2_3WZupZaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7KvBbaRjXS2SFKKp"
Content-Disposition: inline
In-Reply-To: <CAK5ve-+-=R-f1KpEWD=4J3ia+QXmgnGvhDMV9tNf2_3WZupZaA@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7KvBbaRjXS2SFKKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 12, 2013 at 11:57:50AM -0700, Bryan Wu wrote:
> On Thu, Feb 28, 2013 at 7:21 AM, Ian Lartey <ian@slimlogic.co.uk> wrote:

> > +       spinlock_t value_lock;

> I think you don't need this spinlock to protect the value, the mutex is enough.

You need to use a spinlock because values can be set from hard IRQ
context so you can't take a mutex there.  Someone should really factor
this out into the framework in their copious free time, the set and
schedule pattern is very common in drivers.

--7KvBbaRjXS2SFKKp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP32eAAoJELSic+t+oim9RGIP/jo6uSRcr5LWT6AUeF9MrDJZ
uJm8hgjX9b2s6Upl4CVa3AIS/78OHiiLwBp3WHhGcpTZ5G8wBQ8iuvP71NsRWG7r
twJFJIL2EZJT57sFpfuZ25MgDXKhCj3b32/UzwciRB6GwfOYHGfM4lChj3CdaTBU
fMqxPIK76WcA5MKnvpev9yiBpXGzFduLnpCbqnKSFiJhmtmYoaR8lmMsclYb4A7n
1xI5B4x8k5VDK3+Vzk0apuOwRIPPoEHdXbrGn+Uz3oBqxDcU+Q8OxWIcNKdrwTWS
B5lPJuWGsSVqEV6NTFPMIz5nG2ZcLSEMzfgx34fPkQCojDXlJqSddSJPOpOS8mmD
VtOLHmUY8PlfdM46s+++TL7mvZY5iTqOLvb0G+5+2DduOa+7KRF5ChjYuNmDmxic
UFHt7305jVhewgN+7f6SM88HE0bLW+JiGJMG9Pm5/teEMJudVn4+TCgrn9QUtoYx
ycErB9BuEFdaYqYIJq6Pz33RBGWjoVZvdk6wCBPcUBNRqsN5TpKmC7ersWlJ0zO0
U8eKzAT3/S2Wz1sx3HAQNCBBnCJXLPHsJGxvzOkguXoP+NYxdKwb+1JbjXWgy4BZ
bNKaMim90nx69wo/o80ETqNbaACTF/YrlUUo50LjaxJc4F41NJo1pq4rnoydo3J2
TAwaB4QvaA81Q7oDem0F
=pKAI
-----END PGP SIGNATURE-----

--7KvBbaRjXS2SFKKp--
