Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab3GAJAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:00:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42988 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab3GAJAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:00:53 -0400
Date: Mon, 1 Jul 2013 10:00:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130701090029.GW27646@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svx3QcEFJ/nXZNtx"
Content-Disposition: inline
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [GIT PULL] regmap updates for v3.11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svx3QcEFJ/nXZNtx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d:

  Linux 3.10-rc7 (2013-06-22 09:47:31 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-v3.11

for you to fetch changes up to 7bc8c4c37aea74332b16ffb5412a8ad355d508ce:

  Merge remote-tracking branch 'regmap/topic/field' into regmap-next (2013-06-30 12:40:03 +0100)

----------------------------------------------------------------

regmap: Updates for v3.11

A small but useful set of regmap updates this time around:

- An abstraction for bitfields within a register map contributed by
  Srinivas Kandagatla, allowing drivers to cope more easily when
  hardware designers randomly move things about (mainly when talking
  to things like system controllers).

- Changes from Lars-Peter Clausen to allow the MMIO regmap to be used from
  hard IRQ context.

- Small improvements to the cache infrastructure and performance,
  including a default cache sync operation so now all regmaps can sync
  easily.

There's also a pinctrl driver making use of the new bitfield API, merged
here for dependency reasons.  There will be a simple add/add conflict
with the pinctrl tree as a result.

----------------------------------------------------------------
Axel Lin (1):
      pinctrl: st: Remove unnecessary use of of_match_ptr macro

Lars-Peter Clausen (2):
      regmap: regcache: Fixup locking for custom lock callbacks
      regmap: Make regmap-mmio usable from atomic contexts

Maarten ter Huurne (1):
      regmap: Implemented default cache sync operation

Mark Brown (11):
      regmap: Add support for discarding parts of the register cache
      regmap: Make regmap_check_range_table() a public API
      regmap: rbtree: Factor out node allocation
      regmap: rbtree: Use range information to allocate nodes
      regmap: debugfs: Don't mark lockdep as broken due to debugfs write
      regmap: core: Cache all registers by default when cache is enabled
      regmap: debugfs: Suppress cache for partial register files
      Merge remote-tracking branch 'regmap/topic/cache' into regmap-next
      Merge remote-tracking branch 'regmap/topic/core' into regmap-next
      Merge remote-tracking branch 'regmap/topic/debugfs' into regmap-next
      Merge remote-tracking branch 'regmap/topic/field' into regmap-next

Srinivas KANDAGATLA (1):
      pinctrl: st: Add pinctrl and pinconf support.

Srinivas Kandagatla (2):
      regmap: debugfs: Fix return from regmap_debugfs_get_dump_start
      regmap: Add regmap_field APIs

Wei Yongjun (1):
      pinctrl: st: fix return value check

 .../devicetree/bindings/pinctrl/pinctrl-st.txt     |  110 ++
 drivers/base/regmap/internal.h                     |   10 +
 drivers/base/regmap/regcache-rbtree.c              |   62 +-
 drivers/base/regmap/regcache.c                     |   83 +-
 drivers/base/regmap/regmap-debugfs.c               |    8 +-
 drivers/base/regmap/regmap.c                       |  156 ++-
 drivers/pinctrl/Kconfig                            |    6 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-st.c                       | 1403 ++++++++++++++++++++
 include/linux/regmap.h                             |   43 +
 include/trace/events/regmap.h                      |   23 +
 11 files changed, 1875 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-st.txt
 create mode 100644 drivers/pinctrl/pinctrl-st.c

--svx3QcEFJ/nXZNtx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0UUqAAoJELSic+t+oim90ekP/36x6kIk5ZfnWfmP3Eu8hvau
2pB5fFQ+rBLqsnFM7zHDkBXVEtpaTc4CBKS3XDbTf8JMQdI7QjyuEvzhHjfASGjy
AKsJDJNReGxQs3cK82+ntj1KDeLFia8dCE9TuISX3ldihOrQsW4oj7LsggL9NgHr
4hV+fjPVC4DsiEkEkwTJ7MfG+D67uSgX/qWwipRmF+kt1UZIzEtNcWnQojY5qCMw
HV8KQwaXIrBYHoU1Mh2hckpCD47PocTnfSVDu74bJeYn3E/mayCq7RPifdYljYcQ
TM2u2MdrAElTyAGArTTMD9K5SD5c1kUxD4REgwt1UbqLSqyPZFgv4Dt7YNg0ebrl
4a5U3iVfD/6hb202KTYzcpIqgtW/fgQUgJRkfdcIZ5/GBcNoNy52g5FgVujHXPeD
12kSh93NRt2DDYNm6TGEm1Czp9aDohwPLDUiWGyHZtOPfu/Kj8EtNDrwOilPk0bv
xf/wt0BYkS4Qr6bumJYKwQS/T4+EKGb5IQKY1ZVk4Prgb66AyCimKYIjZAhuwC+P
uiXpM1EKcfzXY5vqS6vxS29e4NJFmCkusG2/v187onHR0RADLsGAA4yk4d5HnKIr
RIYc7bQZthOQg4huZWOpExnW3PKjXL4tkKeTDZRoxLckhT4K3mGUTswVxkFKqkxJ
Qp/W2OKRUD81oJwtPrcX
=3XZ0
-----END PGP SIGNATURE-----

--svx3QcEFJ/nXZNtx--
