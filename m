Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaCDTxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:53:51 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49665 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaCDTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:53:48 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Chuansheng Liu <chuansheng.liu@intel.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com
Subject: Re: [PATCH v2] usb: gadget: return the right length in ffs_epfile_io()
In-Reply-To: <20140304160620.GH15233@saruman.home>
Organization: http://mina86.com/
References: <1393918497-30916-1-git-send-email-chuansheng.liu@intel.com> <531606DB.4010601@cogentembedded.com> <20140304160620.GH15233@saruman.home>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140304:chuansheng.liu@intel.com::u7Xogq9RqWSogu1f:00000000000000000000000000000000000000Fnx
X-Hashcash: 1:20:140304:balbi@ti.com::/YrB3FKFjAkTwyk/:000000mwY
X-Hashcash: 1:20:140304:david.a.cohen@linux.intel.com::sM9js5suvzPiAPbq:000000000000000000000000000000003pxQ
X-Hashcash: 1:20:140304:linux-kernel@vger.kernel.org::+uqNIbsvp1rFqZ74:0000000000000000000000000000000005gzB
X-Hashcash: 1:20:140304:balbi@ti.com::POtz7unaJXJB+JKf:0000071et
X-Hashcash: 1:20:140304:linux-usb@vger.kernel.org::/teYK9HteZWds8JX:0000000000000000000000000000000000006Jq9
X-Hashcash: 1:20:140304:gregkh@linuxfoundation.org::slaz3gbow5gIHk9b:000000000000000000000000000000000006Cq9
X-Hashcash: 1:20:140304:sergei.shtylyov@cogentembedded.com::jpHZruyk/dJDrudt:000000000000000000000000000AhCf
Date: Tue, 04 Mar 2014 20:53:40 +0100
Message-ID: <xa1td2i14u63.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

>> On 03/04/2014 10:34 AM, Chuansheng Liu wrote:
>> >@@ -845,12 +845,14 @@ static ssize_t ffs_epfile_io(struct file *file, s=
truct ffs_io_data *io_data)
>> >  			 * we may end up with more data then user space has
>> >  			 * space for.
>> >  			 */
>> >-			ret =3D ep->status;
>> >-			if (io_data->read && ret > 0 &&
>> >-			    unlikely(copy_to_user(io_data->buf, data,
>> >-						  min_t(size_t, ret,
>> >-						  io_data->len))))
>> >-				ret =3D -EFAULT;
>> >+				ret =3D ep->status;

On Tue, Mar 04 2014, Felipe Balbi wrote:
>>    Why the indentation jumped suddenly to the right?

> On Tue, Mar 04, 2014 at 08:01:15PM +0300, Sergei Shtylyov wrote:
> because it was wrong before ;-)

Yep.  It looks like Robert's [2e4c7553: add aio support] introduced an
if-else-if-else flow but did not indent the code and I didn't caught it
when reviewing that patch.

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

iQIcBAEBAgAGBQJTFi9EAAoJECBgQBJQdR/068QP/1OFzs+gxPOdsHT//MyEbB9r
AVUcuOWS6+O/OKk8wojvL/YWpduLDlDgEMF5H09LK+XjZWKlZgcGtAZlqcUK+J87
rhB2jf1413afjdpBCdeSHVlaND0zPgCJzhtTY+yH+F3RxYis+5/TklGTk1KTrGDK
a+VY3ZtzLtikwuTz86PoYUVqhTb2QdK6Dt+Zl+PaVyeovZGdsizxj/WyYprNzG6y
F4IDrym0yM4D215issUw+yu36/KLWDrclld0qk/6E2aPSooQq0kh/9Jg/5+17RRN
5ZL8uAwDWsqsYbuha1MWhaL1cJ+knN1TJBy79ClmL+ZquDZghyKUZGQeXxaqC2OD
APYO8ibErjRHsUAGZzwUM/zuM58T+gC+KQewl+dndfyMWK6DIpQ9Ug1lxRACYVY0
wXjTBqqOchTiqjNouLHATYx1luc3xN4lediuYoaKRRwKxU9F86k2IoiAeP+ZRa4W
omlm2AB5cAB2Dt5oasL5Rk/EJL8CppJdg5xP3+eFZvxLdOiC3ptx0+snl+E2cUfC
GlR7RDZqn+zBrgmS2dFE1OiXmdHErOAKEUBELnGcBrBdiOlh0oQ5BTVGI4RDvh+4
KweyPGbWVYu/TToAk+oOjn5ENFVaLbE0l4J6wlR9MNMugUtq6gW8nlgzigGErg11
NYqj9OowpEp5AAUn7Qje
=9E2j
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
