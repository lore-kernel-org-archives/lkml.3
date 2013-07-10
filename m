Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3GJK2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:28:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58217 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3GJK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:28:04 -0400
Date: Wed, 10 Jul 2013 11:27:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: J Keerthy <j-keerthy@ti.com>, mturquette@linaro.org, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        lgirdwood@gmail.com, t-kristo@ti.com, wim@iguana.be,
        gg@slimlogic.co.uk, Ian Lartey <ian@slimlogic.co.uk>
Message-ID: <20130710102724.GC24508@sirena.org.uk>
References: <1370261333-5121-1-git-send-email-j-keerthy@ti.com>
 <20130603141851.GG3370@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
In-Reply-To: <20130603141851.GG3370@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: DT bindings for the palmas family MFD
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2013 at 03:18:51PM +0100, Lee Jones wrote:
> On Mon, 03 Jun 2013, J Keerthy wrote:

> > +	       optional chip specific regulator fields :-
> > +	       ti,warm-reset - maintain voltage during warm reset(boolean)

> Pushing the boat out a bit here, but is it possible to reuse
> 'regulator-always-on' for this?

This sounds more like "don't reset over reboot" than "never change the
enable state".

> > +	       ti,roof-floor - control voltage selection by pin(boolean)

> Is this the same as a GPIO regulator?

> If so, you might not need to add superfluous vendor specific properties.

Lots of regulators have the ability to do things like switch between
programmable voltages based on GPIOs (enabling a fast change to a known
voltage) - the roof-floor naming sounds like this.  Usually there's also
register based element for selecting the voltage.

> See: Documentation/devicetree/bindings/regulator/gpio-regulator.txt

> > +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 - auto,
> > +	       2 - eco, 3 - forced pwm

> I've seen lots of sleep-mode properties, can't we define a generic
> one?

We should make some of this more standard (at least things like
voltages) but the whole concept of what sleep mode is is at best fuzzy.
You typically need different selections for suspend to RAM and suspend
to disk, plus often the suspend configuration is dynamic depending on
what the system is doing since suspend is just CPU suspend not system
suspend and there's also some changes that might happen depending on
which wake sources are currently available.

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3TcEAAoJELSic+t+oim9e6YP/iYgEoPUxH/OaBtTO5O3hYid
RZ/mIrqY68dIOBRQ50vRmLY1FlauXeQCRKTALvgX6yBlPjAuYhpJBnEIp9hxZqR9
sZuSG8RBseeKJGxtswfwLWWes2fO9RTfT2a4cqvtc32fmzu0/0bAxKqz/CtHkKIj
trGvd/RUFjBuZzPPuAZ+L4Cx8vX40NunK9jWsoR02NcH3Z06SOsa7ztYm7ORjvj+
qdxD+y5/2mNdt211YQbwHSTTPcfyLJdlxrrJTxaUTfHYML+SvWEh//8OFFBKKdua
s4Rwrf1X56aSalHKW0o1VnSsoDJmadMoc1GeOYsKrUZD5p8zW8BkMMYkjXyGkCSr
CJ0M79o8IkXUolKoWUiX+S+lelO7I8j0iu0mzssJsC4Tf8+OJwtBAz6waPvuJlrN
ez+fqsR3yEXSc5UuGRfzZFNYa1+SYcA8Ma4AITR+iwnGc9TOegBCI3NE9XvQZa/i
VIGE9+M3OVYM+XxrNLjKkw4QD27dRz8/RExH7PgumC1liFU+Nvmainx2mqaomwXN
Tl0WYaZEQ1Gu9pv7MHb/ywBbD93M7gzgD6jtOzYiGUogSE+HmbeediDblLtGvTbh
Sfm9JVWRhlt7aLHNsx3YLKHvFmRuhY+48pJrZtNZBBtmcspeBDvXNqCY65eImVbW
awRLEklN7Az8Ea6n0PYK
=UQsC
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
