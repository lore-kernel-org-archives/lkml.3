Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3CUCma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:42:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57455 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab3CUCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:42:28 -0400
Message-ID: <1363833706.31336.99.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.0] perf,x86: fix kernel crash with PEBS/BTS after
 suspend/resume
From: Ben Hutchings <ben@decadent.org.uk>
To: shuah.khan@hp.com
Cc: eranian@google.com, Greg KH <gregkh@linuxfoundation.org>,
        a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, tglx@linutronix.de, hpa@zytor.com,
        pavel@ucw.cz, rafael.j.wysocki@intel.com,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
        peterz@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
        jolsa@redhat.com, ak@linux.intel.com, stable <stable@vger.kernel.org>,
        shuahkhan@gmail.com
Date: Thu, 21 Mar 2013 02:41:46 +0000
In-Reply-To: <1363395478.7231.9.camel@lorien2>
References: <1363395478.7231.9.camel@lorien2>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jKYd1qMBM6aFTsFBLVOa"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:5944:e226:2c7e:1b17
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jKYd1qMBM6aFTsFBLVOa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-03-15 at 18:57 -0600, Shuah Khan wrote:
> This patch fixes a kernel crash when using precise sampling (PEBS)
> after a suspend/resume. Turns out the CPU notifier code is not invoked
> on CPU0 (BP). Therefore, the DS_AREA (used by PEBS) is not restored prope=
rly
> by the kernel and keeps it power-on/resume value of 0 causing any PEBS
> measurement to crash when running on CPU0.
>=20
> The workaround is to add a hook in the actual resume code to restore
> the DS Area MSR value. It is invoked for all CPUS. So for all but CPU0,
> the DS_AREA will be restored twice but this is harmless.
>=20
> Upstream commit id: 1d9d8639c063caf6efc2447f5f26aa637f844ff6
>=20
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Shuah Khan <shuah.khan@hp.com>
> CC: stable@vger.kernel.org 3.0
[...]

I've queued this up for 3.2 (though context was different again), along
with the following fix-ups:

commit 2a6e06b2aed6995af401dcd4feb5e79a0c7ea554
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Mar 17 15:44:43 2013 -0700

    perf,x86: fix wrmsr_on_cpu() warning on suspend/resume

commit 6c4d3bc99b3341067775efd4d9d13cc8e655fd7c
Author: David Rientjes <rientjes@google.com>
Date:   Sun Mar 17 15:49:10 2013 -0700

    perf,x86: fix link failure for non-Intel configs

Ben.

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-jKYd1qMBM6aFTsFBLVOa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUpzaue/yOyVhhEJAQow4BAAlYZb58LUknbVEMOZbkOiJloGOdzxCoYW
izfAiJthh48Ddzg9vJP/TFYph9OWEXB6rh1t7oQ9EDyuq8WZch8ZGeCb+POpfxIS
n6b6iKgQWRKeax2hmmUeo/S+1EUeo7m41BIBfSFmE3diRPzDT1WYMNz7sOEWF59g
XwThUDoSLHkfItT13LEqY4Zy/p1+jP35aAzq9dHE6iZxSyzFP8/SDfGkkhuejD8R
b1VjkfnFCiiYy9etS+p/z00qezegULGUH98qD+I0O8kEsV39di2/DF0WGCXQ54vm
5L3NbaV738W/4yFVP48SNzrr3Nx95xw0RtFAA+eDqv8/WlZIAjCyCnpenE9sW+vv
othr/kK+v4vwJh+jZzGOhXH8wgHMfYD2i2rfMTHM2sWXZu+y5mVhtm1ov2Tv7dN0
vuvccwOsv40qNuIqts1UeQzEdXMkcvQxXNYdpJHK+l9QCKQ5Qi/uBrpHAOIDInc0
Ihpy5XhUV+5Xx/oimXQXhmWqrreiKE9k50ofnL9tH9/RzkzyHJgEQQBlYnjYnho2
LGLkyK6ArwT5AxRFov1WzK1APtueTHZ4rJJug/7KmjA/ejIr7OorcKt4lo69CJMh
/0tSIZR2pRTkzKhlwnV2EYN0ftTGGsYTDz3IfyzJbIa6juSfx2L94gou6WdPRL3u
9jDLdl6Q58w=
=W0Vh
-----END PGP SIGNATURE-----

--=-jKYd1qMBM6aFTsFBLVOa--
