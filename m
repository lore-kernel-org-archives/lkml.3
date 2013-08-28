Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3H1IGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 04:06:54 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61525 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab3H1IGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:06:50 -0400
Message-ID: <521DAF3C.9030201@imgtec.com>
Date: Wed, 28 Aug 2013 09:05:16 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mike Turquette <mturquette@linaro.org>,
        =?UTF-8?B?U8O2cmVuIEJyaW5rbWFu?= =?UTF-8?B?bg==?= 
	<soren.brinkmann@xilinx.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the clk tree with Linus' tree
References: <20130827190304.c3f2f891f20d078d66b703b1@canb.auug.org.au> <521C7AF0.1020903@imgtec.com> <20f57100-4440-4353-9c84-6e5781f7c6d3@DB9EHSMHS025.ehs.local> <20130827165319.8231.9@quantum> <20130828100431.3005d52d77c565c241399269@canb.auug.org.au> <20130828172225.97f295645c9de0bbd2979fcd@canb.auug.org.au>
In-Reply-To: <20130828172225.97f295645c9de0bbd2979fcd@canb.auug.org.au>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="kiWfljf2Nm0IqQG0XnVofrBhOpnf1OR7H"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_08_28_09_06_45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kiWfljf2Nm0IqQG0XnVofrBhOpnf1OR7H
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Stephen

On 28/08/13 08:22, Stephen Rothwell wrote:
> On Wed, 28 Aug 2013 10:04:31 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
>> >
>> > On Tue, 27 Aug 2013 09:53:19 -0700 Mike Turquette <mturquette@linaro=
=2Eorg> wrote:
>>> > >
>>> > > Quoting S=C3=B6ren Brinkmann (2013-08-27 08:44:11)
>>>> > > > On Tue, Aug 27, 2013 at 11:09:52AM +0100, James Hogan wrote:
>>>>> > > > > On 27/08/13 10:03, Stephen Rothwell wrote:
>>>>>> > > > > > Hi Mike,
>>>>>> > > > > >=20
>>>>>> > > > > > Today's linux-next merge of the clk tree got a conflict =
in
>>>>>> > > > > > drivers/clk/zynq/clkc.c between commits 252957cc3a2d ("c=
lk/zynq/clkc: Add
>>>>>> > > > > > dedicated spinlock for the SWDT") and 765b7d4c4cb3
>>>>>> > > > > > ("clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to etherne=
t muxes") from
>>>>>> > > > > > Linus' tree and commit 819c1de344c5 ("clk: add CLK_SET_R=
ATE_NO_REPARENT
>>>>>> > > > > > flag") from the clk tree.
>>>>>> > > > > >=20
>>>>>> > > > > > I fixed it up (see below and in a couple of places I cho=
se
>>>>>> > > > > > CLK_SET_RATE_NO_REPARENT over CLK_SET_RATE_PARENT, which=
 may, of course,
>>>>>> > > > > > be wrong) and can carry the fix as necessary (no action =
is required).
>>>>> > > > >=20
>>>>> > > > > The case you mentioned looks correct to me.
>>>>> > > > >=20
>>>>> > > > > I can't see todays -next yet, but if by "choose CLK_SET_RAT=
E_NO_REPARENT
>>>>> > > > > over CLK_SET_RATE_PARENT" you mean one branch adds CLK_SET_=
RATE_PARENT,
>>>>> > > > > clk-next adds CLK_SET_RATE_NO_REPARENT, and the resolution =
ends up with
>>>>> > > > > only CLK_SET_RATE_NOREPARENT then that sounds wrong, as the=
 two flags
>>>>> > > > > are orthogonal.
>>>> > > >=20
>>>> > > > I can just agree, the case included in the mail looks correct,=
 but in
>>>> > > > case of other conflicts both flags should be set. Just like in=
 the case
>>>> > > > shown here.
>>> > >=20
>>> > > Stephen's fix is correct. The Zynq patches came in as fixes so I =
think
>>> > > this will be a rare event.
>> >=20
>> > Can you guys discuss this and come up with a single answer.  I read =
the above as:
>> >=20
>> > (for the two places I used CLK_SET_RATE_NO_REPARENT where the two
>> > branches each added that and CLK_SET_RATE_NOREPARENT respectively)
>> >=20
>> > "Stephen was wrong"
>> > "Stephen should have taken both"
>> > "Stephen was right"
>> >=20
>> > :-)

:-)

I think the 3 way diff omitting hunks where once branch's changes are
discarded might have confused us, even though you mentioned that there
were other conflicts (I only twigged why I couldn't see them after
seeing your new resolution).

>> >=20
>> > I can fix up my merge resolution if you tell me the correct fix.  Al=
so,
>> > you will need to know so that you can tell Linus (or whoever else ha=
s to
>> > resolve these conflicts).
> OK, I thought about it some more and the resolution now looks like
> below.  Is this correct/better?

It looks correct to me now.

Thanks
James


--kiWfljf2Nm0IqQG0XnVofrBhOpnf1OR7H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIbBAEBAgAGBQJSHa9CAAoJEKHZs+irPybfZMIP+OYlM1bc2XWXTohjN6EG76Kq
59JfzMVdiTa2Mcf834TaWlcTMBb1JEbMe3v6THvKZoM25ugkkQymxfkeu9DClrCE
oXLd01FuPTS01VaSnRrumPUKSSQZVi1eoGi5zTc20Hd+fDHdc/ZuIpLHedqW19Du
qqBxItlobYstR7iag/gLVhqG1LJUF4/b/tTaUo5zzIpHV06lM0svqWGJOF6LZjXP
R2p+Arw6s1x8aZ5QGQq3/qXV9EyZmBAHVUOH1Vv4l21ZJOWB9kf2BVZ+zqLHhnRu
e6RR8ajfVMOfnmYbHzgJJ7/EcPaM5YAIVp23z1Ak39I6wdf0LboaMSTlDKkq2Qyj
FVOslYj2DLB29qYSlpZCVQ+gp008WMZTSW5ntvllPjt6AMsQvRqh+Jgf3oIxzHte
+xK1PypqmX+ZUNxRL8IOOnuSMZdMaOG62t2fapXxMo51tDmuFFlGPMDNjItIWfSN
fLKpw/smUtGgEs18xTYp/yniFjx6JFfc3LC5/3Y4ilGmvdBj1E1jhkm5KgaSxpzJ
9+XDe3BeaR7r+VoDtimzQJ1X9eCRDOuTBaJm5/hQ+vWwOMf/HADhqy5XIj9gC1vk
lK7zfp9H60FXKMZtvsT6+I1KRWRn8XXFyc8j3BYYbzl9kDd6BZL2cEYOkfHyKysV
PR9cf3wVcsviHQRqniM=
=Rdd2
-----END PGP SIGNATURE-----

--kiWfljf2Nm0IqQG0XnVofrBhOpnf1OR7H--

