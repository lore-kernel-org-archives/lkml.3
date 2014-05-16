Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940AbaEPK3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:29:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807AbaEPK3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:29:23 -0400
Date: Fri, 16 May 2014 12:29:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516102908.GU30445@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516093530.GN11096@twins.programming.kicks-ass.net>
 <5375E0BA.7020208@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e4HPWByEyAOAEWhK"
Content-Disposition: inline
In-Reply-To: <5375E0BA.7020208@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e4HPWByEyAOAEWhK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 05:56:10PM +0800, Lai Jiangshan wrote:
> On 05/16/2014 05:35 PM, Peter Zijlstra wrote:
> > On Fri, May 16, 2014 at 11:50:42AM +0800, Lai Jiangshan wrote:
> >> After debugging, I found the hotlug-in cpu is atctive but !online in t=
his case.
> >> the problem was introduced by 5fbd036b.
> >> Some code assumes that any cpu in cpu_active_mask is also online, but =
5fbd036b breaks
> >> this assumption, so the corresponding code with this assumption should=
 be changed too.
> >=20
> > Good find, and yes it does that.
> >=20
> >> The following patch is just a workaround. After it is applied, the abo=
ve WARNING
> >> is gone, but I can't hit the wq problem that you found.
> >=20
> > Seeing how the entirety of hotplug is basically duct tape and twigs, the
> > below isn't that bad.
>=20
> I think we need to find a more grace solution...

A complete rewrite of the hotplug mess, until that time this is fine.



--e4HPWByEyAOAEWhK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdeh0AAoJEHZH4aRLwOS6+V4P/Rh65+O3nKEM9LZH2XuDrTLf
4EAk3MXpfNHOuJ/S87qWetCiIB2e9d33LJ9idXns/7pbUP4OqJf+imxTpQGuHQef
JSvuqDCa5+BX1vEqjBA88+qlOuABvR0ayFOMMo6GGo1G7wg/DSEZ6IIgWRMqFo1q
DhAWlG/oUmkUi/ADVeezmuRNXl/Ofkgk23y6ozQ9rGSfb1T2XY3xMP/zgq3q1f+s
cThQmpsX/fUpoDZTZd2IkxrjYysYxKARvzSTqLfa3bMJZAeU1OpCNFvvoeuE9of9
1avg1NnTJlwFxYCZhlLVaCtGe5LjCb4NtCXYBwvcMwPczgjCrcBw/mwV7S1oJ9/I
BO2IWbBzh9iMJTBo+AYfqh02uviklStNiW3wHaWXU0GawjFH8aMys3O2EyS8BL+X
utRzaOqMiz68MWTl9eCOIpMn1cM+6lOMW8Q2d9onVs0OuFsT44+YC/8vOzr6/sFr
BqFdDY1Pg1ypG5cBj8MWMXxPA0WinRkJzfWtQuA/YK1ASiKMOaXQGj+K4WQyT07j
cRSqNPb1a13k9uxvDYLOMD4LluPR2ef5XlhQ4P2jkXgzCwJrOX9DBWl3tBiRxkqs
65fMLExxReqtf8lMPxGC6ciaiOmgtcX65MdL3HGpR6evl7RSe7v+kYMlHm8d5i/r
whd57zD67p8bTOw7JMek
=Poov
-----END PGP SIGNATURE-----

--e4HPWByEyAOAEWhK--
