Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3A2R4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:56:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab3A2R4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:56:03 -0500
Date: Tue, 29 Jan 2013 11:55:42 -0600
From: Clark Williams <williams@redhat.com>
To: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated
 header file
Message-ID: <20130129115542.5a7766fd@redhat.com>
In-Reply-To: <5107220D.6000606@huawei.com>
References: <20130128143120.1b60bfb6@redhat.com>
	<5107220D.6000606@huawei.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/cKUwBnF=FXYFIuY6V/dTwbt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/cKUwBnF=FXYFIuY6V/dTwbt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Jan 2013 09:12:45 +0800
Li Zefan <lizefan@huawei.com> wrote:

> > -extern void sched_autogroup_create_attach(struct task_struct *p);
> > -extern void sched_autogroup_detach(struct task_struct *p);
> > -extern void sched_autogroup_fork(struct signal_struct *sig);
> > -extern void sched_autogroup_exit(struct signal_struct *sig);
> > -#ifdef CONFIG_PROC_FS
> > -extern void proc_sched_autogroup_show_task(struct task_struct *p, stru=
ct seq_file *m);
> > -extern int proc_sched_autogroup_set_nice(struct task_struct *p, int ni=
ce);
> > -#endif
> > -#else
> > -static inline void sched_autogroup_create_attach(struct task_struct *p=
) { }
> > -static inline void sched_autogroup_detach(struct task_struct *p) { }
> > -static inline void sched_autogroup_fork(struct signal_struct *sig) { }
> > -static inline void sched_autogroup_exit(struct signal_struct *sig) { }
> > -#endif
>=20
> but those function declarations have nothing to do with sysctl..
>=20
> > -
> > -#ifdef CONFIG_CFS_BANDWIDTH
> > -extern unsigned int sysctl_sched_cfs_bandwidth_slice;
> > -#endif
> > -
>=20


True, but they're all under the SCHED_AUTOGROUP config variable along
with:
	extern unsigned int sysctl_sched_autogroup_enabled;

So I thought I'd keep them all grouped together.=20

I can move the prototypes back into sched.h but the whole reason for
doing this is to reduce the size of sched.=20

Guess I'll let Ingo make the call here.=20

Clark

--Sig_/cKUwBnF=FXYFIuY6V/dTwbt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEIDR4ACgkQHyuj/+TTEp19zwCgzL3SWsO9aos1koxWlQlPntsh
QVIAoNUrD054xSkgcKATKDutt0uP3ebq
=+kNf
-----END PGP SIGNATURE-----

--Sig_/cKUwBnF=FXYFIuY6V/dTwbt--
