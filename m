Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaHDHqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:46:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:60832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaHDHqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:46:34 -0400
Date: Mon, 4 Aug 2014 09:46:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140804074620.GH9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53DEE1CD.4000705@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UD4WyN0VgQ3kz1Eq"
Content-Disposition: inline
In-Reply-To: <53DEE1CD.4000705@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UD4WyN0VgQ3kz1Eq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 09:28:45AM +0800, Lai Jiangshan wrote:
> On 08/01/2014 05:55 AM, Paul E. McKenney wrote:
> > +		rcu_read_lock();
> > +		for_each_process_thread(g, t) {
> > +			if (t !=3D current && ACCESS_ONCE(t->on_rq) &&
> > +			    !is_idle_task(t)) {
> > +				get_task_struct(t);
> > +				t->rcu_tasks_nvcsw =3D ACCESS_ONCE(t->nvcsw);
> > +				ACCESS_ONCE(t->rcu_tasks_holdout) =3D 1;
> > +				list_add(&t->rcu_tasks_holdout_list,
> > +					 &rcu_tasks_holdouts);
>=20
> This loop will collect all the runnable tasks.  It is too much tasks.
> Is it possible to collect only on_cpu tasks or PREEMPT_ACTIVE tasks?
> It seems hard to achieve it.

Without taking the rq->lock you cannot do that race-free. And we're not
going to be taking rq->lock here.

--UD4WyN0VgQ3kz1Eq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT3zpMAAoJEHZH4aRLwOS6wpsP/1N9WYnCGK6ek31MjzBFLJFj
++jyRTKce30JA+eLd34c8CgdMd9bS9Cb4sgBdbYsPiY/8hyVaO77Aan01xMCHK8h
OczQTJc+gEloDTxozrTcny0czAjj70nCfoStBIiAeP4kuA5AMl7P0bVLJ0O1ATth
gnAElc2LVvytA8hIEbldgbUdftE1ffjT1ugZlnMAHve9FMHiLKu1hopXXmXS9FAD
RJ4oU3X69jQA3tafKEMM1+XAyN3AgV8eshn7n8xX6y2q3xsKcwzXxhEgLvX7CK0T
6h0yKOsmZvAAIfsf5YjUyMW5gkluz3OCPJxoG9w/T4rWbX7fda2WffmannLADYMm
7Zj70Eh10o83uhvlm+vnf7yg/Og4ZNnbfLuQC+lEqaqKcOvgFUiuK831XligDx8a
ZgAAI2gaiDUQOPXas9Xw2KDReEUWm/br4A087cxsdnt1CaxjfAeCDN3AJX1XlIso
uQiJCBNa1kWSljztZn9GpzvBbBkyxtUEl/8umUl+PFHMjQm9ypH6pj9a0j7KDcE+
evta0p1oI9fLUlkMWAPtu68IQKTsw+QPIv2IgD/89O+ZBNHpehXZLcobOp+85L6e
50RlBqqW9lrKjyicx0CdP464QU6EmMQOOUUeaS4iYtOylYexcAgy0hJ5UWeeqMBC
e0bPeIJseAjrBoGCAxN7
=8eoP
-----END PGP SIGNATURE-----

--UD4WyN0VgQ3kz1Eq--
