Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab3F1J77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 05:59:59 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:37471 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779Ab3F1J76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 05:59:58 -0400
Message-ID: <51CD5E99.5010802@iki.fi>
Date: Fri, 28 Jun 2013 12:59:53 +0300
From: Tomi Valkeinen <tomi.valkeinen@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rob Clark <robdclark@gmail.com>, Paul Bolle <pebolle@tiscali.nl>
CC: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
References: <1363204102.1335.6.camel@x61.thuisdomein> <1371119474.1357.6.camel@x61.thuisdomein> <CAF6AEGs_LS1ZFFj+C67dmRj4G122O1YSqTH_EpgtkLkQOKb2LQ@mail.gmail.com>
In-Reply-To: <CAF6AEGs_LS1ZFFj+C67dmRj4G122O1YSqTH_EpgtkLkQOKb2LQ@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2ETPWCRQMOHXBHRIHLCVO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2ETPWCRQMOHXBHRIHLCVO
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 15/06/13 15:20, Rob Clark wrote:
> On Thu, Jun 13, 2013 at 6:31 AM, Paul Bolle <pebolle@tiscali.nl> wrote:=

>> On Wed, 2013-03-13 at 20:48 +0100, Paul Bolle wrote:
>>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>>> ---
>>> Untested. Perhaps the first test that people with access to the relev=
ant
>>> hardware might do, is to test _before applying this patch_ with FB_OM=
AP2
>>> set. Perhaps this negative dependency isn't needed at all. Or is it
>>> obvious?
>>>
>>>  drivers/gpu/drm/omapdrm/Kconfig | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> This patch was sent exactly three months ago, shortly after v3.9-rc2 w=
as
>> released. This obvious typo is still present in v3.10-rc5.
>>
>> I didn't received any feedback on this patch. Did anyone had a look at=

>> it? Is it perhaps queued somewhere?
>=20
> oh, sorry, at the time I was in the middle of moving, and wasn't
> watching dri-devel so much.
>=20
> Yeah, this should probably either be merged, or we should just drop
> the negative dependency.  (I guess in theory you could build both
> omapfb and omapdrm as modules and just load one.)

Hmm, fixing that creates a problem:

drivers/video/Kconfig:42:error: recursive dependency detected!
drivers/video/Kconfig:42:	symbol FB is selected by DRM_KMS_HELPER
drivers/gpu/drm/Kconfig:29:	symbol DRM_KMS_HELPER is selected by DRM_OMAP=

drivers/gpu/drm/omapdrm/Kconfig:2:	symbol DRM_OMAP depends on FB_OMAP2
drivers/video/omap2/omapfb/Kconfig:1:	symbol FB_OMAP2 depends on FB

And it makes selecting omapfb not possible...

omapfb already has a !DRM_OMAP dependency. I think it's enough to have
that one there, and remove the !FB_OMAP dependency from omapdrm.

 Tomi



------enig2ETPWCRQMOHXBHRIHLCVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRzV6ZAAoJEPo9qoy8lh71ej0P/2oLobRaeoXc/KgqSBAgtjB2
lrwhBgSfV+cBamVoDurstZ27yVtHYpRogsicei7tungExsYX8azoiP+YkTZtAhIa
W/fIolMq5z+YHnaliTj5MGzsT6kIlToA/EXHhYwyvSDizLr1/34JwR3zaQWpsBHw
ar9SCn7nmEUeMailovvjqQumxLa5o+JmbRRHpuQnadtgYbg6wO4TPHOKB+sux3PZ
rR8LCzpVPPLH75d34a9IAYSxJpi9VqP9CEvHPmL7QIkKkCae2B95E/T9DXtv6EQD
9FXJe6zFyk8vqEen2/glUkj8khLSsycEhlEmKPup7xBB5Tz7lRQG7A9+erZ0cNKm
EcNR6dzuXaflX+nkO8VBuccaSdQa4P/Vwecs/CElnlBjpoz9LWthjSkhOB0yydqF
T4aeiKxSwhHXY94beR3FRrM0GUfneHEc/nqDIFK7pRo59DBZuPCsA6VZGhDx2pbK
SA6G6Cze8tDsthYKxSIAKL/JfcGJbYZzfhCsEfVFLxQpfY4qwQiIrpAw3nC3Qmu1
zt+2qzIc1RqA/kaTYftYot9S5pjzTnpyPpXhp3JeeK/WEOQkAwk7gX7mDB0EyhqY
Au6/Fs8Ns4vfp4bBgADe1moXW9KejcuH4J7uczX5lN2KPZyWmxYs47ggjd04Pd//
5x9gJpdElKTead/q93mO
=0oc9
-----END PGP SIGNATURE-----

------enig2ETPWCRQMOHXBHRIHLCVO--
