Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaGaNih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:38:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39807 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaGaNie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:38:34 -0400
Message-ID: <53DA46C3.9080905@ti.com>
Date: Thu, 31 Jul 2014 16:38:11 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dexuan Cui <decui@microsoft.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v3] video: hyperv: hyperv_fb: refresh the VM screen by
 force on VM panic
References: <1404875063-27424-1-git-send-email-decui@microsoft.com> <53D90008.4060908@ti.com> <EE124450C0AAF944A40DD71E61F878C98F6F78@SINEX14MBXC417.southpacific.corp.microsoft.com>
In-Reply-To: <EE124450C0AAF944A40DD71E61F878C98F6F78@SINEX14MBXC417.southpacific.corp.microsoft.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="eFU6cRTM9g95O9luHknJfTwWClLnX7bew"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eFU6cRTM9g95O9luHknJfTwWClLnX7bew
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 31/07/14 13:11, Dexuan Cui wrote:
>> -----Original Message-----
>> From: Tomi Valkeinen [mailto:tomi.valkeinen@ti.com]
>> Sent: Wednesday, July 30, 2014 22:24 PM
>>> +static struct fb_info *hvfb_info;
>>
>> Static variables like these are usually a no-no. This prevents you fro=
m
>> having multiple device instances.
> I agree.
>=20
>>>  static uint screen_width =3D HVFB_WIDTH;
>>>  static uint screen_height =3D HVFB_HEIGHT;
>>>  static uint screen_depth;
>>>  static uint screen_fb_size;
>>>
>>> +/* If true, the VSC notifies the VSP on every framebuffer change */
>>> +static bool synchronous_fb;
>>> +
>>
>> Same comment here.
>>
>> However, if (and only if) the driver is already designed to work only
>> with single device instance, then this patch is probably ok. But even
> IMO the host should only provide at most 1 synthetic video device to a =
VM. :-)
>=20
>> then, I'd prefer this to be handled without static variables so that t=
he
>> driver could eventually be changed to support multiple device instance=
s.
>=20
> Hi Tomi,
> Maybe we can remove these static stuff:
> +static struct fb_info *hvfb_info;
> +static struct notifier_block hvfb_panic_nb =3D {
> +	.notifier_call =3D hvfb_on_panic,
> +};
> by kmalloc()-ing  a new struct:
> struct hv_fb_panic_nb {
>         struct fb_info *hvfb_info;
>         struct notifier_block nb;
> }
> ?
> I think in hvfb_on_panic() we should be able to get the
> hvfb_info pointer by
> hvfb_info =3D container_of(nb, struct hv_fb_panic_nb, nb).
>=20
> If you like that or have a better idea, please let me know so
> I can make a new patch.

To be honest, I haven't been using notifiers much. But the above looks
ok to me.

Or maybe you can add the notifier_block and the synchronous_fb to
hvfb_par? From the notifier_block pointer you could then get hvfp_par,
and from there hvfb_info.

 Tomi



--eFU6cRTM9g95O9luHknJfTwWClLnX7bew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT2kbDAAoJEPo9qoy8lh71R0YP/3Sm2gUumDGZvNG2stmm5f8W
zzyd78zmqj4ioQ5q71d1b8K0C/Dldq3c8EHv5tMRxwYx3Bib/4UAy7AWIURqwcif
336KwpAMgweU6Gq2aUfObTulYogbXRU7RfQt7Cf/LOHGpy0Ul/o14rQZsy/Z9Da7
x86jW+WFuP4SYNNg32YPoA7U7tcBnlScbpV+XQO0mR1yn8+hgux0XfyBk3joULdV
thNk5iZEKiqncZMqgn9dQjBd3f/gSf0p+VqeM1tZeLH2Ntu9iI/ckGISWiil2dwI
xNw4qq0bVXLjIThWAcVEBwfUaUjGg3o27WBA7aV7mTFMZAiKqzeWoiQd2YKljze/
w7tE/KL+DJgZnBa+V9/ba+JlfHbeSA92MIUoeULnCCOwb8Yo8xuMUdIqP1b5LUvK
LngDoqDIlJbq+s+W8xnpHzzXkIYj/RFTpkJg/EZTfwDBoVSyz2u6gT+nOJ/o2RFm
atLZFTcvP7RyjXroy2m8cjNOWe4Bb8VNNTqWDYpVJOMAZLR1Qitp8vxgbG+3oXvJ
VIF3DhRmfeNnU5I30c8zgE5du81FvaWCAsEn8AorDDSloRncJBfZ+l0zqLuJ9l9u
u1PvzJL4j0tWAa1KWyEZ8bqHhZve6Q7nhg+UipHoLCqjAT9/iYROKnjL9rqwT4nS
5EQeIpUvQAunTM8JdFYj
=VHl0
-----END PGP SIGNATURE-----

--eFU6cRTM9g95O9luHknJfTwWClLnX7bew--
