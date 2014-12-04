Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaLDNlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:41:04 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:35242 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLDNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:41:03 -0500
Message-ID: <54806463.5040409@ti.com>
Date: Thu, 4 Dec 2014 15:40:51 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        LFBDEV <linux-fbdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] video: fbdev: vt8623fb: suppress build warning
References: <1417039645-5313-1-git-send-email-prabhakar.csengg@gmail.com>	<547EF8CC.9030502@ti.com>	<CA+V-a8vnv4B77XvbzwNkJk=vqGCFWoXxFoyUf0ZNiKwa+gY2ug@mail.gmail.com>	<548007CA.7010900@ti.com>	<20141204074641.GB4311@sudip-PC>	<548013B0.4080108@ti.com> <CAMuHMdX6rbaPYFpSR7nGf6Di0G=cGL9yFZLLpjUDi7TLyu1wmw@mail.gmail.com>
In-Reply-To: <CAMuHMdX6rbaPYFpSR7nGf6Di0G=cGL9yFZLLpjUDi7TLyu1wmw@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="NsbF5ITsVQRmFFKbXk2qEQJ4mLUJCQqxa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NsbF5ITsVQRmFFKbXk2qEQJ4mLUJCQqxa
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/12/14 15:29, Geert Uytterhoeven wrote:
> On Thu, Dec 4, 2014 at 8:56 AM, Tomi Valkeinen <tomi.valkeinen@ti.com> =
wrote:
>> On 04/12/14 09:46, Sudip Mukherjee wrote:
>>> On Thu, Dec 04, 2014 at 09:05:46AM +0200, Tomi Valkeinen wrote:
>>>> On 03/12/14 20:29, Prabhakar Lad wrote:
>>>>> On Wed, Dec 3, 2014 at 11:49 AM, Tomi Valkeinen <tomi.valkeinen@ti.=
com> wrote:
>>>>>> On 27/11/14 00:07, Lad, Prabhakar wrote:
>>>>>>> this patch fixes following build warning:
>>>>>>> drivers/video/fbdev/vt8623fb.c: In function =E2=80=98vt8623_pci_p=
robe=E2=80=99:
>>>>>>> drivers/video/fbdev/vt8623fb.c:734:23: warning: cast to pointer f=
rom integer of different size [-Wint-to-pointer-cast]
>>>>>>>   par->state.vgabase =3D (void __iomem *) vga_res.start;
>>>>>>>                        ^
>>>>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>>> ---
>>>>>>>  drivers/video/fbdev/vt8623fb.c | 2 +-
>>>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/drivers/video/fbdev/vt8623fb.c b/drivers/video/fbdev=
/vt8623fb.c
>>>>>>> index 5c7cbc6..ea7f056 100644
>>>>>>> --- a/drivers/video/fbdev/vt8623fb.c
>>>>>>> +++ b/drivers/video/fbdev/vt8623fb.c
>>>>>>> @@ -731,7 +731,7 @@ static int vt8623_pci_probe(struct pci_dev *d=
ev, const struct pci_device_id *id)
>>>>>>>
>>>>>>>       pcibios_bus_to_resource(dev->bus, &vga_res, &bus_reg);
>>>>>>>
>>>>>>> -     par->state.vgabase =3D (void __iomem *) vga_res.start;
>>>>>>> +     par->state.vgabase =3D (void __iomem *) (unsigned long) vga=
_res.start;
>>>>>>
>>>>>> This does look quite ugly... Where does the warning come from in t=
he
>>>>>> first place. Isn't vga_res.start (resource_size_t) the size of a p=
ointer?
>>>>>>
>>>>> Yes looks ugly, I am not sure what you meant from 'where does this =
warning
>>>>> come from' its in the commit message.
>>>>
>>>> I meant why is there a warning at all. With a quick glance,
>>>> vga_res.start is the size of a pointer. So the sizes of the integer =
and
>>>> the pointer should be the same. But the warning still says "of diffe=
rent
>>>> size".
>>>
>>> poking my nose into your discussion.
>>> I tried to see the warning, and I re-compiled like make W=3D1 M=3Ddri=
vers/video/fbdev/ (before that make clean M=3Ddrivers/video/fbdev was don=
e)
>>> I can see warning with many other files, but drivers/video/fbdev/vt86=
23fb.o was quiet and there was no warning.
>>> I tested with next=3D20141203.
>>> did i miss something in checking the warning ?
>>
>> I don't see the warning either when compiling for arm or x86_64. On wh=
at
>> architecture do you see the warning?
>=20
> On 32-bit systems with PHYS_ADDR_T_64BIT=3Dy, resource_size_t is u64,
> while pointers are still 32-bit.

Ah, I see. Yes, I can reproduce the warning with that config.

So, still rather ugly, but looks correct to me, so I'll apply the series.=


 Tomi



--NsbF5ITsVQRmFFKbXk2qEQJ4mLUJCQqxa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgGRjAAoJEPo9qoy8lh71A9IP/1PK9qkl/Ga8bULBmYAU7IAe
PiLRUxylPKeEfGoNPVVVdfp3DI/8Sq0zUAcDM6mXjAjHqPpS4o16j4apBFgeWoyM
+hU4bhGHOAS5KqqdYOU13mNUnCCxHl3lp56SgvgwwXNn3ohupRO5QwT72XTlD61p
sHds4nHfyatsjqKKk2Xuf+d67z02IDXyuFGE3MdFDxzvO4u1hMQRvIJuxUQrXgRn
UbqgDWZLaJAlFQgFfeMYaq4ClftOzkmonf1KjjNlXi+h279Cm9J17Rujom7TkGWN
fT7Z31d16mIbdZ4S5eZ6ws2uWmqPevxZQ6/RoZIG9J1JrY9kM4hC44Kw6EwcwLud
ifcpmQEV3hi0pR7tne24f8+wMfQtJZXUL9ZpnD2rrutyXPi443yg2+UzGUcembgb
UY6zfY72gXpBXi+ezm39d28pH66QAM23hcUVUEa+/30/RLPuQt/1FBYGSvDdARRB
BysuRhfuUnxeg06SUQewUFAFZU4fhXotB8SEQKezmfkF8px19bHVbcI8fl6pm2Wp
8W3yKG+9WU1iF4Tb46DJHUKipTCBkOpP/MukESppJERmsJLzlSrIoD+d5/S/NUMR
7UH/fp+cyrLf1mmw8ZH2Y7Oy8/EIb6L4j3Zsy2Z/SGMHQXu/a/NS9mupZL60Hrs4
cgwtB2rSjvC/0k+T6Ohw
=nbOq
-----END PGP SIGNATURE-----

--NsbF5ITsVQRmFFKbXk2qEQJ4mLUJCQqxa--
