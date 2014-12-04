Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaLDH4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:56:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:48297 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaLDH4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:56:38 -0500
Message-ID: <548013B0.4080108@ti.com>
Date: Thu, 4 Dec 2014 09:56:32 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com> <547EF8CC.9030502@ti.com> <CA+V-a8vnv4B77XvbzwNkJk=vqGCFWoXxFoyUf0ZNiKwa+gY2ug@mail.gmail.com> <548007CA.7010900@ti.com> <20141204074641.GB4311@sudip-PC>
In-Reply-To: <20141204074641.GB4311@sudip-PC>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="8iEkgqnVptv4nKeTns12iLPI1OlDNhx32"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8iEkgqnVptv4nKeTns12iLPI1OlDNhx32
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/12/14 09:46, Sudip Mukherjee wrote:
> On Thu, Dec 04, 2014 at 09:05:46AM +0200, Tomi Valkeinen wrote:
>> On 03/12/14 20:29, Prabhakar Lad wrote:
>>> On Wed, Dec 3, 2014 at 11:49 AM, Tomi Valkeinen <tomi.valkeinen@ti.co=
m> wrote:
>>>> On 27/11/14 00:07, Lad, Prabhakar wrote:
>>>>> this patch fixes following build warning:
>>>>> drivers/video/fbdev/vt8623fb.c: In function =E2=80=98vt8623_pci_pro=
be=E2=80=99:
>>>>> drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer fro=
m integer of different size [-Wint-to-pointer-cast]
>>>>>   par->state.vgabase =3D (void __iomem *) vga_res.start;
>>>>>                        ^
>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>> ---
>>>>>  drivers/video/fbdev/vt8623fb.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev/v=
t8623fb.c
>>>>> index 5c7cbc6..ea7f056 100644
>>>>> --- a/drivers/video/fbdev/vt8623fb.c
>>>>> +++ b/drivers/video/fbdev/vt8623fb.c
>>>>> @@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *dev=
, const struct pci_device_id *id)
>>>>>
>>>>>       pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
>>>>>
>>>>> -     par->state.vgabase =3D (void __iomem *) vga_res.start;
>>>>> +     par->state.vgabase =3D (void __iomem *) (unsigned long) vga_r=
es.start;
>>>>
>>>> This does look quite ugly... Where does the warning come from in the=

>>>> first place. Isn't vga_res.start (resource_size_t) the size of a poi=
nter?
>>>>
>>> Yes looks ugly, I am not sure what you meant from 'where does this wa=
rning
>>> come from' its in the commit message.
>>
>> I meant why is there a warning at all. With a quick glance,
>> vga_res.start is the size of a pointer. So the sizes of the integer an=
d
>> the pointer should be the same. But the warning still says "of differe=
nt
>> size".
>=20
> poking my nose into your discussion.
> I tried to see the warning, and I re-compiled like make W=3D1 M=3Ddrive=
rs/video/fbdev/ (before that make clean M=3Ddrivers/video/fbdev was done)=

> I can see warning with many other files, but drivers/video/fbdev/vt8623=
fb.o was quiet and there was no warning.
> I tested with next=3D20141203.
> did i miss something in checking the warning ?

I don't see the warning either when compiling for arm or x86_64. On what
architecture do you see the warning?

 Tomi



--8iEkgqnVptv4nKeTns12iLPI1OlDNhx32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgBOwAAoJEPo9qoy8lh71viwP/2E6cesNrRrALzE3315MYc+m
bHh6h6RnRTw4jqvD76QeeNNRV+J+fPE+7v8J/dtUTzv+943dxvJX4yBKWL7v9OFr
qI1xi0VkgEO8eAhsaR7gCLw+T3+znHA79vn2ex1hyYJijG5l+YWGRkukadoHu6xF
qyGNrRxip8e/xCSzcLeccrGj81AE3Y9uqz/YKLnwpieZWMFmoB1cWCMjBwKk+/Ym
oPNHhyJnjRkCmJRvZp0wzXy6PsDt/wFf9Wja9EEs1HiDE7atHUtGtx2XF9mZ3299
+HF+OKXI/rIIq9a+TLYfXZlUmi6gQXJsXjQlw2gAGah840+UtSur6OnYWoRcGxra
mfjLOAK8kWE5B+CedUrJ8EQVxpEYm0IM5IKsoGnZoM5ByzhHGIuue16PPVozDHIn
7TRUL4A24VGq3yp+LQCrfAPC5PYMkb7VfQcEombDRxGl5x/HBEmcTJTjsV6hLiGn
FoMSDGsB3EvAa8yTDF7qv5DwlMQGbYkqzpKRTb1ZCW0o2J0PktZvLpDWZy6YPkZz
thksamxXRfmH+rudnjNQ4Zo1WbRWIm5qkA7uTINVyzaW3VRIWiTuiPreU46DNUUW
IeYWjUqFF/sbCivd2WZc++xCY0+koG3/Y21MvoKCUv0icmdR8AHDgEOW0uXTC6Yc
245nuKYpF0MHz6JbwWyq
=DTY6
-----END PGP SIGNATURE-----

--8iEkgqnVptv4nKeTns12iLPI1OlDNhx32--
