Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab3CZPkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:40:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965245Ab3CZPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:40:18 -0400
Date: Tue, 26 Mar 2013 15:40:14 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [GIT PULL] extcon/ASoC: arizona: Fix interactions around HPDET
Message-ID: <20130326154014.GD18316@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dKeYJkA19bNVVKdr"
Content-Disposition: inline
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dKeYJkA19bNVVKdr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch series fixes an interaction between the extcon and ASoC
drivers for arizona.  Since both drivers are under active development
there are likely going to be cross tree issues - there's already some
further patches on the ASoC side - so it'd be good to get this pulled
into both trees.

I've taken the liberty of pulling into ASoC already, if there's a
problem with that I can drop the changes easily enough.

The following changes since commit 8bb9660418e05bb1845ac1a2428444d78e322cc7:

  Linux 3.9-rc4 (2013-03-23 16:52:44 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git tags/arizona-extcon-asoc

for you to fetch changes up to 63fea17128397d440753883d16e7d2d9aa95a66b:

  extcon: arizona: Fix interaction between headphone outputs and identification (2013-03-26 14:26:05 +0000)

----------------------------------------------------------------
ASoC/extcon: arizona: Fix interaction between HPDET and headphone outputs

This patch series covers both ASoC and extcon subsystems and fixes an
interaction between the HPDET function and the headphone outputs - we
really shouldn't run HPDET while the headphone is active.  The first
patch is a refactoring to make the extcon side easier.

----------------------------------------------------------------
Mark Brown (3):
      extcon: arizona: Factor out magic application
      ASoC: arizona: Fix interaction between headphone outputs and identification
      extcon: arizona: Fix interaction between headphone outputs and identification

 drivers/extcon/extcon-arizona.c  |  107 ++++++++++++++++++--------------------
 include/linux/mfd/arizona/core.h |    3 ++
 sound/soc/codecs/arizona.c       |   33 ++++++++++++
 sound/soc/codecs/arizona.h       |    3 ++
 sound/soc/codecs/wm5102.c        |    8 +--
 sound/soc/codecs/wm5110.c        |    8 +--
 6 files changed, 99 insertions(+), 63 deletions(-)

--dKeYJkA19bNVVKdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUcFXAAoJELSic+t+oim92ucP/RFV0ZxCQaUoC2PYshNMG2PY
IG6I9g0BqWN0qCEJID0hBvjzrh8lkudGdYJ3FGcPheNEtrCiIaFPZKueo152WX1T
H9oWviTZ+jFXkUqTbKDAvb1J5wdDMR+9bULYg13XEuc6RSpqDgQvqYaKcy2zGeST
T0Nqoqex+4GpX1Bt9oGicfEDVbp2ypDJSQyD4LxsFOtao0y5OhMcgfqp8ub28Zl9
eDMfPQT0Dxqbh3ftCDwcKNRGhKaebGLSLJiXxFmbZacqdf2Sh5BI8R/6deDY7CAd
Wso1gPt91vi0NOUrvMutS8/BHkJ3wWaeAqUWgNc0mlcYVeJ6Ng3ERvGFakup2oju
lw7RPyHd1ViRuoPtYAjDrm3HdHeXiKNntXqIndctqPnVPRKecFj85XXNvQCMxwsv
GynTq8iyKu781lDbb8h5K5lnWDyOvCFC0riGLLm17BLeMJA/1F/UfbjZjJtC0+Nl
jFCxGeN9ZxFdL+WbpvksVfmSn5vYjFtwC7uIVdqzGHxfu4bzQyiEiEwKhFEtkQWt
ErFaQMYpV8iZdp/ToJYmObBLjcckFbDsmORk+RONkz6SjsPDgU7XLFYK4Q8g63VI
48IC3pb7U0hA7STULQ5JazMlSJj9xOlxLXQgWa7w+5GphAM8hkiNvijRSUAGvxm/
zh+RL5anCuVzWzOQ5Mds
=gA3f
-----END PGP SIGNATURE-----

--dKeYJkA19bNVVKdr--
