Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3IWWZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:25:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34222 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3IWWZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:25:38 -0400
Date: Mon, 23 Sep 2013 23:25:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130923222503.GJ21013@sirena.org.uk>
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1379961043-23762-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vRyMahX6VF+pdQvX"
Content-Disposition: inline
In-Reply-To: <1379961043-23762-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] mfd: arizona: Add micdet ranges and polarity device
 tree bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vRyMahX6VF+pdQvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 23, 2013 at 07:30:42PM +0100, Charles Keepax wrote:

>  Documentation/devicetree/bindings/mfd/arizona.txt |   26 +++++
>  drivers/mfd/arizona-core.c                        |  116 +++++++++++++++++++++

It's probably more idomatic to put the parsing for these in the driver
that uses them.

> +  - wlf,micd-ranges : Microphone detection level and key configuration, this
> +    field can be of variable length but should always be a multiple of 2 cells
> +    long, each two cell group represents one button configuration
> +    The first cell is the maximum impedance for this button in ohms
> +    The second cell the key that should be reported to the input layer

This isn't good - the device tree is supposed to be an OS independant
description of the hardware that can be used by any OS but this binding
embeds Linux-specific numbers.  There are a few Linux specific bindings
where people have just given up due to the complexity of developing a
generic description but this doesn't seem like it shuld be such a case.
This is going to be used for buttons on headsets and essentially all
real headsets can be covered by just defining the ability to set hook
switch, fast forward and rewind.

--vRyMahX6VF+pdQvX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQL+8AAoJELSic+t+oim9RfQP/j8AnrLP6kju7ZsIjY0EvJcq
EunDlnJtQXycXeebsB2zAjVUqqmeCj2a44BEyuTVE5YJn+pzyS5C7MlQHkXDS/7N
mADOjzBYmE/tQuxZkZwU7D1KsYEGY6QJVE08Pbbbg6oyx3sBmbGqRLYOH5WdDgde
VP0G5MprrGRc9GtAeVBD0kz3hg+Yjh5F1wHyDHaxYyYDy+jL6m8axIOD9ay1Nz+i
6yYA2AmiLH8nNy5khOeJbcPHaSFMxyYnORHDJB1AU6WIl5beKDwogStW3tifTZgV
cQ1jZc3G9hm6DHN2/0xga+3br2xBYYavhLgh2QUzmNSQkqZjfcvMJOkFGP3JfNmh
qpW8Sz5sbQZ84iQ59nQQGiG3EDxK39cP3nmrtKdZpBYPY6vUO9oBbg1SVC+BrY3t
nvxc5+ciVnaKZGFqopLWw/Ls/Dd/p4m+OuOHejZuLgYzcZ4DaHlM+xWAcwcMLfuf
W2chRvQ8+iW1aWuPmJSx1ANIKVyyasoCLI68Nj2E0A2vSCuJL0CCP/5yitzdwxAJ
2EW5BfsmOiP9LpsZPTgnTVZvJjCAYxSa29ePvgy6SPZOGmc0sAsAxirYOfmnQQug
792orAMCfX76PYahcW6JHYB2JFajTrukLNVPXk9kjgsmfhHjFPzFkHLomha5uwSA
EcsiY7IUCYMh0aXpEEiz
=eXDG
-----END PGP SIGNATURE-----

--vRyMahX6VF+pdQvX--
