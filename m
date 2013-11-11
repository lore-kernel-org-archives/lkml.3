Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3KKVKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 16:10:09 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:61121 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab3KKVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 16:10:04 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Cohen <david.a.cohen@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] check quirk to pad epout buf size when not aligned to maxpacketsize
In-Reply-To: <Pine.LNX.4.44L0.1311111517160.17105-100000@netrider.rowland.org>
Organization: http://mina86.com/
References: <Pine.LNX.4.44L0.1311111517160.17105-100000@netrider.rowland.org>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::RxZYzJjZw9TTOksF:0000000000000000000000000000000000+74
X-Hashcash: 1:20:131111:david.a.cohen@linux.intel.com::bCM4cpJWli89TdCz:000000000000000000000000000000001uYn
X-Hashcash: 1:20:131111:stern@rowland.harvard.edu::CH2aoKdhHwV9Pnx+:00000000000000000000000000000000000046pm
X-Hashcash: 1:20:131111:linux-usb@vger.kernel.org::BMusmt38edwRytoZ:0000000000000000000000000000000000005ooQ
Date: Mon, 11 Nov 2013 22:09:55 +0100
Message-ID: <xa1thabiy7a4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, Alan Stern wrote:
> On Mon, 11 Nov 2013, Michal Nazarewicz wrote:
>
>> Check gadget.quirk_ep_out_aligned_size to decide if buffer size requires
>> to be aligned to maxpacketsize of an out endpoint.  ffs_epfile_io() needs
>> to pad epout buffer to match above condition if quirk is found.
>>=20
>> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
>
> I think this is still wrong.
>
>> @@ -824,7 +832,7 @@ static ssize_t ffs_epfile_io(struct file *file,
>>  		req->context  =3D &done;
>>  		req->complete =3D ffs_epfile_io_complete;
>>  		req->buf      =3D data;
>> -		req->length   =3D len;
>> +		req->length   =3D data_len;
>
> IIUC, req->length should still be set to len, not to data_len.
>
>>=20=20
>>  		ret =3D usb_ep_queue(ep->ep, req, GFP_ATOMIC);
>>=20=20
>> @@ -836,9 +844,16 @@ static ssize_t ffs_epfile_io(struct file *file,
>>  			ret =3D -EINTR;
>>  			usb_ep_dequeue(ep->ep, req);
>>  		} else {
>> +			/*
>> +			 * XXX We may end up silently droping data here.
>> +			 * Since data_len (i.e. req->length) may be bigger
>> +			 * than len (after being rounded up to maxpacketsize),
>> +			 * we may end up with more data then user space has
>> +			 * space for.
>> +			 */
>
> Then this will never come up.  If the host sends a packet that's too=20
> long, you'll get a -EOVERFLOW error.
>
>>  			ret =3D ep->status;
>>  			if (read && ret > 0 &&
>> -			    unlikely(copy_to_user(buf, data, ret)))
>> +			    unlikely(copy_to_user(buf, data, min(ret, len))))
>>  				ret =3D -EFAULT;
>>  		}
>>  	}
>
> The reason for the quirk is that the controller may write all the=20
> incoming data to the buffer, even if this is more data than the driver=20
> requested.

If that's the case, then it indeed solves the problem of silently
throwing away data.  I guess it makes more sense then my understanding
of the quirk.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSgUejAAoJECBgQBJQdR/0w2QP/0U6N6qaVn8fqTF3YgWEMf3j
bBh2w57EQLYaNc6PAVNWa+iM52upsCxNkYCuID8COfQQ/05hoVhOLv4E9bjsMvOf
yBUMSN2R4XR7v4+CeHtEnHqfbT7VsCFYaY04b6AW9s3t9gX7jMjRbgl3/oMRJF78
KW41D+baWaxGRr1ToeoCfV1iyEnhODh/aZuu13Dhd1NVre9QS5vBStnAykHJ986b
Je7Z25P362OwE0Ah2CWFV5Anm8n9LJGRTcURZzr4I+2kwdoeVxp0bnO/ErWnH/i6
s8cS/2fIT8kysghKsTBoS2NNFQ1BP+uPdi1FvsdxUIak+QagfLu5tpVFO3JZJRMO
kqbELlGYkug34c7yND8LfCRorh8sml2eGNr4+ldLcwPGBJgLA8P7LDOCnC53fDRg
C7oc3WsAgRffagI3C249MEH9ie+T1aNDnDOIXe2k0nlpBeH1MMC+ewhw2W7tK9Hu
ZIy/IPnbAKn4KahUYDBXxAqEmpe43ekFAP5cOmJDFYP3eirBZrVqDjPDantDDj4q
4j3FaAfDMvTvQkRFdTe5TUnDLMMM075Uy++pCbQoImwqdLVDL48FK9FdhfZxVidQ
YNK9FrdAMEYmbjjNhXw7R3CrsnpgbVze9h7mKIE+FW9ymRJSRv39OKyMhidhrR83
/vfm2BlC4RrSZ06O08VD
=+JuY
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
