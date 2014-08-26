Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbaHZKDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:03:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34375 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaHZKDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:03:34 -0400
Message-ID: <53FC5B23.3000205@ti.com>
Date: Tue, 26 Aug 2014 13:02:11 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Griffin <peter.griffin@linaro.org>,
        Alexander Shiyan <shc_work@mail.ru>, Jean Delvare <jdelvare@suse.de>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@linaro.org>,
        open list:
	FRAMEBUFFER LAYER <linux-fbdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH] powerpc: Fix build error for vga16fb
References: <1408396422-32658-1-git-send-email-bobby.prani@gmail.com>	<1408396422-32658-2-git-send-email-bobby.prani@gmail.com> <CAMuHMdV_vAPCPh1JdCxtf0iz6haHULUV8t0oYt0jrEAky2WSLw@mail.gmail.com>
In-Reply-To: <CAMuHMdV_vAPCPh1JdCxtf0iz6haHULUV8t0oYt0jrEAky2WSLw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fmt6LPghKEMtrwj4DQ6Kwfb261RTsbXKf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fmt6LPghKEMtrwj4DQ6Kwfb261RTsbXKf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 19/08/14 00:28, Geert Uytterhoeven wrote:
> Hi Pranith,
>=20
> On Mon, Aug 18, 2014 at 11:13 PM, Pranith Kumar <bobby.prani@gmail.com>=
 wrote:
>> Fix a build error caused by
>>
>> drivers/built-in.o: In function `vga16fb_probe':
>> drivers/video/fbdev/vga16fb.c:1326: undefined reference to `vgacon_rem=
ap_base'
>> drivers/video/fbdev/vga16fb.c:1326: undefined reference to `vgacon_rem=
ap_base'
>> make: *** [vmlinux] Error 1
>>
>> This is occuring as vgacon_remap_base is exported only when
>> CONFIG_VGA_CONSOLE=3Dy. Fix the error by making FB_VBA16 depend on
>> CONFIG_VGA_CONSOLE.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  drivers/video/fbdev/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/video/fbdev/Kconfig b/drivers/video/fbdev/Kconfig=

>> index e911b9c..09df564 100644
>> --- a/drivers/video/fbdev/Kconfig
>> +++ b/drivers/video/fbdev/Kconfig
>> @@ -547,7 +547,7 @@ config FB_IMSTT
>>
>>  config FB_VGA16
>>         tristate "VGA 16-color graphics support"
>> -       depends on FB && (X86 || PPC)
>> +       depends on FB && (X86 || PPC) && CONFIG_VGA_CONSOLE
>=20
> The dependency on CONFIG_VGA_CONSOLE only exists on PPC, not on x86.
> So this is not correct.
>=20
> Digging a bit deeper: There's no code left in arch/powerpc that actuall=
y
> sets vgacon_remap_base, so it's not gonna work anyway.
> It seems vga16 support on PPC died with the removal of arch/ppc/.

Hmm, so I wonder if vga16fb is supposed to work on ppc or not. Pranith's
follow-up patch disables vga16fb for PPC, which obviously fixes the
compilation problem, but is that really a correct fix?

 Tomi



--fmt6LPghKEMtrwj4DQ6Kwfb261RTsbXKf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/FsjAAoJEPo9qoy8lh71LJ0P/iagrNPQ9+mBdYt7bSmDX8ka
5vHlzH6OKUgSKpxuHi5J9u+qp/yCeHAmGyYi8puVTyhpDxDpindD2uw0MGE+3Vmn
9XdFNAlodTVgsth8hMFYFjG1bedaAhn13ERjMpsWu9qqtsXVf5r6+CN9aUozTjAW
l3VRuU0tRTy1F2clUcG7FZfagXD2BoQhpk/8YZXiPKLOqIIepiXffANXjQ9+zvvz
RBkQbLcKYovsRuVC2lmWfs0SIedV9zboLF21CtgZBRzurB5ZDThd6ZjfLG+lAhnN
Ke3zSUsDM04P0Y7iOZSazGmj+iU0LIH2Uk8ShY9AsZOg9mr0ElmMXzdRyZOgOc0V
6B2OV2Q5IXw+po+BpfUELhVZhO1KEwWuBnv0y6OqX06tSho1Ka9w0TQ4E6UrACrF
3ruXWvdF0v4DxzIy4SNU+u7oW1GQOr/xFH/oa6FptBl66QjRkCVN4ciaST/LlmKh
fn0bGn7yX6kiXdoWFQbOZWX+k1J/6llAOGCTxcxi+f9ikuSgEdaUYOEpTXgjdQle
K7TBPoMF1sAuvn/LkfwXClYFhLHzZjW8/09KAiaCQc+CHqzV9B6b1auzMVpY8O5X
fUlfRoht9m3n7E+/hGVL9yzlMJ9ORkWcg/tkaAnbGnvkkmNa0pp9L5DvpX/dlQBg
jQPeZMn3EmlKrKTzWgeY
=yFp1
-----END PGP SIGNATURE-----

--fmt6LPghKEMtrwj4DQ6Kwfb261RTsbXKf--
