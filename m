Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaHAQEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:04:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:53346 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaHAQEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:04:44 -0400
Date: Fri, 1 Aug 2014 18:04:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Gioh Kim <gioh.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140801160415.GD9918@twins.programming.kicks-ass.net>
References: <20140730101143.GB19205@quack.suse.cz>
 <53D985C0.3070300@lge.com>
 <20140731000355.GB25362@quack.suse.cz>
 <53D98FBB.6060700@lge.com>
 <20140731122114.GA5240@quack.suse.cz>
 <53DADA2F.1020404@lge.com>
 <53DAE820.7050508@lge.com>
 <20140801095700.GB27281@quack.suse.cz>
 <20140801133618.GJ19379@twins.programming.kicks-ass.net>
 <20140801152459.GA7525@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qqF1XwZUdAkx0x+N"
Content-Disposition: inline
In-Reply-To: <20140801152459.GA7525@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qqF1XwZUdAkx0x+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 05:24:59PM +0200, Jan Kara wrote:

>   OK, makes sense. But then if there's heavy IO going on, anything that h=
as
> IO pending on it is pinned and IO completion can easily take something
> close to a second or more. So meeting subsecond deadlines may be tough ev=
en
> for ordinary data pages under heavy load, even more so for metadata where
> there are further constraints. OTOH phones aren't usually IO bound so in
> practice it needn't be so bad ;).=20

Yeah, typically phones are not IO bound :-)

> So if it is sub-second unless someone
> loads the storage, then that sounds doable even for metadata. But we'll
> need to attach ->migratepage callback to blkdev pages and at least in ext4
> case teach it how to move pages tracked by the journal.

Right, making it possible at all if of course much prefered over not
possible, regardless of timeliness :-)

> > Sadly its not only mobile devices that excel in crappy hardware, there's
> > plenty desktop stuff that could use this too, like some of the v4l
> > devices iirc.
>   Yeah, but in such usecases the guarantees we can offer for completion of
> migration are even more vague :(.

Yeah, lets start by making it possible, after that we can maybe look at
making it better, who knows.

--qqF1XwZUdAkx0x+N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT27p/AAoJEHZH4aRLwOS6PNAP/iVWD5KPtksZmG02fnnp7cz1
mMgKeKBIzYXGVSKIH2uRDnzsAYpTXpV1ZZNTrT55K83pDSEZpHRc3zhAh8UqyWnH
7TP78reCgATaQdA6mO4hEt7I9UuFg3MCaxNFxAKkh4p6A+l9Dk4RcDJCFwFSWdAo
S88SnAePEIiLa0W9MCmeq5SesAjXPgKYInUvSEV7xNL+QKVTY9CWIp8WPaTBGZPE
bwq9P6EOsWUgLL2yz8kvvyNx9vQG1/JbDYDoNLeh+n6P7lFW01rX1HlApnKh2m7L
UtEv6KA0RBDhefMbx1N0R5mjExAbVLeAWtM86RHYp+ttSKnluoXnmEwbRXx8cjzp
SiMQzJFxduFhl5Qh2j2YfZzbAloqDVVQhDjn2zwIIq3eQ9XMywBHJpuDrMuj641p
Mlnb60ZxrUBsIk0igucGPcWlHXu1Yngrw6sUYtoXlVU2WE9E367ZqXk0qcNQO3Ap
fnqtaFzujt74tKG/UHcqU8iv+kLTTDE67U9oikFL3QzVp6HHG9bkhbzvL3h1bSKy
y8wHEolW1gvzy56T1za7lfQLlQq+3a+lhsxN8S6hqCSxUVX27yWu8J7/CVsFey/3
4ZKhg7gvO80zCn/mkou657Eud5KZcBPs5aoPDumhzMNZC2u8VLhfpp6lKIlt5Toq
T5AdnrNclICuKWukhQjH
=Pwjj
-----END PGP SIGNATURE-----

--qqF1XwZUdAkx0x+N--
