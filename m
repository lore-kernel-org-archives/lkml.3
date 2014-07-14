Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbaGNNDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:03:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37937 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbaGNNCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:02:54 -0400
Date: Mon, 14 Jul 2014 15:02:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140714130237.GX9918@twins.programming.kicks-ass.net>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714114359.GA17761@krava.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DWqF7Vcvgq9cBwZ0"
Content-Disposition: inline
In-Reply-To: <20140714114359.GA17761@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DWqF7Vcvgq9cBwZ0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 01:43:59PM +0200, Jiri Olsa wrote:
> On Mon, Jul 14, 2014 at 01:18:33PM +0200, Peter Zijlstra wrote:
> > On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > > From: Jiri Olsa <jolsa@redhat.com>
> > >=20
> > > When task exits we close:
> > >   1) all events that are installed in task
> > >   2) all events owned by task (via file descriptor)
> > >=20
> > > But we don't close children events of 2) events. Those children
> > > events stay until the child task exits and are useless with the
> > > parent being gone, because we have no way to get to values any
> > > more.
> > >=20
> > > Plus if the event stays installed in task even with the owner task
> > > gone, it runs the perf callback any time the task forks, for no
> > > real reason.
> > >=20
> > > Closing all children events events when the owner task of the
> > > parent event is closed.
> >=20
> > Do we need this for the other patches, or is this an unrelated change?=
=20
>=20
> if we dont do it, the event stays installed without owner and
> perf fork callback will be called and fail on permission checking
> (because of owner =3D=3D NULL) ... so yes, I think it's needed

Oh, right. Alternatively, we don't need permission checking for inherits
at all, if we're allowed to create the initial event, we should be good
for inherits.

And I suppose install_exec_creds() already does the right thing when we
may not.

--DWqF7Vcvgq9cBwZ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw9TtAAoJEHZH4aRLwOS6v6IP/jpYe7htk+WdB/L8FMCr1Iy7
spmPJlqz1U7PQNkKrsl0OopP9juco/Bu3HwbG89BHHocgPCIEkvhCEyqdP9x1m0r
Uzd3jsfXMwKslcCGZieaypTFs2ZM5HSjfoWOe1lcwhjFOak/NfyrdRvwZYHfSbao
d3tCmHbUDhn0EmGIOxQqhIqipzM8+HFgE7r+kwj/QKERz7Jd+N1gA09BQXz4yHbk
Lpyok6CeNoETnmUEVtW2EwmK2ZcjjqkaqjpLnJLwdw31mWqmKDxWDUfSnJ9AkyYV
LaQLRaJvJcMp3/HYIlgJQ7CsiPjcbzL41SnFHCXW+RAZ9Sr64fJ57YzOfi7R0Xmp
VueiaOdJraIrLPGj6gV6FS4AMQuFEMGu7FvZySZfaX2lkhFWqMBRIWs6F9b15+VX
lfmz33B4VnkOPjxGDg4kP8Iou52cjcsNsEVPnJZ1WNVMobU7ZCiYZyOix/qeHxQa
MuPox2rrHWVtnT+mUC/WT5RILWUmtascCkqayf9mdgv8BimYXsHafNPcNKHdHibG
5z/eSpfYauSl/hkHcPBxO0pfPE1yfHQeeZVctUJSqLo5AktT1sYoYkeAbnZsoTbG
2K4SMSbedGyaJTOBntxxhI2gPYv55teJF7BTrwS+TsIpJX+FZN7W16IiCrPzHbc6
3gT6AhUl0thQpKKcA6TL
=ohq7
-----END PGP SIGNATURE-----

--DWqF7Vcvgq9cBwZ0--
