Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbaFCIbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:31:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:40353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaFCIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:31:22 -0400
Date: Tue, 3 Jun 2014 10:31:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Tony Battersby <tonyb@cybernetics.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michael Kerrisk <mtk.manpages@gmail.com>, Ryan Lortie <desrt@desrt.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>,
        John Stultz <john.stultz@linaro.org>,
        Kristian Hogsberg <krh@bitplanet.net>,
        Lennart Poettering <lennart@poettering.net>,
        Daniel Mack <zonque@gmail.com>, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH v2 0/3] File Sealing & memfd_create()
Message-ID: <20140603083111.GM11096@twins.programming.kicks-ass.net>
References: <1397587118-1214-1-git-send-email-dh.herrmann@gmail.com>
 <alpine.LSU.2.11.1405132118330.4401@eggly.anvils>
 <537396A2.9090609@cybernetics.com>
 <alpine.LSU.2.11.1405141456420.2268@eggly.anvils>
 <CANq1E4QgSbD9G70H7W4QeXbZ77_Kn1wV7edwzN4k4NjQJS=36A@mail.gmail.com>
 <20140602044259.GV10092@bbox>
 <20140602091427.GD3224@quack.suse.cz>
 <CANq1E4T-4dc=r0mpedY-CfDmxCO4YmDfUX4-DRP1y6darAuSWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aHs8h1LsWZz+2jQe"
Content-Disposition: inline
In-Reply-To: <CANq1E4T-4dc=r0mpedY-CfDmxCO4YmDfUX4-DRP1y6darAuSWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aHs8h1LsWZz+2jQe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 02, 2014 at 06:04:02PM +0200, David Herrmann wrote:
> Correct, the problem is not accounting for pinned-pages, but waiting
> for them to get released. Furthermore, Peter's patches make VM_PINNED
> an optional feature, so we'd still miss all the short-term GUP users.
> Sadly, that means we cannot even use it to test for pending GUP users.

Right, I'm not bothered about temporary pins, they'll go away quickly
and generally not bother reclaim and the like (much). The thing I
'worry' about is the persistent pins, which have unbounded life spans.

--aHs8h1LsWZz+2jQe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjYfPAAoJEHZH4aRLwOS6ZycP/3BdudIxZJokQYj/PnND87iF
Zx7RbDsr8IJ2A5CykLTAcXyvwqWHF7hidOXnRiVlb9SN0kbJge6S6tUJjw7aTg8L
8W5v7ifbndYy9WAZKH7sqdrknGW0hNuR69g3w0OvByKgHToY3HN9ZN8njqi2oXnc
iE/gT8Cxt6HRPtMKUyIMS/J5aKLC3/q4+XGnwK5B0iYHRq8piMtZD4s+96VQ2/3L
WZlYMf4NkC+ExFAv5/4hfiIgMzbXWi3TvhCbeTFf3k8AVKe07u7PwWkqZgilTNda
xEgttm1JeliRYAdRb7s5KEyyZ4v8IyIpZgcJGqbJA911oM5bNI5P7I3hrGWq6M14
eTf1MMC6PIkohOhgjnA0gTDJQvHoQ5n6DPH7AyybBsgYHkhIf8TuxfiWI3Hdyz4B
wr7yUC+a0ptXsHgCR9Ze4uTnhMLoX/Ep5LRptRmH4RT9R4b/rRb+vCTKE2GmbUmj
ory1E0Rbe2iaiDIx3nsVkLsZrLzK2R2fiIhkAJuYTn+hl0V8iibU9TGZ2UQOUeD3
ZRaGWDu/qR7KktTaBa7sQDdSNAaxHlwrDGRVQogy0EMtC7MGlMUO1vTFTv843HwY
6pmw0WGf/t5gT5VjASyw/vxSomXFdWe6r1Sjr0P7kyw4S8VjL7QWouDzls9I7ErN
d+tdhe8RNRFJDty/L5Zj
=UaY9
-----END PGP SIGNATURE-----

--aHs8h1LsWZz+2jQe--
