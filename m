Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaHZHS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:18:28 -0400
Received: from ozlabs.org ([103.22.144.67]:41202 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbaHZHSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:18:25 -0400
Date: Tue, 26 Aug 2014 17:18:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-ID: <20140826171818.719c4e6a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Z.Ss58ZUbCqyBcPX2Ue8RyV"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Z.Ss58ZUbCqyBcPX2Ue8RyV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (sparc64
defconfig) failed like this:

kernel/built-in.o: In function `proc_dowatchdog':
(.text+0x6a620): undefined reference to `watchdog_hardlockup_detector_is_en=
abled'
kernel/built-in.o: In function `proc_dowatchdog':
(.text+0x6a6a8): undefined reference to `watchdog_enable_hardlockup_detecto=
r'
kernel/built-in.o: In function `proc_dowatchdog':
(.text+0x6a79c): undefined reference to `watchdog_enable_hardlockup_detecto=
r'

Caused by commit 72355eed4bd7 ("kernel/watchdog.c: control hard lockup
detection default").  This build has CONFIG_HAVE_NMI_WATCHDOG=3Dy,
CONFIG_HARDLOCKUP_DETECTOR not set.

I have reverted that commit (and commits
"watchdog-control-hard-lockup-detection-default-fix" and "kvm: ensure
hard lockup detection is disabled by default" that follow it) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Z.Ss58ZUbCqyBcPX2Ue8RyV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/DS+AAoJEMDTa8Ir7ZwVBAgP/R9zyLgdvioWneLLPV2d7tB+
DVmnCE/GZt5ylKW9BtjuJospk8GiJn41QLWauNKryQkcb56VJU5tk4gwyjIooKS/
AzVmeN/+vHynS9jezwhL+fMBMMrppSpIwbEGcepYUJKR+I+7C6x92CeWWc0n3/M0
1vtoR5S4wY4RaHG7sxKXRQ+ANx8prp6ciLcB2VJf43+u6q6pOBByZswdInwKWLUM
avUKGcE69RJItRLCeAF7L7a0srzV0K7/IGcGLLRQnRfWQvEjE65vM7Sq4cDC1ljq
Lzs4HRcZmfV9D8fzEo1shlHMkx1ohXqfiPa1oCRbe8Lee72vLJ3tHRn+H/fpk0MJ
5uiuZEPyCT2IOqoIGOyt2oellZAZS6C2tr+aB4X3il7Ebq0VgfIEYwGu2O85Vxjr
rAQIMGfYPlBYPoKTw1jru/HGXX7Be2hJSvK1V8fN2UjFnpG2oh5eX/Yg1QLo2ph0
NSo5AU/XWFZmX1jEwIOyfCVLiCWZ5AvXwGoFAV9JsrcxeRHBPHQhwLAP+qI6Ilju
rcEW0gootqDcdy3EMXZ9S/34J1qra6FKW9CHjl7tHFWIWNcrsdA+7bpoV8KQsF4d
s5ALeyGh9o4obfm4nk2k28e1ABlg7pZ5uK3d15FaoramK19u/ptcVdytYNuz39v1
wY3GWt7eih1o8Zs5JjkV
=ErbU
-----END PGP SIGNATURE-----

--Sig_/Z.Ss58ZUbCqyBcPX2Ue8RyV--
