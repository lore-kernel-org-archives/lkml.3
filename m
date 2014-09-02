Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaIBVQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:16:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:32709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755264AbaIBVQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:16:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="380510832"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] semaphore: Resolve some shadow warnings
Thread-Topic: [PATCH] semaphore: Resolve some shadow warnings
Thread-Index: AQHPwrpWo+8Yk6/5fk6utogICT4MypvsqSoAgADDWACAAWmsAA==
Date: Tue, 2 Sep 2014 21:16:23 +0000
Message-ID: <176C5670-03A7-4003-925D-9C252A7A284F@intel.com>
References: <1409228366-7027-1-git-send-email-jeffrey.t.kirsher@intel.com>
 <20140901120244.GI27892@worktop.ger.corp.intel.com>
 <1409614914.2384.3.camel@jtkirshe-mobl>
In-Reply-To: <1409614914.2384.3.camel@jtkirshe-mobl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.84]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_6EB0BEB6-4073-4EF1-8E1E-F87B19C46ED4";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_6EB0BEB6-4073-4EF1-8E1E-F87B19C46ED4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 1, 2014, at 4:41 PM, Jeff Kirsher <jeffrey.t.kirsher@intel.com> =
wrote:

> On Mon, 2014-09-01 at 14:02 +0200, Peter Zijlstra wrote:
>> On Thu, Aug 28, 2014 at 05:19:26AM -0700, Jeff Kirsher wrote:
>>> From: Mark Rustad <mark.d.rustad@intel.com>
>>>=20
>>> Resolve some shadow warnings resulting from using the name
>>> jiffies, which is a well-known global. This is not a problem
>>> of course, but it could be a trap for someone copying and
>>> pasting code, and it just makes W=3D2 a little cleaner.
>>>=20
>>> Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
>>> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>>=20
>> Why isn't Mark sending this email?
>=20
> Mark sent me several patches like this, for me to push upstream.  So, =
I
> am making sure the appropriate owner is the receives the patch versus
> blindly sending to LKML.
>=20
>>=20
>>> ---
>>> kernel/locking/semaphore.c | 12 ++++++------
>>> 1 file changed, 6 insertions(+), 6 deletions(-)
>>>=20
>>> diff --git a/kernel/locking/semaphore.c b/kernel/locking/semaphore.c
>>> index 6815171..7782dbc 100644
>>> --- a/kernel/locking/semaphore.c
>>> +++ b/kernel/locking/semaphore.c
>>> @@ -36,7 +36,7 @@
>>> static noinline void __down(struct semaphore *sem);
>>> static noinline int __down_interruptible(struct semaphore *sem);
>>> static noinline int __down_killable(struct semaphore *sem);
>>> -static noinline int __down_timeout(struct semaphore *sem, long =
jiffies);
>>> +static noinline int __down_timeout(struct semaphore *sem, long =
njiffies);
>>> static noinline void __up(struct semaphore *sem);
>>=20
>> So what's wrong with calling it "timeout" instead? That's what most
>> other sites do.
>=20
> Timeout would work as well to resolve the shadow warnings.

It would, but then it would be unclear as to what units the timeout was =
in. I have no other objection to timeout, I was just trying to preserve =
the meaning in the existing overloaded name. The "n" to me suggests a =
number and, if anything, number of jiffies conveys a more precise =
meaning than simply jiffies did.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_6EB0BEB6-4073-4EF1-8E1E-F87B19C46ED4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUBjOmAAoJEDwO/+eO4+5u1QoP/0hyqcpxV6KAPPvJmm1M4qxK
fP6+iN0wMrAylqvdfjbhf+xMp/YNrMGVWARtW7IgS3pSfZ6zCZbuTh6vgnVnd7uU
WzBUCpYIEYHYUeqfSl6MTjU78O1S23L+232SHoXjL4scpPXIMqy4ZK+p4aFm3cmw
keGcwqFwUGDaxabnNW3I5DGEq7C4dxaLPeaS3E0/BRgsZVrjaMLYU2KlcC6wCqmt
eEWV989nehoZrzYrv5QydqoaJxRQux1FzOq9ec8iVSiTh6Vv7D7mFDYuTZ5teblE
YiEJdIJszgg0nv/xl/f4vcwVt0LsyKyrteKYx+nEABrOWn+VA9Pi/D1pktT1P+dG
hUPBIDDMCKKl9mSrvIzLJ8q8A2ax3pFP8KhwG2pBnLOXYEx9qmk+fjUGLQcadkgc
VlgLj+oidU8Ou7VwbCrnmdsAxDmRO51UL/zNGOfZsRGoqEJUVmv6gw6OMZLxkryl
n953WHzWf0yJnmT8OSVv4e3CqSzPJPxyf0qgtWx5j3as5xeaJQro2SvZ3wDlmJtp
8fiUqobCKdibCk4VKPYhDL2BOIPpxEe0xh7SWo4igwPiZxIxK3PdqipouYYUqn2g
VHBHk8C9KyE5vpwWorGBse7sm+XGc1aM6jK2hACe6MhrVMz5BjmQS9cITNpyjFxt
LlfKePXnAOFbc2Qsoeiq
=2ZgG
-----END PGP SIGNATURE-----

--Apple-Mail=_6EB0BEB6-4073-4EF1-8E1E-F87B19C46ED4--
