Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaCaLWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:22:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49329 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaCaLWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:22:08 -0400
Date: Mon, 31 Mar 2014 12:21:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Arun Shamanna Lakshmi <aruns@nvidia.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Songhee Baek <sbaek@nvidia.com>,
        "'lgirdwood@gmail.com'" <lgirdwood@gmail.com>,
        "'swarren@wwwdotorg.org'" <swarren@wwwdotorg.org>,
        "'alsa-devel@alsa-project.org'" <alsa-devel@alsa-project.org>,
        "'tiwai@suse.de'" <tiwai@suse.de>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Message-ID: <20140331112140.GO2269@sirena.org.uk>
References: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
 <53332CC7.6060800@metafoo.de>
 <D6C615D3E4730340AE82D5BD856631C0A26CB319B2@HQMAIL02.nvidia.com>
 <5333ED3A.7040908@metafoo.de>
 <5571431004A69147BCABABE4E097D66BA3EFF70CFC@HQMAIL02.nvidia.com>
 <D6C615D3E4730340AE82D5BD856631C0A26CB31F48@HQMAIL02.nvidia.com>
 <5336A619.5030007@metafoo.de>
 <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v1TsIsr/WJoL6YzS"
Content-Disposition: inline
In-Reply-To: <781A12BB53C15A4BB37291FDE08C03F3A05CC6A11A@HQMAIL02.nvidia.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: Add support for multi register mux
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v1TsIsr/WJoL6YzS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 29, 2014 at 11:12:30PM -0700, Arun Shamanna Lakshmi wrote:

Fix your mailer to word wrap within paragraphs, your mails are
excessively hard to read.

> > I'm not sure I understand how that MUX_OFFSET would work. To get the
> > selected mux output you can use the ffs instruction.

> > foreach(reg) {
> > 	reg_val = read(reg) & mask;
> > 	if (reg_val != 0) {
> > 		val = __ffs(reg_val);
> > 		break;
> > 	}
> > }

> There are 2 options to do this. The first option is what you specified
> above, in which case I think we cannot share get and put functions as
> they use the reg_val directly inside snd_soc_enum_val_to_item API (not
> the bit position being set). If we change to bit position like above,
> then the current users of these APIs should also change their soc_enum
> value table. And, the second option being the one that we proposed.

Sharing the functions isn't the goal, coming up with a usable API is.

> That being said, MUX_OFFSET which is the second option works in the
> following way. We know that reg_val is a power of 2 (2^0  to 2^31)
> which is one hot code. This method adds a unique offset for this
> reg_val for each incremental register that we want to set (say 2^n +
> MUX_OFFSET(reg_id)) inside get function and does the reverse of it in
> put function. For current users of only one register, it doesn't
> change anything as we use reg_val.

I'm afraid I can't understand the above at all, sorry.  The code below
is quoted like Lars wrote it but I think it's actually written by you,
please check your quoting when replying:

> > 	if (e->reg[0] != SND_SOC_NOPM) {
> > 		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
> > 	    		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
> > 			val = (reg_val >> e->shift_l) & e->mask[reg_idx];
> > 			if (val) {
> > 				val += MULTI_MUX_INPUT_OFFSET(reg_idx);
> > 				break;
> > 			}
> > 		}
> > 	} else {
> > 		reg_val = dapm_kcontrol_get_value(kcontrol);
> > 		val = (reg_val >> e->shift_l) & e->mask[0];
> > 	}

The above is a bit confusing...  partly this is because of a lack of
context (what is MULTI_MUX_INPUT_OFFSET?) and partly because it isn't
entirely obvious that stopping as soon as we see any value set is the
right choice, especially given the addition to rather than setting of
val.

--v1TsIsr/WJoL6YzS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOU/BAAoJELSic+t+oim9JzsP/0rAze5oaWGZnT1+gHBkKiK+
OR13aBwAY/MTbEPZe1EMHUmg/qb4KVkXISTsW/E7S5uJoDko4ATFYzeU2c8+lO7F
K25sruBgkMpQEQ3OYg5tf6qN3qurbNNKHDG/2/64PneGOwEiP3CX9K6/VNdEvHBG
vg6WZLhOJMN6hNJ/Jvn1+9OisOkyGd85F7kEkMVM9vZ6hVJXTv/i783gnTwPYNhY
e0l51v5/1RUjke7hvQvPqIlmMUJvNxB2slQIfdJkLN4U9Katl2faBC1JhkpCQDMP
bhRgyc/oENFH85NHsoO3x/TntQlwzilStufZWVI4NKMHAdtWqyj5qUiP8kIO+VcK
Qhp6pVgkpaPfTHw28k5OqHqb7Niva2ntRIInPiOL3nJ0zGAsYaayd7fJB74et48r
B/sOE9aOglcJb9zlSb5DAugjhw8JKy5Ew+YeHddM111lZrG5DiAUiTQfTNhA+xBo
2MAozaFfHZcqUBmnuEuEWHcY+55UAbp9bAUG9Zrabu36xtXZT6RmRDFWzV3xA+h+
LuhJDHgE6mRX3cCdBXz8E+9YtW1l1u9D3HSDlHTADP3zjiy80VkRrXrjJfk0W1mw
Cuemt74ybUh5rIr4PUL4MxkmxDiG8w9QFDYLqZWaJpmWcKd24h5KEnTFwuv7UrRU
BziNxxd5/0wB+8w++V9v
=3DF9
-----END PGP SIGNATURE-----

--v1TsIsr/WJoL6YzS--
