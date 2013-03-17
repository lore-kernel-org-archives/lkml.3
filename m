Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3CQFNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 01:13:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54093 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715Ab3CQFNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 01:13:20 -0400
Message-ID: <1363497184.3937.254.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Fix memory leak in cpufreq stats.
From: Ben Hutchings <ben@decadent.org.uk>
To: Colin Cross <ccross@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "davej@redhat.com" <davej@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Tang, Guifang" <guifang.tang@intel.com>, stable@vger.kernel.org
Date: Sun, 17 Mar 2013 05:13:04 +0000
In-Reply-To: <CAMbhsRTi8-41em4+-7NpLwXFpbGcy3Vsib5ees_OWm5JGmOVDw@mail.gmail.com>
References: <EE928378561BF1449699C96571234A740FE66C2A@SHSMSX102.ccr.corp.intel.com>
	 <3402692.Elm8oBRUJI@vostro.rjw.lan>
	 <CAMbhsRTi8-41em4+-7NpLwXFpbGcy3Vsib5ees_OWm5JGmOVDw@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Y5b+u+bFWuovb0UrtK/o"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y5b+u+bFWuovb0UrtK/o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-11 at 18:23 -0700, Colin Cross wrote:
> On Mon, Oct 15, 2012 at 1:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Monday 15 of October 2012 02:48:28 Tu, Xiaobing wrote:
> >>
> >> Fix memory leak in cpufreq stats.
> >>
> >> When system enter sleep, non-boot CPUs will be disable.
> >> Cpufreq stats sysfs is created when the CPU is up, but it is not freed=
 when
> >> the CPU going down. This will cause memory leak.
> >> signed-off-by: xiaobing tu <xiaobing.tu@intel.com>
> >> signed-off-by: guifang tang <guifang.tang@intel.com>
> >
> > I will push this patch for v3.7 in the -rc3 time frame if no one object=
s.
> >
> > Thanks,
> > Rafael
> >
> >
> >> diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq=
_stats.c
> >> index b40ee14..3998316 100644
> >> --- a/drivers/cpufreq/cpufreq_stats.c
> >> +++ b/drivers/cpufreq/cpufreq_stats.c
> >> @@ -328,6 +328,7 @@ static int __cpuinit cpufreq_stat_cpu_callback(str=
uct notifier_block *nfb,
> >>                 cpufreq_update_policy(cpu);
> >>                 break;
> >>         case CPU_DOWN_PREPARE:
> >> +       case CPU_DOWN_PREPARE_FROZEN:
> >>                 cpufreq_stats_free_sysfs(cpu);
> >>                 break;
> >>         case CPU_DEAD:
> >>
> >> Br
> >> XiaoBing Tu
> >> PSI@System Integration Shanghai
>=20
> This patch, commited as e37736777254ce1abc85493a5cacbefe5983b896 since
> v3.7, should also have gone to stable.  It should apply all the way
> back to 3.0.

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-Y5b+u+bFWuovb0UrtK/o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUVQ4Oe/yOyVhhEJAQrYQA/+O302WT7O+FZUhNtQ+Xb9YsQum1S+gdr1
ITYUt4RdbJSxFt+s1rij7JvHya4Z8KdHc3cJrP+bzfBGAWm3fklrQN97UJSAU843
HQemAehuzdQr4kF2BRek8wcpOs3rq07Q7pNzOJGOUwokmclsJ2GUlXbfXriHOPhw
njBVmpFNPXs0GmJj+MHxC8UD1rBzGzA9DrQAunh1Cz1LNH5d49HjdDpc73+TCNVb
72piqIf9aDKHiMbpqYnaTYoTJiad971DuHFAZqpMsyoTXjPVGnptbHPnc9K7LYmI
q0q8CQSHCqzZw5AABRkgQbRhd0P7izRtl0efOAbOe8BUnhxlUXzUYQOrZVPmL33B
1BdyHqq2im00sxv6wCd47jE/n/mfonSSy8MiFpSUICq5XWjcSRAJD0sUMcGVr/SA
/ZlQwMP5WXplQgHCiJ3LvvfUpnHvnX7h4qyIR08xRBUkyI9CG5MPkuXHYYKJmipp
e4y0LJBI7ZOjiAqkgSoL0y1F/FybhS4aEYrF0iMGBvvpkBt8J+Ca9bHKrLluTpgI
6lnQXWgStfRBhJmNJd8SbxfAimNmBdOamJR/uqTUD47OhtLFkjnHLKRACHhTK+4R
bJOp8KbLhFfEyk912a+hH7Z/g2uRUU6WpF3y3IRiSp3bKO3jCNCgPfLqGUYFVO0l
5OiYuGRQAwQ=
=QrBX
-----END PGP SIGNATURE-----

--=-Y5b+u+bFWuovb0UrtK/o--
