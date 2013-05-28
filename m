Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3E1VM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:12:29 -0400
Received: from home.keithp.com ([63.227.221.253]:47878 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968Ab3E1VM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:12:26 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 17:12:26 EDT
From: Keith Packard <keithp@keithp.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Arto Merilainen <amerilainen@nvidia.com>
Cc: "airlied\@linux.ie" <airlied@linux.ie>,
        "linux-tegra\@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel\@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xorg-devel@lists.x.org
Subject: Re: [PATCH 2/6] gpu: host1x: Fix syncpoint wait return value
In-Reply-To: <20130528103927.GB11547@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com> <1368791388-31441-3-git-send-email-amerilainen@nvidia.com> <20130526101243.GB1652@mithrandir> <51A30372.6080907@nvidia.com> <20130528103927.GB11547@mithrandir>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.4.1 (i486-pc-linux-gnu)
Date: Tue, 28 May 2013 13:12:12 -0600
Message-ID: <86y5ay6hrn.fsf@miki.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Thierry Reding <thierry.reding@gmail.com> writes:


> That doesn't sound right. Maybe drmIoctl() needs fixing instead. Looking
> at the history, drmIoctl() was introduced to automatically loop if a
> signal was received (commit 8b9ab108ec1f2ba2b503f713769c4946849b3cb2).
> However the ioctl(3p) manpage doesn't mention that ioctl() returns
> EAGAIN in case it is interrupted by a signal.

EAGAIN is being returned when the GPU is wedged to ask the application
to re-submit the request, which will presumably be held until the  GPU
is un-wedged.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUaUBjTYtFsjWk68qAQh4wRAA2GDdsxUzZaRePb/FK8WlGEydhgsSRbAJ
QDd4BTOd/ueu5uGon/nWc1T8gQ1QCLO62a+H06+VuYzERDnD1v9M6uc2/LESNUz9
YHFZsJj9RDUBLbyTVxF8aXP1WC1Xj182dDGHGrgaAux2HSNTThI3y+hxV3K6tUub
sFDBd7Qp1gN382exPYDyi/AFDdp3HgO8C3tMgHHTJIRNVklY9R4rVYSIhjgzlLh2
bL1DxsJqiMXBKNlh88kZYurkB6xrZQczb4DRsXxTCTo8MdUD1r7nygzsVYirEW6c
gvr9fFsWvS89L4Dl+7dWKGITQwJ1PVMr+0UBoSIvpyLHGr3tsYQOGSs+CzntieOK
Ax1l62YME7dpaM4maepuz8CAlltHgh3bEbPnlhpmlj5qAKmri5bBdAI8Il2sR5Pw
KcwVIEKNtVCBmywuqFH/yA8o4CjBwVXLVYChphalnE4hO7Vy7iLsuvOMXn/upJUQ
jeVJBuHv7yOGjPwzLAvPKijmD5NcFPGJC9BXGLUooSJ+fyHF+SmNCbEOZRr/Oz9B
NOIS3TSkXwhcp5GxFGPelP86SDRz1IbGOcTcs+5r/OKWUOlW+BaDWdSf0EgjKPzt
YLY16VeD+pLnHIWRcBOOQZYpkelTKGTRO2QkplQohTjh+lNatAWh5NKHYKHzXFOm
DoPiXzk14RE=
=4Zdj
-----END PGP SIGNATURE-----
--=-=-=--
