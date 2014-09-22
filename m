Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbaIVU7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 16:59:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:63260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128AbaIVU7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 16:59:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="389974727"
From: "Rustad, Mark D" <mark.d.rustad@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "sparse@chrisli.org" <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.weinberger@gmail.com" <richard.weinberger@gmail.com>,
        "linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
Subject: Re: [PATCH] sched: Remove nested extern
Thread-Topic: [PATCH] sched: Remove nested extern
Thread-Index: AQHP1o5n4j/Km9jR6U6Rx5Rq0DoBGpwN93YAgAAIi4CAAAlVgIAADxwA
Date: Mon, 22 Sep 2014 20:59:32 +0000
Message-ID: <D3423D3A-814F-4E22-A84B-61D76D137A98@intel.com>
References: <CAFLxGvwfuE-458duC9ARMLLMBCvZaBQnwDjPW6uJC4FAViBXjQ@mail.gmail.com>
 <20140922175511.62229.98784.stgit@mdrustad-wks.jf.intel.com>
 <20140922190128.GA2805@worktop.programming.kicks-ass.net>
 <D428C53D-F663-4846-ACAB-74922033B048@intel.com>
 <20140922200527.GA3128@worktop.programming.kicks-ass.net>
In-Reply-To: <20140922200527.GA3128@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.176.145]
Content-Type: multipart/signed;
	boundary="Apple-Mail=_55C4654D-914A-40A7-AA3A-D0D0CB6FF672";
	protocol="application/pgp-signature"; micalg=pgp-sha1
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Apple-Mail=_55C4654D-914A-40A7-AA3A-D0D0CB6FF672
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 22, 2014, at 1:05 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:

> On Mon, Sep 22, 2014 at 07:32:04PM +0000, Rustad, Mark D wrote:
>> I assume that nested-externs is included in W=3D2 because many uses =
of
>> them, especially with function prototypes, creates a risk of =
inconsistent
>> declarations. The kernel has a fair number of them that seem to have
>> been added to disentangle include files. If they are judged to be
>> worthwhile, then it would be good to silence the warnings so that
>> attention can be given to other instances of the warnings. If those
>> nested externs are not worth the risk, well that is a different =
conversation.
>=20
> So would using something like LTO not be way better at actually =
finding
> the problems, seeing how it can actually see the inconsistency in
> declarations.
>=20
> It seems to me that banning the use of nested extern is misguided as
> they are a useful tool; they provide some means of keeping symbols =
from
> being globally visible even though they actually are. Its a really =
poor
> man's 'private', but its the best C provides.

By using the macros the use of nested externs can be discouraged without
being banned. Presence of a DIAG_IGNORE macro should mean that the =
exception
has been noted and accepted. And the macro remains as an indicator of =
that.
Or to be taken as a warning label: readers choice perhaps.

> Also, why do you care about W=3D2 nonsense anyhow? They're default
> disabled for a reason.

Because I have found that enabling many warnings helps identify problems
in code and it has been my standard practice since about 1999 to do so.
The compiler warnings are really just another form of static analysis,
and I use it routinely on every compile. Here is how routinely: I have
W=3D1 in my environment, W=3D12 is just too painful. I would change that
default to W=3D12 if it wasn't insane to do so.

In my own code, I use way more warnings than even W=3D12 enables and in
that code I just resolve them. I had never resorted to using the =
attributes
in my own code, but they are an available tool.

I just finally thought it might be time to consider opening up a new
method to manage them for the kernel.

--=20
Mark Rustad, Networking Division, Intel Corporation


--Apple-Mail=_55C4654D-914A-40A7-AA3A-D0D0CB6FF672
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJUII20AAoJEDwO/+eO4+5usBoQAIS8VsZExOmae1m1mEHxcu03
ww7KWYbJ4vBTQBEjd+LDlEE7rjflSZaEWs9ibkVhDgrm2pyplnW8eqhKX8lR01Rl
BPaO5643N1f28U8VzughgwXWoJ1a4ydyIswdTKf/v8pe4lW2mU4C9qEY/5W+Lxs2
qIXWRNzAIZgrgXKs/rE4JsfPIYTMBwey8KviTu7EmzIDiujgShEwu5M0ti/uju2Y
c/42NLUyqzKAkC2/WvKkTed9/h2um/SYm/Iuw24M3syByM6qy3dgygKcqz9Lp7Gf
G4jHKyGC32txUnCYOYmMdvTWYOJlXSNcb0cmuoqxOipIXg6ZIrG3Ol/tu0pcLLTh
8BPwDBXjqWiLPXkxsv4W1kz0vROnX73Rz5xxKDff9z2HsbQ//Hii3htEsndtwrz0
Y2sPoEAK4LqB+91Ruy8vI6VqVYb8Cd0C5igljPzGui1lGE2CDQ+nB2Qg0RWaSm9O
5f2+AKOE/5i+u5S3P8jlRPEzGmA4r9UTP6OyjHWaVbBRdPNCjLwcMnAPgJUt4QDZ
67cZuterm8+/dIhrE6iiN7nUNdar9CCheRWnSYJUvd0oF7P8xhKFLgA0ZHEBPQ7h
peWKMByFtAsK3Aeb+D/ACDK7hDPYrUVnTCbTv/KSU/PVFNy4f7LF3kpiVXq7nW7v
plpY4VpMCxPkaIfwbYtx
=bjvd
-----END PGP SIGNATURE-----

--Apple-Mail=_55C4654D-914A-40A7-AA3A-D0D0CB6FF672--
