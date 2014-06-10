Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaFJPIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:08:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:49960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaFJPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:08:00 -0400
Date: Tue, 10 Jun 2014 17:07:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, mingo@kernel.org
Subject: Re: [PATCH] sched,numa: always try to migrate to preferred node at
 task_numa_placement time
Message-ID: <20140610150755.GK6758@twins.programming.kicks-ass.net>
References: <20140604163315.1dbc7b56@cuia.bos.redhat.com>
 <20140606171801.GE11371@laptop.programming.kicks-ass.net>
 <5392072D.6040605@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g5OIygP5QP1fC/+Y"
Content-Disposition: inline
In-Reply-To: <5392072D.6040605@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g5OIygP5QP1fC/+Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2014 at 02:23:41PM -0400, Rik van Riel wrote:
> On 06/06/2014 01:18 PM, Peter Zijlstra wrote:

> > Clearly the retry thing didn't work, what happened? We got to the
> > preferred nid, disabled the retry and got moved away again?
> >=20
> > Do we want to remove the retry logic in favour of this more aggressive
> > form?
>=20
> I think we want both. When we have fresh statistics, and we discover
> that we are not running on our preferred nid, is there any reason
> not to relocate to a better node?

I got confused on the exact details, I thought we ended up calling
task_numa_placement() far often than we actually do (well, we do call it
as often, but bail early).

Yes this makes sense.

--g5OIygP5QP1fC/+Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlx9LAAoJEHZH4aRLwOS6AKYP+gM8IBoxnjUcbHRSytbX+I5W
PiKpY5NSB1CFAu//Bhj23P1JzRZroBYLuWUwvDK2APZ9zU8GHCIqV5bR4e6tiR/+
iEbe06tuyTYDfVt4KLh3bya1YzEsYqtb7TZHmkpvcqg2A3ZeyMG/5sEV3xE9/GHS
qMVnoUAP374kKfETHvVg+qic5N1mAVWY/l8QsGEuR3KNjvFdmO1sPutv4H/eMUZ3
D7yshC/BR0wJIyT7La6ktEj7WUeikbOpXl11V6dGgRDvjYuMvQcVnzl3/ylBtw9Y
RVMqByAV1YPzsK4qeCc9Hfz4gq5DnwA1qYe0YuAMMJqEWA5E0HzBXRiOuNk+q0Ol
LsH7VQq7F8XgKCmtC96T+Dj8sht0jXFgxNK5qPILgPjP2+aDCK9ZtIZ/7sEX67Pl
20vYXV+j355+0qgCVTwgqZFgNon79Me1uuapAoQlswqAfzoqN3muvY1bF1futtUQ
T8euIgPNUCPjrpt54j7zSU8Lz4+9CO5B/b0QgCsSQGuDHoJkNE20e1FeVIPr7NFS
L8T/abBC+qpqtsvxUhehVRSoozBn38WRfEnxmkOuD6u7b+ZIRmp+AmfaDLxmTJNX
sP5n3ZsryMAoV91XQ0HeCPUUFwkmoCpc0sczs6xPjBFIIf6i2rpqVtWZ2xMZ8Qhe
7mDT1vBkupiFyNANSHkO
=5wjy
-----END PGP SIGNATURE-----

--g5OIygP5QP1fC/+Y--
