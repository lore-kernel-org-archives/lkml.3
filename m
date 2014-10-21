Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaJVB2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 21:28:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:61975 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbaJVB2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 21:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,764,1406617200"; 
   d="asc'?scan'208";a="618041189"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/sysctl: Resolve missing-field-initializers
 warnings
Thread-Topic: [PATCH] kernel/sysctl: Resolve missing-field-initializers
 warnings
Thread-Index: AQHP56PEt3kx/A+vRUGQ12eDG0yXvpw2mxwrgATPZICAABhmgA==
Date: Tue, 21 Oct 2014 20:34:32 +0000
Message-ID: <F4A50114-6182-4448-A9E7-B0D68A6F615A@intel.com>
References: <1413286868-21870-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <87a94szydt.fsf@x220.int.ebiederm.org>
 <20141021120711.0ddb53adb4fdecf241826473@linux-foundation.org>
In-Reply-To: <20141021120711.0ddb53adb4fdecf241826473@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_EAF71888-35FD-4BB3-9E16-7E84958625A5";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_EAF71888-35FD-4BB3-9E16-7E84958625A5
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Oct 21, 2014, at 12:07 PM, Andrew Morton <akpm@linux-foundation.org> =
wrote:

> On Sat, 18 Oct 2014 17:39:10 -0700 ebiederm@xmission.com (Eric W. =
Biederman) wrote:
>=20
>> Jeff Kirsher <jeffrey.t.kirsher@intel.com> writes:
>>=20
>>> From: Mark Rustad <mark.d.rustad@intel.com>
>>>=20
>>> Resolve missing-field-initializers warnings in W=3D2 builds by
>>> using designated initialization.
>>=20
>> ick.  No.
>>=20
>> That gcc warning makes no sense.  In this case heeding it makes the =
code
>> significantly uglier and significantly more confusing.
>>=20
>=20
> Yeah, it's not pretty.
>=20
>>> --- a/kernel/sysctl.c
>>> +++ b/kernel/sysctl.c
>>> @@ -257,7 +257,7 @@ static struct ctl_table sysctl_base_table[] =3D =
{
>>> 		.mode		=3D 0555,
>>> 		.child		=3D dev_table,
>>> 	},
>>> -	{ }
>>> +	{ .procname =3D NULL }
>>> };
>=20
> We use { } to mean "all zero" in 12 squillion places.  Do they all =
warn
> or is there something special about this site?

Well, about 6 squillion of them are { }, a GCC extension, and the other =
6 squillion are { 0 }. Both forms generate the warning. There is nothing =
special about this site. I just was resolving warnings in order to find =
some that had some significance. A flood of 125,000 warnings is too =
awful to look at. I got it down to around 1,500 and did find a few =
hazards and sent patches to address them, which have been accepted in =
one form or another.

I had sent patches to add diagnostic control macros to allow a warning =
to be turned off for a range of code. I would have liked to use them to =
provide something like a ZERO_ENTRY macro that would have looked =
something like this:

#define ZERO_ENTRY DIAG_PUSH DIAG_IGNORE(missing-field-initializers) { 0 =
} DIAG_POP

which would have provided a standard way to get a zero entry that would =
have avoided the warnings. Borislav was quite opposed to the notion of =
diagnostic control macros. I rather like the notion as long as their use =
is tightly controlled.

I'm sure that we both feel that there should be a form that the compiler =
does not generate this warning for as a preferred solution. The =
designated initialization is at best a 3rd-best solution, though naming =
the field used to identify the end of the table is not a bad thing =
either.

I do like enabling lots of additional warnings to find problems in code, =
but when it results in such a flood of messages it is not a very useful =
approach, hence my tendency to want to address them somehow, so that =
meaningful ones can be noticed.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_EAF71888-35FD-4BB3-9E16-7E84958625A5
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJURsNYAAoJEDwO/+eO4+5u1i4P/Rnz1/JXrNQ7Yq2BgFPZzPbV
w8TmNBsv9EEiBhdd6H7l7GN0bzsrtVCjd+brFkl9GDlLPoCJaKNjqq1VluaiIzXi
vFqTiV2GDgiDanibbWFpI0OhPUxnkFgBSsrD4dJ08JHWMXJLud5iDsrrdXtGVjI7
vF4iwHicognd8m5s9Zn7K0C1F0tdkpczLOInxU4LxgYT7u1JO2kz7Ap3zXcfDG0r
wQnpLP9KvN0luIVkM36ZaTAQU0MMW+7XVxU+zKTiSM4Ox4D5dPBzwARs5EpD+hMN
7Mx/arD7tc6SskDgABMWNSbSzPDEBjWfl0PW0ylEzEr+yjnSz0QS3FHNmFa5oiq+
PtZx00xBR7k/tij/YJOkFtbLTKCSM1+iTqUC2S37+KqhZvdTaYpYl2P9NNSGITp+
mIdIodbchAG4xOuK5iFSN9zQDpNOgb9RPbnA0by64c432W8k8tNHQH5d5x/u2dYZ
PjueCf80QKwveFnj/VQeyCKIpIDzKVu3sdIyllNeAdtzLobI/JzpGLTRaQoxW1kk
a7DxVYFTPCEOm2D+8YZz78pR/WMsGqa6LhteERsF50/ZBQR6oOMjOyvy7JptUy0f
0IScIGTS1dUF8HqwqPPi2TCZ+Xt/14kbmI9xrdnU3PK6ozXQ9YossxqeuXeThVLq
Eu+XU9dpjmyAXn2923+k
=NGll
-----END PGP SIGNATURE-----

--Apple-Mail=_EAF71888-35FD-4BB3-9E16-7E84958625A5--
