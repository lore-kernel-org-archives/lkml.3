Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab3ISLzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 07:55:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41030 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3ISLzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 07:55:43 -0400
Date: Thu, 19 Sep 2013 12:55:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, sameo@linux.intel.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130919115501.GM21013@sirena.org.uk>
References: <1379579392-1794-1-git-send-email-ldewangan@nvidia.com>
 <20130919083050.GH16984@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FAVlh7XA/4iOdtaa"
Content-Disposition: inline
In-Reply-To: <20130919083050.GH16984@lee--X1>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 86.153.71.95
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: core: introduce of_node_name for mfd sub devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FAVlh7XA/4iOdtaa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 19, 2013 at 09:30:50AM +0100, Lee Jones wrote:

> I'm not entirely sure this is what Mark was saying. I think he was
> complaining about the existence of the sub-nodes rather than how the
> MFD Core assigns their of_node. My take is that the chip is really a
> single device which provides different bits of functionality. To break
> that functionality up and disperse the drivers into various subsystems
> is a Linuxisum. By providing each functional block with its own node
> you're describing how we do things in Linux, rather than specifying a
> single node for the AS3722 which would probably be the norm.

Yes, that's exactly what I was thinking of.

> Do the sub-nodes have their own properties? If so, it would be worth
> breaking them up as other OSes could reuse the specifics. If they do,
> then you need so put them in the binding. If they don't, then you do
> not require sub-nodes. The MFD core will ensure the sub-devices are
> probed and there is no requirement for the of_node to be assigned.

You do see some reusable IP blocks (like the regualtors on the wm831x
PMICs for example, they're repeated blocks) which can be reused but
generally they have a register base as part of the binding.  Personally
if it's just a property or two I'd probably just put them on the root
node for the device.

--FAVlh7XA/4iOdtaa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOuYSAAoJELSic+t+oim9LlcP/iXsJl5JsRYOAqGLP0TfnNHw
fKuYUMnbJvoZ8hvXh1SQ0YyzshUQLJHixsJFqRZX9sNiG2ZRqMjb/dpBAhpv7R5f
J+skTM3eiN7q9qBwEKBSibiVsCq1l8jOi8FG+Ls+ETTMhHMlnu9mYYTyorXQsCcR
hS9UxZpcVEzh6jOkDYUcPIzf/GQKH0ThvSmtPGDcx0C4kEH+Rv8nSopZ73fS/B7a
+5opYK3jVDbglmISC4gkWyarCdxiE8Gt13ASOSfbVS05BOtaLHPgyQh5Hqju+3D1
nvEPKe8AGqeSL3TfJLbdnIS23jJlZnQRCCBS27A0mQ2pCAPwSjuo4MajpuZL3Kp0
KAsWzyn0Sgo9W8eba1o16nCuNg6UFQk8Ri+L/Y1cdzXtop99YucgSSZmGu+VPH58
DSdjAteGbO4M3DB3i7Mu02ZIjWUhEeniIz1U1AhrtWLVl8ccYfQjQ6gfA09o706/
doGdwWgjZLC1o7dl16f4pFOMeJ8QFfEg/6S5qogxVpiCSuc7JZwvakKW6y387hzS
lVquNhMWzRDVmA2wPrd9SVU+UH62oB4r/52m/ZxkwSMxYBmHv17hZcttdkvgvMcX
2rnjaoqD5THOQXhefv2m1VTAj9al0sLG08lelWFWsI605TSguyL/VNmJ0q/bNrsX
QDablCSTvH9oAHhyYNfj
=idoZ
-----END PGP SIGNATURE-----

--FAVlh7XA/4iOdtaa--
