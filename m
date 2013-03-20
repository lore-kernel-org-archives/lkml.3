Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab3CTQ70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:59:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55265 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755465Ab3CTQ7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:59:25 -0400
Message-ID: <5149EAE7.7040800@ti.com>
Date: Wed, 20 Mar 2013 18:59:19 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Alexandru Gheorghiu <gheorghiuandru@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers: video: omap2: dss: Use PTR_RET function
References: <1363680194-10404-1-git-send-email-gheorghiuandru@gmail.com> <5149A3D0.2010902@ti.com> <5149D95D.2030505@ti.com>
In-Reply-To: <5149D95D.2030505@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3DFCFFE47C963A6D568D3A58"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3DFCFFE47C963A6D568D3A58
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-03-20 17:44, Jon Hunter wrote:
>=20
> On 03/20/2013 06:56 AM, Tomi Valkeinen wrote:
>> On 2013-03-19 10:03, Alexandru Gheorghiu wrote:
>>> Use PTR_RET function instead of IS_ERR and PTR_ERR.
>>> Patch found using coccinelle.
>>>
>>> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
>>> ---
>>>  drivers/video/omap2/dss/core.c |    5 +----
>>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/omap2/dss=
/core.c
>>> index f8779d4..60cc6fe 100644
>>> --- a/drivers/video/omap2/dss/core.c
>>> +++ b/drivers/video/omap2/dss/core.c
>>> @@ -181,10 +181,7 @@ int dss_debugfs_create_file(const char *name, vo=
id (*write)(struct seq_file *))
>>>  	d =3D debugfs_create_file(name, S_IRUGO, dss_debugfs_dir,
>>>  			write, &dss_debug_fops);
>>> =20
>>> -	if (IS_ERR(d))
>>> -		return PTR_ERR(d);
>>> -
>>> -	return 0;
>>> +	return PTR_RET(d);
>>>  }
>>>  #else /* CONFIG_OMAP2_DSS_DEBUGFS */
>>>  static inline int dss_initialize_debugfs(void)
>>>
>>
>> Thanks. I'll apply to omapdss tree.
>=20
> Is this correct? If debugfs_create_file() returns a valid pointer, then=

> now dss_debugfs_create_file() will return a non-zero value on success. =
I
> don't think this is what you want. A similar case came up recently here=
 [1].

Hmm. I don't follow. And I don't understand the post where you referred.

PTR_RET is defined as:

if (IS_ERR(ptr))
        return PTR_ERR(ptr);
else
        return 0;

How's that different from the original code?

 Tomi



--------------enig3DFCFFE47C963A6D568D3A58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRSernAAoJEPo9qoy8lh71Z+UP/2p5ZVvjNTbzQUypqWowSGYo
HYPhofYLt4fIR9k79f+M2R3XxA4yn8nGl6IjpezHjEpV2u8ngOZjcEU7zY8NXX1X
pxW0KCTEOMzjRUc9CllmSERABDMLpoT0dbACvnmKZ3vj6/hYy+vapbjzmUq3OJJT
fufZpvCiUA1oVpY6yeQXB1OWcUNqJSTErDqaHdlFL93n2sydE06tPKUV69DmIco3
HoFnsPFDIFKdHeBbW7DfIXCvJlg0RM24fClmQlfl5tLtr24V4nPGWTH/vHy5KZWX
bDdhw8BLmrP8srsR3IfR1J5wJT7mmBj554aj2HeNnTLROFYl5CdxAKXdyOjruc/o
R6Lcde92s4d63H707+HlAjP/eTFfk/kZv7gx9Tbbqhx9R427xY8UdPrNnqPj+BVU
+Mb7NBdNUL3M+gCQj83bcNm9ksT39auQZ2aej71T2uDV8iH5iQrkkIpjGt2nuGpP
T0j8peqq/EfTpHbY/l1ktCFr2dmlnGPZm5FBdISIbun7bNAMAGZ0z34gb/9RRVOx
+gYXEFD67ugTxckMnjJWC5jDafO8HqOzjFSdALbnZguMno93j1K8RfpCwa/mwpKj
vGTxrr9y30RIrVBcvhouLbkKR8skRCjy0KMOzGkh/esvNjH8z8/a3ccIfNLNSqm4
pXCBVgWiZ22OSGo2DA7o
=H6B3
-----END PGP SIGNATURE-----

--------------enig3DFCFFE47C963A6D568D3A58--
