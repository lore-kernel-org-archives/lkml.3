Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981AbaISUfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:35:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:43299 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728AbaISUfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:35:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,557,1406617200"; 
   d="asc'?scan'208";a="602395665"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brian Norris" <computersforpeace@gmail.com>
Subject: Re: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Topic: [PATCH 7/7] sched: Silence nested-externs warnings
Thread-Index: AQHP1B6e1FZqApYsAUeDZBBK/84gU5wJTqGAgAAQ1oA=
Date: Fri, 19 Sep 2014 20:34:59 +0000
Message-ID: <11081C57-805A-44F8-9768-271DC6B27F76@intel.com>
References: <1411140580-20909-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <1411140580-20909-8-git-send-email-jeffrey.t.kirsher@intel.com>
 <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
In-Reply-To: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.66]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_95907DD6-03E2-4FAD-AA49-8185C35F39E0";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_95907DD6-03E2-4FAD-AA49-8185C35F39E0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 19, 2014, at 12:34 PM, Richard Weinberger =
<richard.weinberger@gmail.com> wrote:

> On Fri, Sep 19, 2014 at 5:29 PM, Jeff Kirsher
> <jeffrey.t.kirsher@intel.com> wrote:
>> From: Mark Rustad <mark.d.rustad@intel.com>
>>=20
>> Use diagnostic control macros to ignore nested-externs warnings
>> in this case.
>>=20
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Brian Norris <computersforpeace@gmail.com>
>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> ---
>> include/linux/sched.h | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5c2c885..ed52c76 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -832,7 +832,9 @@ static inline int sched_info_on(void)
>> #ifdef CONFIG_SCHEDSTATS
>>        return 1;
>> #elif defined(CONFIG_TASK_DELAY_ACCT)
>> +       DIAG_PUSH DIAG_IGNORE(nested-externs)
>>        extern int delayacct_on;
>> +       DIAG_POP
>=20
> This ridiculous, please try to move this extern into the appropriate =
header file
> instead of surrounding it with these macros.

Excellent. I'll try adding an include of delayacct.h instead. My patch =
was based on the assumption that the existing code was wanted in that =
form for some reason, so the patch served a purpose in recognizing that =
it isn't. So the macros have served a purpose before even being in =
place. :-)

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_95907DD6-03E2-4FAD-AA49-8185C35F39E0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUHJN0AAoJEDwO/+eO4+5uI/IP/R14/8QxYcwicvj8hl/kid45
HhCUUGl9NENqV130XPiv+HyKYM2Ke54uBD97Upvs/dFHrRzp1EfZmJ+7/Q6v9dvI
+sAlrTnq1jd0b5fZX4T3KNbDVD74zRFSN7Xt9tF1i1tYWLEgu23MNmgbCGkUPGIu
3Y2N3pb6I2mCHd9gRKAFlV4vHlWW/SW9M850ie1m8f5Uppl5W81ktyHId+wsq0jQ
Tollm3kdAX4FoQmk3lhhoCaPPABp4t45kM4tXt+QPQRQeYwx+cNtsKa8TWzEaIGz
4kIKL2qquSWK0bR4uI8x2ePPauBp3SQxLZQ73rLJpNPKszo2v51GPoXQZCnnOjAp
aW02p9jLKeEq09qP7S78qHS6N5NhJeP/7fHlRjAfQZWfKo8SuzMGBQ6aveAamGOB
EJhzHiySttHC74lc52EW1cXyWsfsI2903lSweOWzZK5KHxviuhuBApeF5PqewHnm
TNsZ7RawakUICKLiEoq7v+s5xfJfJ4rzXZn1X6GJR2wk0sZJ5zPuaq129xLv1g4q
63tLDInJfYryHLG5jHxR2BOHspswpoxVDuxlEDD21XDEB8aYmaMPmbzTMDIezOzY
w2LGavRO+ZBXWT357tJMaZhU/f/V8JgkGwhHQ8YLYuM8tPq4bBh/RZCMWt7OYVBU
qArMmNXK66Ed38CYF5zM
=APgt
-----END PGP SIGNATURE-----

--Apple-Mail=_95907DD6-03E2-4FAD-AA49-8185C35F39E0--
