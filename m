Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab3JMSNE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 14:13:04 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45344 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab3JMSND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 14:13:03 -0400
Date: Sun, 13 Oct 2013 19:12:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Nikita Kiryanov <nikita@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>
Message-ID: <20131013181238.GO2443@sirena.org.uk>
References: <1381676471-25619-1-git-send-email-nikita@compulab.co.il>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zvl510+jvRFHh8wJ"
Content-Disposition: inline
In-Reply-To: <1381676471-25619-1-git-send-email-nikita@compulab.co.il>
X-Cookie: Time and tide wait for no man.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: fix use_count bug
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Zvl510+jvRFHh8wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 13, 2013 at 06:01:11PM +0300, Nikita Kiryanov wrote:
> During regulator registration the regulator framework checks that the
> regulator is:

Please try to make your commit messages briefer and more focused on
describing the problem.  A good way to do this is usually to start from
the problem and then explain it - what you're doing here is providing a
lot of background material without telling the reader why which makes it
hard to find out what the commit is supposed to do.

> invocations. The state of regX is not the result of a regulator_enable
> call, so use_count increments should not be propogated on the supply
> dependency chain. Instead, if there's a need for regX to be enabled on
> boot, the boot_on flag should be used for all the regulators on the
> supply chain.

No, that's not what this is trying to do.  It's trying to bring the
logical state of the system in sync with the physical state of the
system (as you'll see from the commit introducing it).  I suspect what
needs to happen to maintain the functionality is that the code needs to
directly call the ops (and walk the tree manually) to do the enables so
that the reference counts aren't disturbed.

boot_on definitely shouldn't be related to this and probably shouldn't
need all the parent regulators to be manually forced on either.

--Zvl510+jvRFHh8wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSWuKSAAoJELSic+t+oim9zZwQAIKZE7pe3+5tmNAaVaZBYuLP
85GlsZmvNMU80G4FbvPC1W2eeli8Ie+ApHwT2xiuh7tXYlHcqvksNv2MmSWV6wmA
+bCeCMtZboJXCorttykICrmxui+iClXl03OzXGAUYMz3ggMB8FFfk83yK+OH+DrN
DNWfhF4TQDEMoXYBcAJNxeS327QUG/6QYwoDwAWh4nvCfuGvnItm36as4qSNnjau
h12VaUIXNJAEPiG2/4fdV+XERKT49O9JV2ImoNu3YzJE4w0ktmdNf2e1bQp10WWa
RsNOYq73scCCIEBX4WVT2Ea6GpHnpOSpaW/1jcMgd3aw8azxfbaP9ff8BGymF3xL
PEXTLMqz8/jiKJzCd2ouaVA1BH0k51QgdE4V6/Onbo0U8GEICKJB7N72RrhYowVU
2Gy/SiRYbkBQP0rpI/G9CWb/PQIZq5+vHuDVjKuVv2F71a+CmsgqGSzT4gUTO1Dl
65MhaILIzdOb0EmerOB7ZH6QOReqEfL4x/8yRiOcS5g9m6td1rFTbwMXjN4gcRnR
OvuoSIqLA9QBnAy2Jsu2BEc51ncVgneYrXJg4sMCMgQfhV0ZTrEPpgwvXY4ZdPHU
jeFnJIvLlpzkJohBPfPBnwR5AWfId3bn6+Jk858QgbqS9iVYkjoAnpFYhQ9p+kRo
lPWkin/6EGb2on6C1u/r
=Dgaa
-----END PGP SIGNATURE-----

--Zvl510+jvRFHh8wJ--
