Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaFQHJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:09:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34150 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbaFQHJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:09:55 -0400
Message-ID: <539FE9A1.7040409@ti.com>
Date: Tue, 17 Jun 2014 10:09:21 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
CC: Benoit Cousson <bcousson@baylibre.org>, Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
References: <1402676147-3711-1-git-send-email-balbi@ti.com> <1402676147-3711-2-git-send-email-balbi@ti.com> <20140616092219.GZ17845@atomide.com>
In-Reply-To: <20140616092219.GZ17845@atomide.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="oqoebKgLU15r7lD6grmrISgRbXqhpMfG6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--oqoebKgLU15r7lD6grmrISgRbXqhpMfG6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 16/06/14 12:22, Tony Lindgren wrote:
> * Felipe Balbi <balbi@ti.com> [140613 09:17]:
>> From: Sathya Prakash M R <sathyap@ti.com>
>>
>> Add DSS hwmod data for AM43xx.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Acked-by: Rajendra Nayak <rnayak@ti.com>
>> Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
>> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Signed-off-by: Felipe Balbi <balbi@ti.com>
>> ---
>>
>> Note that this patch was originally send on May 9th [1], changes were =
requested
>> and a new version was sent on May 19th [2], then on May 27th [3] Tomi =
pinged
>> maintainer again and go no response.
>>
>> Without this patch, we cannot get display working on any AM437x device=
s.
>>
>> [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=3D2
>> [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=3D2
>> [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=3D2
>>
>>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 +++++++++++++++++++++=
+++++++++
>>  arch/arm/mach-omap2/prcm43xx.h             |  1 +
>>  2 files changed, 99 insertions(+)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mac=
h-omap2/omap_hwmod_43xx_data.c
>> index 5c2cc80..d2a7b6d 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
>> @@ -19,6 +19,8 @@
>>  #include "omap_hwmod.h"
>>  #include "omap_hwmod_33xx_43xx_common_data.h"
>>  #include "prcm43xx.h"
>> +#include "omap_hwmod_common_data.h"
>> +
>> =20
>>  /* IP blocks */
>>  static struct omap_hwmod am43xx_l4_hs_hwmod =3D {
>> @@ -415,6 +417,70 @@ static struct omap_hwmod am43xx_qspi_hwmod =3D {
>>  	},
>>  };
>> =20
>> +/* Display sub system - DSS */
>> +
>> +struct omap_dss_dispc_dev_attr am43xx_dss_dispc_dev_attr =3D {
>> +	.manager_count		=3D 1,
>> +	.has_framedonetv_irq	=3D 0
>> +};
>> +
>> +
>> +static struct omap_hwmod_class_sysconfig am43xx_dispc_sysc =3D {
>> +	.rev_offs	=3D 0x0000,
>> +	.sysc_offs	=3D 0x0010,
>> +	.syss_offs	=3D 0x0014,
>> +	.sysc_flags	=3D (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
>> +	.idlemodes	=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
>> +	.sysc_fields	=3D &omap_hwmod_sysc_type1,
>> +};
>=20
> Looking at the TRM, "Table 13-43. DISPC_SYSCFG Register Field
> Descriptions" seems to list the folowing bits available:
>=20
> 13-12	MIDLEMODE=20
> 9-8	CLOCK_ACTIVITY=20
> 4-3	SIDLEMODE=20
> 2	ENWAKEUP=20
> 1	SOFTRESET=20
> 0	AUTOIDLE=20
>=20
> Have I missed something or how come we don't define them all
> as available?

Yes, you're right. I don't see why they shouldn't be there.

> The .idlemodes available values and .sysc_fields seems to match
> the TRM.

Shouldn't idlemodes also have:

	MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART

I changed the dispc flags to:

	.sysc_flags	=3D (SYSC_HAS_AUTOIDLE | SYSC_HAS_SOFTRESET |
		SYSC_HAS_ENAWAKEUP | SYSC_HAS_SIDLEMODE |
		SYSC_HAS_CLOCKACTIVITY | SYSC_HAS_MIDLEMODE),
	.idlemodes	=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
		MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),

and DSS seems to work fine for me. Then again, I don't think there's any
proper PM going on (or at least things like debugfs/pm_debug/count shows
no sensible values), so it could well be that those flags are not even
used at the moment.

 Tomi



--oqoebKgLU15r7lD6grmrISgRbXqhpMfG6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTn+mkAAoJEPo9qoy8lh71XnAQAIZQy7OP66ONNS+KBbip/Kog
l8dPO7k28b2pExm1CFUoJrTo64uEBd0LLD1CBOTYnDqvCs5b0ltCvQvJZ+9jRzoa
NkhczXikQzAsSuSmNbUAWK7cz3x0LdvuoOLemxkzfsFxeGmgkGEBb7Sy8PGQLYBs
vSZ34U0mRmiDfTjyCzO7E2Ihf6MtEaCjYbq9Z50aI1VCaqKz50XuHUVsWi9HsjVF
AMSKSmv9jWYaHEZrDzq54ec5J8vmKiiRG9UpdZWMp/WKpOjkHerRSb3m22AjB1gw
r3ITijetAXWlHIS3N8M2+5ZvUh4BpdD+i/g0JLFrfeBcopaZh06V6D8OyTbC/Z9b
+iWyCmhOJuPXDizXyn6norWVLJZe44Cw1ecU9E8Oqm/KzGYMlDQ+lS74E8rLiqle
goA0GNqNCvGlbc/VOxrVeVBxRWAOcN5GZ0UDNxaLy2g5q2MhagKoQDWYnakx7ra7
CmP/45b0RjDiV8vn0Ktt+NgHMU2yY51YWjEyuckqZQS3Vjko8Giujjqx20Gs0iSC
zK2pSM3aERLyyStiicGdb2URp/lXbtzjtfNZoupkzvfrNrMXC29T4xFeygRWR8A9
rj3jiAydp5LjehcPqqoWXSqywF/Qt2QQfxri+CGoYTZaigBSfgVgI0dk4R6FsnWZ
/tsZyfboDxf3Z0qinQ/7
=/b+u
-----END PGP SIGNATURE-----

--oqoebKgLU15r7lD6grmrISgRbXqhpMfG6--
