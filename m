Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbaEMWjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:39:19 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:48525 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaEMWjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:39:09 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>,
        Jan Kara <jack@suse.cz>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] fanotify: check file flags passed in fanotify_init
In-Reply-To: Your message of "Tue, 13 May 2014 19:34:33 +0200."
             <537257A9.3070504@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <1399921336-6433-1-git-send-email-xypron.glpk@gmx.de> <CAKgNAkjd=faKp8-QroLHXDOk00tKYxvAzm0xZV4PjYLNO+3_Ew@mail.gmail.com> <5372535B.5030503@gmx.de>
            <537257A9.3070504@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1400020724_2034P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 13 May 2014 18:38:44 -0400
Message-ID: <77399.1400020724@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1400020724_2034P
Content-Type: text/plain; charset=us-ascii

On Tue, 13 May 2014 19:34:33 +0200, "Michael Kerrisk (man-pages)" said:

> >> The 'switch' could just be replaced by:
> >>
> >> if ((event_f_flags & O_ACCMODE) == 3)
> >>          return -EINVAL;
> >>
> >> (But I'm not sure if some might prefer the idiom you have used.)
> >>
> >> Cheers,
> >>
> >> Michael
> >
> > Using explicit numbers makes the code hard to read and analyze.
> > I do not intend to participate in the Obfuscated C Code Contest.
>
> I agree that using explicit numbers is odd, but '3" in this
> context does have a special meaning (see open(2)), and it struck
> me as a more efficient way of doing the check. But, if others
> are fine with what you've written, I have no real problem with it.

I'd be OK with the '== 3' version if there was a comment about the
reserved access mode like:

	/* reserved ioctl-only mode, so no fanotify for you */
	if ((event_f_flags & O_ACCMODE) == 3)
		return -EINVAL;

--==_Exmh_1400020724_2034P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU3Ke9AdmEQWDXROgAQK9RxAAi/qkKv7kbyEGLqmOfFU1ylDaFnPm3wEE
Dz54X4kWHUsOqNXmzP0mVww8bzIX5EPDGvIUvoS2mFtez8IIQLo1fd/qZXNYbIgo
keTurRvGVjvdsPolvkEHZNbulYfKA/BcsJAFttpjlED/7dC6c7xJSTsQjumOpRH+
WiBJqmMgtt0/h8W5f5Bt++D149Y2Imj4cHs9yJTqLtNHpcjwWQmdl5VQmT6Wx2Sa
cGZ+6Pa+hpOmYeofX/yE92dXoRlKzxLIrxr/iET1PXCf7ebp30MEvn9iWjchdQ+v
lBVag88NnMuW0hKP2igVP2LENJmfVl0BCypLnM+ShMugV+PthAiiyS0f/D24x51j
/usRVXpfaNizxwS0wTAKTTUEaHqKfqONcb88BsEAdqpCj9u5rPD8By+LBPZIZtwp
3/31v6ACxrpEAg+zumvuRDfA0v6vxhfrN4DbfrH+7tu+F0PQXUlPaJOGyaAPuf4G
nY/5y9Yh2LHUf4tGMXyWJv1AHhc1MNNT4dFOgS+kmMTVj0p2l2eeTZVvdZ3m/B9p
mAOuC6HGMJGMKJeCiQuUwYL59HKM3tQPDRaP1tAU+J6mUXnPCnBZkxQsNPO+kI6t
jfo57qDvM3Q+OGickZwXRPLfDSrrBi06dPDgZ5x3+Sm1akGgEvRVs0DkLqDurty8
g5LT4+c9rFU=
=dpGx
-----END PGP SIGNATURE-----

--==_Exmh_1400020724_2034P--
