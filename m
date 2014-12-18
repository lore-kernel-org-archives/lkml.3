Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaLUOmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:42:51 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:34547 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaLUOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:42:49 -0500
Date: Thu, 18 Dec 2014 14:38:49 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Rui Zhang <rui.zhang@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] thermal-soc management updates for v3.19-rc2
Message-ID: <20141218183847.GA7350@developer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Rui,

Please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git fixes

to receive Thermal-SoC Management fixes for v3.19-rc2 with top-most

503ccc3fec4a56cdcfedc507cd1ea0d85e1fbfa2:

  thermal: cpu_cooling: return ERR_PTR() for !CPU_THERMAL or !THERMAL_OF (2014-12-17 09:00:04 -0400)

on top of 88910638717dd195cff1dd1ea74772b159632bba:

  Merge tag 'staging-3.18-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging (2014-11-28 16:08:09 -0800)

Specifics:

- The content of this git pull was supposed to be part of v3.19-rc1, but it missed the merge
window for different reasons. Thus, attempting to rc2 now. Good thing is that people had found
a couple of issues in linux-next, and the pull includes additional fixes too.
- In this pull, I am including a series of fixes that was supposed to make 3.18, but I decided
to send them for v3.19. I left for v3.19 because the required changes modified a couple of APIs.
Therefore, the redesign had to be done properly. The major fix here is to have proper sequencing
between cpufreq layer and cpu cooling registration. A take away of this fix is an improvement in
the thermal drivers code. Thermal drivers that require cpu cooling do not need to check for
cpufreq layer. The requirement now is to propagate the error code, if any, while registering
cpu cooling device. Thanks to Viresh for implementing the required CPUfreq changes.
- While in the subject, Viresh took the opportunity to review the cpu cooling code from a
cpufreq layer user perspective, which resulted in several cleanups.
- On top of Viresh's work, a couple of minor fixes were sent and included in this pull request.
- The content in this pull depends on CPUfreq refactoring done by Viresh, which is part of
the pull sent by Rafael J. W.:
https://lkml.org/lkml/2014/12/8/704
- This pull also contains the material I had sent you previously:
http://www.spinics.net/lists/linux-acpi/msg54562.html
Thus, just pull this one and ignore the #3 above.

BR,

----------------------------------------------------------------
Abhilash Kesavan (1):
      drivers: thermal: Remove ARCH_HAS_BANDGAP dependency for samsung

Dan Carpenter (1):
      thermal: cpu_cooling: small memory leak on error

Eduardo Valentin (3):
      thermal: cpu_cooling: check for the readiness of cpufreq layer
      thermal: db8500: Do not print error message in the EPROBE_DEFER case
      thermal: ti-soc-thermal: Do not print error message in the EPROBE_DEFER case

Fabio Estevam (1):
      thermal: imx: Do not print error message in the EPROBE_DEFER case

Javi Merino (1):
      thermal: cpu_cooling: return ERR_PTR() for !CPU_THERMAL or !THERMAL_OF

Lukasz Majewski (1):
      thermal:core:fix: Check return code of the ->get_max_state() callback

Punit Agrawal (1):
      thermal: Fix cdev registration with THERMAL_NO_LIMIT on 64bit

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

 drivers/thermal/cpu_cooling.c                      | 359 ++++++++-------------
 drivers/thermal/db8500_cpufreq_cooling.c           |  20 +-
 drivers/thermal/imx_thermal.c                      |  15 +-
 drivers/thermal/samsung/Kconfig                    |   2 +-
 drivers/thermal/samsung/exynos_thermal_common.c    |  12 +-
 drivers/thermal/samsung/exynos_tmu.c               |   5 +-
 drivers/thermal/thermal_core.c                     |   6 +-
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  17 +-
 include/dt-bindings/thermal/thermal.h              |   2 +-
 include/linux/cpu_cooling.h                        |   6 +-
 include/linux/thermal.h                            |   2 +-
 11 files changed, 177 insertions(+), 269 deletions(-)

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUkx8tAAoJEMLUO4d9pOJWmioH/2AOcTZ0GewXS3r0pESWnXIO
L4cSkT+q2JPwLA9uiALy4lsp/Chh2sBdSuO0oYoFl/D/nOYktqBqof5YRLgOyimu
IpfcYmv+Ho+oKjszRpt+/4wU6D6a79rOfuheDt37mJ3oZHLs4ubH2ryFJT4sCvD5
hq55xVsC6WZZA6zpqehhlAp7B6x5qLIm9zDzrkWtvf47wKIHelR2c/VIXVSMRgSe
0o8Sm83Zb6TovvAZq5KRrNwWrAy80cAlKIil1XIxkNNad13TAjIUE9aOwjM4Gfqn
kc6aqIhGAp3h++K0PihJ2rf/Az6N5Kz1AWTg2JexYyNouUk9/qPrMGil1JjOOEY=
=pWbe
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
