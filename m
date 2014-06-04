Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaFDGuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 02:50:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:45049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747AbaFDGt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 02:49:56 -0400
Date: Wed, 4 Jun 2014 08:49:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140604064946.GF30445@twins.programming.kicks-ass.net>
References: <53758B12.8060609@cn.fujitsu.com>
 <20140516115737.GP11096@twins.programming.kicks-ass.net>
 <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
 <20140516162945.GZ11096@twins.programming.kicks-ass.net>
 <53849EB7.9090302@linux.vnet.ibm.com>
 <20140527142637.GB19143@laptop.programming.kicks-ass.net>
 <53875F09.3090607@linux.vnet.ibm.com>
 <538DB076.4090704@cn.fujitsu.com>
 <20140603141659.GO30445@twins.programming.kicks-ass.net>
 <538E840D.2040300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2504uJlMzHih+KB5"
Content-Disposition: inline
In-Reply-To: <538E840D.2040300@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2504uJlMzHih+KB5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 10:27:25AM +0800, Lai Jiangshan wrote:
> > Hmm, yes I think you're right. A queued wakeup can miss an affinity
> > change like that.
> >=20
> > Something like the below ought to cure that I suppose..
>=20
> As a non-scheduler developer, I can't find anything wrong with the patch
> (I searched all on_rq in kernel/sched).

You did fine finding that hole, so who knows, you might become one real
soon now ;-)

> but I think __migrate_task() is slow path comparing to sched_ttwu_pending=
().
> So I prefer to change set_cpus_allowed_ptr() and __migrate_task() rather =
than
> to sched_ttwu_pending().

Yes, I agree, something there would be better, but I couldn't find
anything without holes in.



--2504uJlMzHih+KB5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjsGKAAoJEHZH4aRLwOS6gDUQAIUXKx4afQOsdMh8+7RJiEBU
7wostf98eHEnoGm55l3pbP99SwD+VLqvvy5csUTxmZlhbjpB2iWmrpvKvTzITApv
jUId+UN+9Fv2ycXK1201CykoClWeN/s2RsczkziZT1F9ZSfLoznaRFAzgvgmK/JX
sbqhZSjY+/hvwF/W8rc5DqX+IuDPkVKIhrFx/TBXV+2BFJ+tsUdJuDT5C5E3b0cS
66wCyaiWEGlJaixhhDgfTovZewTSFTIighNeQSEJWW3upVk+zkuSt6+yYuIyazu7
KebVB7bFwEvkquqeCy4BZdR85LLZxafPLcCpuC5c5KrksXsHcAYdmXPlQsIqtMeq
Wq/aWG5jA+U9gWKJSOVWyaEOb50Wl13BkIThoWQ5qT40Nm6HdXgpPhY/72EkFvpI
UCF495gftXtq8NA6A+hgcovWmnFVIz4IvvJY76IPy6pCEDPPS/8HvynWDCRL5PlN
U/byNI1WXvCgZ9Z2BrgDM57WZa7a0zDx+EZePuAleCgDPMdgo+/uvWc7Fm8h45ZE
j/3hanF/nEA6He621bGZM4+xOTYCyi1ujAOnWkKm+1T72J7tvbzDckIaQU4VaQU2
UdB1TVLtpbwugfSd5VXXNRGVrkFuV5l8vQGPmOkQbAuPNFR+ssf857eGpAxBSvpM
m4oHsHPJYrJnViy6DtOr
=6EzU
-----END PGP SIGNATURE-----

--2504uJlMzHih+KB5--
