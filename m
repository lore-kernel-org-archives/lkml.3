Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160Ab3JQB3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 21:29:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762109Ab3JQB3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 21:29:35 -0400
Date: Thu, 17 Oct 2013 12:29:22 +1100
From: NeilBrown <neilb@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, Shaohua Li <shli@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131017122922.69b41b11@notabene.brown>
In-Reply-To: <20131016213005.GL10651@twins.programming.kicks-ass.net>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
	<1381949500-501-2-git-send-email-treding@nvidia.com>
	<20131016213005.GL10651@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XYbnB.MuKVBMd2FRlLMbFFS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XYbnB.MuKVBMd2FRlLMbFFS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Oct 2013 23:30:05 +0200 Peter Zijlstra <peterz@infradead.org>
wrote:

> On Wed, Oct 16, 2013 at 08:51:39PM +0200, Thierry Reding wrote:
> > Today's linux-next merge of the tip tree got a conflict in
> >=20
> > 	include/linux/wait.h
> >=20
> > caused by commits 1ab2460 (wait: add wait_event_cmd()) and fb869b6
> > (sched/wait: Clean up wait.h details a bit).
> >=20
> > I've cleaned it up (see below). Please verify that the resolution looks
> > good.
>=20
> >  +#define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
> >  +do {									\
> >  +	DEFINE_WAIT(__wait);						\
> >  +									\
> >  +	for (;;) {							\
> >  +		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> >  +		if (condition)						\
> >  +			break;						\
> >  +		cmd1;							\
> >  +		schedule();						\
> >  +		cmd2;							\
> >  +	}								\
> >  +	finish_wait(&wq, &__wait);					\
> >  +} while (0)
>=20
> Ideally we'd write the new thing like:
>=20
> #define __wait_event_cmd(wq, condition, cmd1, cmd2) 			\
> 	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
> 			    cmd1; schedule(); cmd2)
>=20

Oooo.. that looks much nicer.  I'll make it look like that before it goes
upstream.

Thanks,
NeilBrown

--Sig_/XYbnB.MuKVBMd2FRlLMbFFS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUl89cjnsnt1WYoG5AQKLdxAAmbgLKCOkFONtpEBZ5zZur4Ud0JF31m+D
unHxY+69vXC9Hg8tyBH3FqTzzUy17ahWck6h7LTvxh2sjix0bryVYaPqqpOgxj0G
9jgExLyFNNyv3b9UaqMpTchqumr6fpB6njt/8ghjU63rBvh7tStxkMR6eUnrSAy0
YbXQedEmJyvt37zhxvlg2tPvkWt80LqeDAQ78qMK16RFRh7rGDI1H8yJygnBuojk
LdngDRTGNN233gEVcrKH/P2IivXIK2xLi6tdwM3KPeZDywqyS9OCLyYmEIfax2V9
d1rJTRyl5kqcs6LXfZhyTJvlsJHpqu6paEgh5Oi4ZgBuMOErz8UW3q1OFAstdhvz
sG+l6xx+22eodf+/CQv2P6REaAfUdTLdKmjsJDDMCxbTtE3rIXTX8D84FODmIxzv
BINEo34Dd34rME+GkdT9P/bFUbKkC/H+2V/XtPalRmwKs55ykbH2JL8fNDtEAdM6
lyvUyWzsbPnl5o8zirvk9F3R0DlEsiHNAI0kJtkBZglRkB1BvWXUECm5cx8V4Mm5
QyvRp2riLMEOR/zRUikhfu7/A0ByH8vgIVJ+KZ83NiiJl5R66Ld5NGgLiQmHw6ON
I52Yv8xLGw9R2xNPbxAts7CnlYCKzPD+PJFOwkVSpFqWP83ZUet2HvTteJSq9GWf
cSRHXDCaA1Y=
=JMk6
-----END PGP SIGNATURE-----

--Sig_/XYbnB.MuKVBMd2FRlLMbFFS--
