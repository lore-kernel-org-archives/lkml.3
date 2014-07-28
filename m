Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaG1VWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:22:37 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:60010 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaG1VV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:21:27 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_38CDB838-17A6-4E64-8177-49F20E1B17D0"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC] readdirplus implementations: xgetdents vs dirreadahead syscalls
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20140726003859.GF20518@dastard>
Date: Mon, 28 Jul 2014 15:21:20 -0600
Cc: Zach Brown <zab@redhat.com>, Abhijith Das <adas@redhat.com>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel <cluster-devel@redhat.com>
Message-Id: <4356C960-C548-42AC-876E-106A1DAA85EE@dilger.ca>
References: <1106785262.13440918.1406308542921.JavaMail.zimbra@redhat.com> <1717400531.13456321.1406309839199.JavaMail.zimbra@redhat.com> <20140725175257.GK17798@lenny.home.zabbo.net> <20140726003859.GF20518@dastard>
To: Dave Chinner <david@fromorbit.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_38CDB838-17A6-4E64-8177-49F20E1B17D0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 25, 2014, at 6:38 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Jul 25, 2014 at 10:52:57AM -0700, Zach Brown wrote:
>> On Fri, Jul 25, 2014 at 01:37:19PM -0400, Abhijith Das wrote:
>>> Hi all,
>>>=20
>>> The topic of a readdirplus-like syscall had come up for discussion =
at last year's
>>> LSF/MM collab summit. I wrote a couple of syscalls with their GFS2 =
implementations
>>> to get at a directory's entries as well as stat() info on the =
individual inodes.
>>> I'm presenting these patches and some early test results on a =
single-node GFS2
>>> filesystem.
>>>=20
>>> 1. dirreadahead() - This patchset is very simple compared to the =
xgetdents() system
>>> call below and scales very well for large directories in GFS2. =
dirreadahead() is
>>> designed to be called prior to getdents+stat operations.
>>=20
>> Hmm.  Have you tried plumbing these read-ahead calls in under the =
normal
>> getdents() syscalls?
>=20
> The issue is not directory block readahead (which some filesystems
> like XFS already have), but issuing inode readahead during the
> getdents() syscall.
>=20
> It's the semi-random, interleaved inode IO that is being optimised
> here (i.e. queued, ordered, issued, cached), not the directory
> blocks themselves.

Sure.

> As such, why does this need to be done in the
> kernel?  This can all be done in userspace, and even hidden within
> the readdir() or ftw/ntfw() implementations themselves so it's OS,
> kernel and filesystem independent......

That assumes sorting by inode number maps to sorting by disk order.
That isn't always true.

Cheers, Andreas






--Apple-Mail=_38CDB838-17A6-4E64-8177-49F20E1B17D0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9a+0HKl2rkXzB/gAQLvOxAAt7n/Q7bS+aKEP7UDWn8ulxnZhE/hgdsm
i5xvp9zhyQRkKeJYQvQ+k5W2QbpeizHjsPyxVWRILQ0fZGODgItS23Dtf74N5LCZ
cu73fY5QZJNBDpfNmDDQGo/xiOO9FhPqEWaZZRS7Uhk8n700FwDV5Ho9h3dDhORW
4xGDyuwW+2sdT4FKerTo0NU7jcS63Efi0PdNLNvhE400tgb5YznxfjnmoAk8akvp
03W7iyuulOZYgezzaB5/YsaRKPhjGetTTodseqVyH1cQcUd/SxrpqiDNZgaqXHP7
wiJydinSoLT8VxMp4bSzCtKFQ2qqWHgQfn5Ub1MPLW+GYScBIY1HxWp6l/Rie4qi
Oc/WbmjOrrN9Hhnae1ZWzdvRtbvk4gTezpheKPSvz3QARtBJVYk9OpvOAQvkaZNm
nyDewekywUo0b5P9tDoRxGGsbPKZ3LcbZA9xUGjYTeFY9bJoOo4dQgaF1FGIFiBv
3/6RpKM75H7Xa6Quiroz0UYn768Vwl4bKFosEbsiXWPeJlskFy7c95XrYP/lxtis
zUdQNMaS+azCCr7ukG1Z5bu1MjKZPsSZsNrTHcTYsQMcvEqB6oZhQ263FV6E0fH6
oNhM6d75a1BJiPVPHV8JZvxY5iF2C2YSbUnvCDQlHtpRP8VAXrnTcGX8G/HmQrJS
N5RNEybJNmc=
=OxFG
-----END PGP SIGNATURE-----

--Apple-Mail=_38CDB838-17A6-4E64-8177-49F20E1B17D0--
