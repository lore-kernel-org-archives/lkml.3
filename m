Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3GQFi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:38:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50495 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3GQFiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:38:24 -0400
Date: Tue, 16 Jul 2013 22:38:20 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Willy Tarreau <w@1wt.eu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 3.10.1] System does not wake up from suspend
Message-ID: <20130717053820.GA1965@skorgonTP.att.net>
References: <20130715043625.GA2162@skorgonTP.att.net>
 <20130715045400.GU32054@1wt.eu>
 <51E39BAB.4060308@linux.vnet.ibm.com>
 <20130717025720.GA1267@skorgonTP.att.net>
 <51E6242B.2050101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <51E6242B.2050101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 17, 2013 at 10:27:15AM +0530, Srivatsa S. Bhat wrote:
> On 07/17/2013 08:27 AM, S=C3=B6ren Brinkmann wrote:
> > On Mon, Jul 15, 2013 at 12:20:19PM +0530, Srivatsa S. Bhat wrote:
> >> On 07/15/2013 10:24 AM, Willy Tarreau wrote:
> >>> On Sun, Jul 14, 2013 at 09:36:25PM -0700, S=C3=B6ren Brinkmann wrote:
> >>>> Hi Greg,
> >>>>
> >>>> since upgrading to 3.10.1 I find my system not waking up from suspend
> >>>> from time to time. Unfortunately, I couldn't figure out how to relia=
bly
> >>>> reproduce the issue. Sometimes it works just fine.
> >>>>
> >>>> All I know so far:
> >>>> On 3.10 I had my system completely freezing a few times. But that did
> >>>> not seem to be related to suspend/resume. I never experienced the
> >>>> behavior described below on 3.10.
> >>>>
> >>>> On 3.10.1 I hit this bug a few times, that my system did not wake up.
> >>>> I.e. the screen stayed black and the power LED kept flashing. But
> >>>> nothing brought the system back up and I had to longpress power to r=
eset
> >>>> the system.
> >>>> I had none of the system freezes like the ones described above anymo=
re.
> >>>
> >>> Fortunately, 3.10.1 is very small. The only patch it contains which is
> >>> related to suspend is 18/19 (cpufreq ondemand governor). Maybe you're
> >>> having a problem with cpufreq on this machine in fact.
> >>>
> >>> You may want to try to force it to performance mode or powersave mode
> >>> and try for a while, it is possible that both 3.10 and 3.10.1 will wo=
rk
> >>> fine.
> >>>
> >>
> >> Or, you could try applying the patch shown below on top of 3.10.1 and
> >> see if it fixes the suspend/resume regression for you.
> >>
> >> https://lkml.org/lkml/2013/7/11/661
> >>
> >> (Just apply patch 1, not the entire patchset).
> > So, this didn't end well. With that patch applied I end up in a kernel
> > panic on suspend, reproducible - well two out of two is a small test se=
t,
> > but anyway. Unfortunately too late to get any information about it
> > and my logs don't show anything either. But it's seems worse than the
> > rather occasional hangs on resume on the vanilla 3.10.1 kernel.
> >=20
>=20
> Kernel panic? Weird.. I suspect something _else_ is wrong. I suggest tryi=
ng
> out the following:
>=20
> 1. My patches only touch cpufreq. So completely turn off cpufreq by setti=
ng
>    CONFIG_CPU_FREQ=3Dn. Then try suspend/resume and see how it goes. If it
>    fails, that shows that something _else_ is wrong and you can try a git
>    bisect for that.
I changed my config like shown below. That one has a two out of two
success rate for suspend/resume so far.

>=20
>    However, if suspend/resume succeeds with CONFIG_CPU_FREQ=3Dn, then try=
 out
>    step 2 below.
>=20
> 2. Apply patch 1 (not the entire patchset)
>    https://lkml.org/lkml/2013/7/11/661
That's the one I already have in my tree

>=20
>    On top of that, apply this patch:
>    https://patchwork.kernel.org/patch/2827512/
This one does not apply. I'll see if I can make it apply.

>
>=20
>    And then try suspend/resume with cpufreq turned on CONFIG_CPU_FREQ=3Dy
>    (and turning on other cpufreq Kconfig options which are of interest to
>     you).
>=20
>=20
> That should help us narrow down whether the suspend/resume issue is really
> related to cpufreq or not.

Config diff:
--- /boot/config-3.10.1-custom-00001-g14bc9ec   2013-07-15 19:26:02.0000000=
00 -0700
+++ /boot/config-3.10.1-no_cpufreq-00001-g14bc9ec       2013-07-16 22:21:22=
=2E000000000 -0700
@@ -48,7 +48,7 @@
 #
 CONFIG_INIT_ENV_ARG_LIMIT=3D32
 CONFIG_CROSS_COMPILE=3D""
-CONFIG_LOCALVERSION=3D"-custom"
+CONFIG_LOCALVERSION=3D"-no_cpufreq"
 CONFIG_LOCALVERSION_AUTO=3Dy
 CONFIG_HAVE_KERNEL_GZIP=3Dy
 CONFIG_HAVE_KERNEL_BZIP2=3Dy
@@ -538,36 +538,7 @@
 #
 # CPU Frequency scaling
 #
-CONFIG_CPU_FREQ=3Dy
-CONFIG_CPU_FREQ_TABLE=3Dy
-CONFIG_CPU_FREQ_GOV_COMMON=3Dy
-CONFIG_CPU_FREQ_STAT=3Dy
-CONFIG_CPU_FREQ_STAT_DETAILS=3Dy
-# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
-# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
-# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
-CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=3Dy
-# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
-CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
-CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dy
-CONFIG_CPU_FREQ_GOV_USERSPACE=3Dy
-CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
-CONFIG_CPU_FREQ_GOV_CONSERVATIVE=3Dy
-
-#
-# x86 CPU frequency scaling drivers
-#
-# CONFIG_X86_INTEL_PSTATE is not set
-# CONFIG_X86_PCC_CPUFREQ is not set
-CONFIG_X86_ACPI_CPUFREQ=3Dy
-# CONFIG_X86_POWERNOW_K8 is not set
-CONFIG_X86_SPEEDSTEP_CENTRINO=3Dy
-# CONFIG_X86_P4_CLOCKMOD is not set
-
-#
-# shared options
-#
-# CONFIG_X86_SPEEDSTEP_LIB is not set
+# CONFIG_CPU_FREQ is not set
 CONFIG_CPU_IDLE=3Dy
 # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
 CONFIG_CPU_IDLE_GOV_LADDER=3Dy
@@ -2911,7 +2882,6 @@
 # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
 CONFIG_THERMAL_GOV_STEP_WISE=3Dy
 CONFIG_THERMAL_GOV_USER_SPACE=3Dy
-CONFIG_CPU_THERMAL=3Dy
 # CONFIG_THERMAL_EMULATION is not set
 # CONFIG_INTEL_POWERCLAMP is not set
 CONFIG_WATCHDOG=3Dy

 	S=C3=B6ren

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQEcBAEBAgAGBQJR5i3MAAoJEE3EUu+tZnRfH9UH/jk5ggS9hYp9K7V9DPcwAFnl
PuzCa6Y7JXuKBLQ+YtAtWaGL8F8HUwqfDOjTRelTAOk7qGPY7hfWGt307J0V4Mdx
uVYcJ6NvsuTk0+ZkQZDKU31s1KCyn+rEK2SKY0RvwH0geirHJsJ+dMZhbm3sfRAN
yhB0V0IJ3704qMqJv59cjyM6XDh7r4aU5jA042gcrTrEz43QfMMMqvPPFmD8NvYq
muZNB+m8f+h8IBXE+prMRJikA8NwfKoJGQGznpumiPw88NxRNO3b5GTTdQjgar0U
OwOBoFmi9BWhzhwqfz6o+0w5cWW2K226jcK5MHEAmbf9DQHNp/r1DdWDW25LDig=
=2dBX
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
