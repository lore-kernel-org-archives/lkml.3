Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaDCLOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:14:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50654 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbaDCLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:14:44 -0400
Date: Thu, 3 Apr 2014 12:14:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20140403111431.GU14763@sirena.org.uk>
References: <1396447614-3048-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20140402142356.GE2269@sirena.org.uk>
 <20140402160438.GO1665@opensource.wolfsonmicro.com>
 <20140402165354.GG2269@sirena.org.uk>
 <20140403105804.GP1665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z118w8IfbP8nVdqq"
Content-Disposition: inline
In-Reply-To: <20140403105804.GP1665@opensource.wolfsonmicro.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Get and put regulator of_node
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z118w8IfbP8nVdqq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 03, 2014 at 11:58:04AM +0100, Charles Keepax wrote:
> On Wed, Apr 02, 2014 at 05:53:54PM +0100, Mark Brown wrote:

> > To make this correct we need to at least ensure that the node passed
> > into the regulator API is valid and referenced at that time so there
> > should only be an issue for the core if the reference is dropped after
> > that.  In the above case the device model is holding a reference since
> > this is the of_node for the device itself so taking the reference won't
> > hurt but is redundant.  In cases where we have more than one regulator
> > and are using of_regulator_match() then things are more tricky.
> > Something needs to drop the references it returns (which isn't happening
> > at all at the minute).

> From what I can see of_regulator_match isn't taking any
> references at the minute? for_each_child_of_node will get a
> reference but it will also put that when we process the next
> child. We copy the pointer to the child into match->of_node
> but don't manually increment the reference at all. So
> of_regulator_match has no effect on the reference count of the
> of_node.

Right, so that needs fixing - like I say if there's no reference being
taken we already have a problem and taking another reference later on
isn't going to fix it.

> >  Doing it while doing the match and register
> > seems simple and neat from an error handling point of view so having the
> > core take an additional reference during the registration would join up
> > with that.

> The main issue I have is that devm_regualtor_register is a bit
> awkward. With regulator_register you will always be calling
> regulator_unregister so you can put the of_node there but with
> devm there isn't really a good place to put the of_node.

That's why I suggested it might be OK to take a reference in the core -
this would allow the device probe to safely drop its reference before it
returns.

> Would perhaps a sensible thing here be to add an of_node_get to
> of_regulator_match, since we seem to be expecting that to
> increase the ref count. And then just add an of_node_put to
> regulator_unregister. And for anything directly using
> regulator_register/devm_regulator_register they should add a
> manual of_node_get?

That seems very ugly.

--z118w8IfbP8nVdqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPUKUAAoJELSic+t+oim9GxgP/Aq874K7IuUPxPCboshoH/0F
+yNn2/oZVEc54cH8sK2YlLA4zP842EDwgFMX9sXnWH9H3BmY0Pr+a2OLpKe45jW3
eqyzCvLqYjSh3DBZBnk3izvPQn1u5g17O3cz8gdKIfkVeV5ye80CP+yYts/EZdI5
lyCXRJWuSd0pbda/KnOrkfp1ktlZlKAHJfgVeIo9ESvpKA5Jr9GFQ17hz31bq6lx
CoMYrHdDHGaerjPUWleuNS2GFud8scJKiH6b4/QsI55o5hCmFuowekoA7HRYpurQ
zgPWdwt9x3qET9A+RfV04G3P7zL/PjVPEA69TTjRp1qGyBNO/9rqONMSci6eTYEx
OcQIw8ifAJdoK9Zn9aUOnuYZWzRj4TNoJpSVFVYMzu4ciInvV0CWV693pj55xW9Y
iuEbsF0PFeef8X4tfX3/qod2oz2eGzQQGuWSImnHWEBkQ3tmqO04mC5N9eI/y0ZE
TLFB81vqzuzJedhVSozYWQkhrHoT6ZdzEwP2+ukGhJ86EbNfsOF7CyKQhzrumocc
7EQO4JXkbKOPA8xMHjfP6ttPU9YDLv/E04263w29I9o2FcKuEsNyL8P88+9Fb9KU
u+ClOdtXyRKrrLClJTNfsb+04uMvUoIxlRADFBMHeWxVanIV1+k90QmxFzk58S6x
mflnvrcLu1cuLjPNZvA3
=K+8Y
-----END PGP SIGNATURE-----

--z118w8IfbP8nVdqq--
