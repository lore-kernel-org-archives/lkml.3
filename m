Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560AbaLIOSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:18:15 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:45816 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225AbaLIOSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:18:13 -0500
Date: Tue, 9 Dec 2014 00:03:37 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux PM <linux-pm@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal-soc management updates for v3.19 #3
Message-ID: <20141209040336.GB2245@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Rui,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git fixes

to receive Thermal-SoC Management updates for v3.19 with top-most

9a3031dc3e7a5edfeb52ae8951f8bcd927351854:

  thermal:core:fix: Check return code of the ->get_max_state() callback (2014-12-08 21:32:56 -0400)

on top of 88910638717dd195cff1dd1ea74772b159632bba:

  Merge tag 'staging-3.18-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2014-11-28 16:08:09 -0800)

Specifics:

- In this pull, I am including a series of fixes that was supposed to make 3.18, but I decided
to send them for v3.19. I left for v3.19 because the required changes modified a couple of APIs.
Therefore, the redesign had to be done properly. The major fix here is to have proper sequencing
between cpufreq layer and cpu cooling registration. A take away of this fix is an improvement in
the thermal drivers code. Thermal drivers that require cpu cooling do not need to check for
cpufreq layer. The requirement now is to propagate the error code, if any, while registering
cpu cooling device. Thanks to Viresh for implementing the required CPUfreq changes.
- While in the subject, Viresh took the opportunity to review the cpu cooling code from a
cpufreq layer user perspective, which resulted in several cleanups.
- The content in this pull depends on CPUfreq refactoring done by Viresh, which is part of
the pull sent by Rafael J. W.:
https://lkml.org/lkml/2014/12/8/704

BR,

----------------------------------------------------------------
Eduardo Valentin (1):
      thermal: cpu_cooling: check for the readiness of cpufreq layer

Lukasz Majewski (1):
      thermal:core:fix: Check return code of the ->get_max_state() callback

Viresh Kumar (25):
      thermal: db8500: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: imx: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: exynos: pass cpu_present_mask to cpufreq_cooling_register()
      thermal: cpu_cooling: random comment fixups
      thermal: cpu_cooling: fix doc comment over struct cpufreq_cooling_device
      thermal: cpu_cooling: Add comment to clarify relation between cooling state and frequency
      thermal: cpu_cooling: Pass variable instead of its type to sizeof()
      thermal: cpu_cooling: no need to set cpufreq_state to zero
      thermal: cpu_cooling: no need to set cpufreq_dev to NULL
      thermal: cpu_cooling: no need to initialze 'ret'
      thermal: cpu_cooling: propagate error returned by idr_alloc()
      thermal: cpu_cooling: Don't match min/max frequencies for all CPUs on cooling register
      thermal: cpu_cooling: don't iterate over all allowed_cpus to update cpufreq policy
      thermal: cpu_cooling: Don't check is_cpufreq_valid()
      thermal: cpu_cooling: do error handling at the bottom in __cpufreq_cooling_register()
      thermal: cpu_cooling: initialize 'cpufreq_val' on registration
      thermal: cpu_cooling: Merge cpufreq_apply_cooling() into cpufreq_set_cur_state()
      thermal: cpu_cooling: remove unnecessary wrapper get_cpu_frequency()
      thermal: cpu_cooling: find max level during device registration
      thermal: cpu_cooling: get_property() doesn't need to support GET_MAXL anymore
      thermal: cpu_cooling: use cpufreq_dev_list instead of cpufreq_dev_count
      thermal: cpu_cooling: Pass 'cpufreq_dev' to get_property()
      thermal: cpu_cooling: Store frequencies in descending order
      thermal: cpu_cooling: Use cpufreq_dev->freq_table for finding level/freq
      thermal: cpu_cooling: update copyright tags

 drivers/thermal/cpu_cooling.c                      | 360 ++++++++-------------
 drivers/thermal/db8500_cpufreq_cooling.c           |  10 +-
 drivers/thermal/imx_thermal.c                      |   9 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |  12 +-
 drivers/thermal/samsung/exynos_tmu.c               |   5 +-
 drivers/thermal/thermal_core.c                     |   6 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |   6 -
 7 files changed, 152 insertions(+), 256 deletions(-)

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhnSQAAoJEMLUO4d9pOJW+KYIAJv72U5Q77J3EtFPKtFRLc/Z
wWoFQCEOnT348fldncC3hDKYGcSyop7B0btZM0H1kY7dKO91SKMgOdHdx5u7a6gu
QvAAn8wCg0Mwy7oJKrsvvhDwkGzZ6ypM9/6hQB8RkDe4VLGHlbJRaDnsj+hY44g7
rVc0B0CnPeWUCDnj5eXV4KiqLAtBZrvG1gDa5bnaL9OYihh+j5ukFEptXeHjE2Ku
+hj5uXNOWZXQldquaFNNPgq9358b82Mmq1m+EcyF6PPV2wceRLGx3LO/z2g+YT7A
FlVe4WMrzxLv2/Zk1CdLGK9xs9xU5+cz4loiJ9pTcNRuCyS5i0hZu9mS/hdB/BQ=
=oHhd
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
