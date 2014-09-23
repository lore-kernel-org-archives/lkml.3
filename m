Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaIWRhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:37:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:43993 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbaIWRhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,581,1406617200"; 
   d="asc'?scan'208";a="604166619"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] Silence even more W=2 warnings
Thread-Topic: [PATCH 0/7] Silence even more W=2 warnings
Thread-Index: AQHP1B6ZqT8VjyQkzkipcFe03W/rTpwNwlkAgAAZ2ACAABpfgIAABS8AgAAGSQCAAAZEgIAAA7mAgAADVoCAAAa4AIAAFZkAgACwXoCAAJd/AA==
Date: Tue, 23 Sep 2014 17:24:22 +0000
Message-ID: <029E2CFB-C001-4E16-B1F7-A3FB193E3138@intel.com>
References: <20140922153355.GB4510@pd.tnic>
 <AEF1C0F7-239C-436B-97A5-6AFF49FD9359@intel.com>
 <20140922184049.GB4709@pd.tnic>
 <3199350A-89CE-4BE7-8FE4-CA8CE4F87622@intel.com>
 <20140922192152.GD4709@pd.tnic>
 <1411415057.2513.8.camel@jtkirshe-mobl.jf.intel.com>
 <20140922195737.GE4709@pd.tnic>
 <1411416573.2513.19.camel@jtkirshe-mobl.jf.intel.com>
 <20140922203336.GF4709@pd.tnic>
 <A05C31E6-7AD2-482A-B590-A5ED57D028B3@intel.com>
 <20140923082209.GB22072@pd.tnic>
In-Reply-To: <20140923082209.GB22072@pd.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.72]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_8F870727-F916-4FA5-9497-2AD28BAA004B";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_8F870727-F916-4FA5-9497-2AD28BAA004B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii

On Sep 23, 2014, at 1:22 AM, Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Sep 22, 2014 at 09:50:54PM +0000, Rustad, Mark D wrote:
> * Fixing those is a good idea if the fixes are clean - I think we all
> agree by now that adding code just to shut up gcc is not nice.

Yes, but I think there are a few cases where it could be helpful. When
there is something exceptional that will throw a warning. In one of the
patches that Jeff sent, I used the DIAG_CLANG_IGNORE macro to suppress
the warning that is thrown for every entry of the syscall table when
compiled with clang. The code is right and doing exactly what is wanted,
so note the exception and make it shut up.

> * Then, even if all those warnings were fixed one fine day, the people
> who fix them would be fighting windmills because every new patch which
> adds new places causing those warnings would simply go in because the
> warnings are not visible in default builds.
> 
> So the question IMO turns into: are there some warnings which we should
> promote to default builds so that they get taken care of eventually...

I would generally be in favor of that over time, but I recognize that with
the range of architectures and toolchains that need to be supported, that
may be difficult.

>> Well, I have W=1 in my environment, so I don't even have to ask for it, I
>> just get it.
> 
> I think this was the initial use case we had in mind for W= - use it
> during development in order to have the compiler do extra checks to your
> code. And it has caught a couple of issues, FWIW.

Yes, not everyone building the kernel is a developer. I certainly get that.
Right now W=2 is kind of useless for developers because so much noise is
generated. With the number of people working on Linux, it may be enough if
a handful are taking a look at W=2 messages, but right now it is a pretty
awful task to even try to look.

>> Nested-externs, for example, can catch people gratuitously providing a
>> function prototype that could become a hazard, but some use of that may
>> be justified. The macros provide a way to specifically allow certain
>> instances while generally discouraging it. Of course if you never use
>> W=2 you may never catch those gratuitous declarations.
> 
> Sure, but the cost for fixing that is what bothers me. For that
> particular case, it probably would even be cleaner to add a
> nested-extern check to checkpatch instead of cluttering the code with
> those macros.

Generally there should be relatively few exceptions that need to be tagged.
If there were 1000, that would be way too many. The full series of my
patches had 90 instances. Some of the few that have been sent have been
resolved in better ways, which we all agree is better. Suppose that 40
can't be reasonably resolved in direct ways. Is that really costly? I'm
trying to understand what your perception of the cost is.

Perhaps checkpatch would be a better gatekeeper for new code. OTOH, some of
those nested externs have already been eliminated, so at least for now the
warning is serving a purpose since it is scrubbing existing code.

>> Hopefully the discussion is somewhat useful.
> 
> Well, it has become already, as you can see. :-D

I take it as a given that the kernel sometimes has special needs and needs
to do special things. The macros make it possible to mark those special
usages. I prefer adding the macros in a few places to eliminating a warning
altogether unless the warning is always useless. I'm sure we agree that we
don't want to ever turn on -pedantic! :-)

-- 
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_8F870727-F916-4FA5-9497-2AD28BAA004B
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUIazHAAoJEDwO/+eO4+5u5IQQAJLrkRd6vLpBb154ApRs1e87
RDqo8hJtmVOql11o0+83yUhuIieNrAHCsPeu8Uc5sXWXD8x7q1drtB2Vb9Te8ZUL
JDzclWBEmRpWOAb4Y3TWSZ3jULHT4Om8HIcmpQ4eiMC8O7RyZfDSYe+hgp/JrFJA
bxPAX4/pLdTHeKMKj9NoC824BcighOoCnmkmom1zB9Foc1npVyXHgSrhnD05hTgO
jVv6UeyiJPV7lKjKVqFvihEOclB92hyx835KXTOBhbYJ9wHrdAMRKnpDe1i5n2AD
5UjZAW0cOnzL6zvir7taU5+0MKjz92YZv3bbc5RUZHh1z5flZQUoLVZQLWPopGtV
R6IQdKZpoivAd9PE3yz00uiR23MopLvXLd/Xyci94h+wwuuL+w6N9nv7CtAXr96h
k2lcqqc+Fk6CsWZjGzvipHhOPmCdxrOnrk0gLDKZlF11zh5wlj8tA0Px0tw7ho/S
wxznAddkG4fnisK+QSEqxIBXcvdYb5WcHQVaXdOzVovxMAhv6dMKOdO5HSY0pRtD
xtwBALF9Or/41buVkSsD3zqmhcy191Ryyee2PIfzEazMDBqixXM/ldElZ8pHG56z
ywRVRfklFHDTpsvv1qosCF2nW9De9y8/19ylKM6IuFzXtSQnRR9gsXIaNfCQcH7z
3jNdJAuHb5P/VwnwDU0i
=oSoB
-----END PGP SIGNATURE-----

--Apple-Mail=_8F870727-F916-4FA5-9497-2AD28BAA004B--
