Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab3FZMLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:11:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55010 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3FZMLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:11:09 -0400
Message-ID: <51CADA58.2030602@ti.com>
Date: Wed, 26 Jun 2013 15:11:04 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: "Etheridge, Darren" <detheridge@ti.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] video:da8xx-fb: Convert to devm_* api
References: <1368688257-18705-1-git-send-email-prabhakar.csengg@gmail.com> <1368688257-18705-3-git-send-email-prabhakar.csengg@gmail.com> <51CAD305.30407@ti.com> <CA+V-a8uhK5-QJKifkiSUN6Nz0aBc2moraWQUJPCmZg9zaFX0eg@mail.gmail.com> <51CAD7E4.2000403@ti.com> <CA+V-a8u6vjSc5EV3z4FCQ8LEHxL79bUXtHzX8svhQwqVtj6w=g@mail.gmail.com>
In-Reply-To: <CA+V-a8u6vjSc5EV3z4FCQ8LEHxL79bUXtHzX8svhQwqVtj6w=g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2DTDQJGPMUJFXVEUGNCOD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2DTDQJGPMUJFXVEUGNCOD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26/06/13 15:06, Prabhakar Lad wrote:
> Hi Tomi,
>=20
> On Wed, Jun 26, 2013 at 5:30 PM, Tomi Valkeinen <tomi.valkeinen@ti.com>=
 wrote:
>> On 26/06/13 14:56, Prabhakar Lad wrote:
>>> Hi Tomi,
>>>
>>> On Wed, Jun 26, 2013 at 5:09 PM, Tomi Valkeinen <tomi.valkeinen@ti.co=
m> wrote:
>>>> On 16/05/13 10:10, Lad Prabhakar wrote:
>>>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>
>>>>> Use devm_ioremap_resource instead of reques_mem_region()/ioremap() =
and
>>>>> devm_request_irq() instead of request_irq().
>>>>>
>>>>> This ensures more consistent error values and simplifies error path=
s.
>>>>>
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>> ---
>>>>>  drivers/video/da8xx-fb.c |   39 +++++++---------------------------=
-----
>>>>>  1 files changed, 7 insertions(+), 32 deletions(-)
>>>>
>>>> There's something similar in Darren's da8xx-fb series. Can you check=
 if
>>>> there are differences?
>>>>
>>> I don't see similar changes in his patch series.
>>
>> [PATCH 14/23] video: da8xx-fb: use devres
>>
> Oops missed it out :), patch is almost similar except
> for following block,
>=20
> -       fb_clk =3D clk_get(&device->dev, "fck");
> +       fb_clk =3D devm_clk_get(&device->dev, "fck");
>         if (IS_ERR(fb_clk)) {
>                 dev_err(&device->dev, "Can not get device clock\n");
> -               ret =3D -ENODEV;
> -               goto err_ioremap;
> +               return -ENODEV;
>         }
>=20
> How do you suggest to handle it ?

I think it's easiest if Darren handles the da8xx-fb series for 3.11. So
if there's something missing from Darren's series, please discuss with hi=
m.

 Tomi



------enig2DTDQJGPMUJFXVEUGNCOD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRytpYAAoJEPo9qoy8lh71L9cQAIBjuTmJZrJVRMFWyxc+fR9t
k124un5lUUxQW/5j2KpYyJi14cEuwwDwxS8pus4D9pBxOVLTR0hp8f8XKH5m3O3/
867I8aDnIrvR4DlUJcoFYW5dNy0/N+G74P/Mkh13FO0/8aNkhr0kASwuqBrIB1md
Tp1at3Gl1v5ZMl9k9WhODL+fx0X86jZj/QSXiYuDvlnCFKVJihxqZOYEp7v+I0c7
smqAiGL3kLctsWoVqesW6a1o4W6kIvtbAtiddA3V4JEvIGTuHisbIbTP2JNj1Mej
zNKNtMCZrkyB36KUX0lgVCbQsSsE0oavpPaB0vhANJTUl6wziVck4B84LwxdI5tu
eNeURD51vLbbkBgsHsZRnNMN9OWdJNYn+H4x9fY0gFuME28dF4Ro/wdKL93X6FVZ
fqSdr6YDSS0BPdsBCQ0hy4X64+XQWxLHEie1RtQAiSukpC0OuFFU0xs01rZU2fBR
u/pgE1Ly5j9DlzJ9/pcHNtNsZEHp7hdCJ2aXXYhe5lPiOImddO5nHBtX0jbMQ7ZK
Vl52JpK9GMW4i0HSk7g0XZXxmmChBoPtzN4J7JZ7dDWPUjGzF3gQzODOnvzYtalr
1issxsMF7jv+ErI/rXYhy5lDb+ZeQb4v1QhtzFxcpUtA/vpLvjLIZZnYbCOv0RjS
PuXl/aPok8PHtIjFBO7l
=0NOP
-----END PGP SIGNATURE-----

------enig2DTDQJGPMUJFXVEUGNCOD--
