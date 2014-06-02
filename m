Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbaFBLkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:40:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:40762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaFBLkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:40:33 -0400
Date: Mon, 2 Jun 2014 13:40:28 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [GIT PULL] HSI changes for 3.16
Message-ID: <20140602114028.GA23504@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull the following changes for the HSI subsystem, which I
have taken over from Carlos Chinea <carlos.chinea@nokia.com>.

The below patches have been worked on in the linux-omap mailinglist
for 10 months and are well tested in linux-next (have been in there
for more than two weeks) without any problems arising. Apart from
that potential regressions are very limited, because the subsystem
is not yet used by any platform in the mainline kernel.

-- Sebastian

The following changes since commit d1db0eea852497762cab43b905b879dfcd3b8987:

  Linux 3.15-rc3 (2014-04-27 19:29:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sre/linux-hsi.git tags/hsi-for-3.16

for you to fetch changes up to eafaebd987fcd001e2c123c050939a29c625d673:

  HSI: Introduce Nokia N900 modem driver (2014-05-16 00:55:42 +0200)

----------------------------------------------------------------
HSI changes for the v3.16 series:

 - Add some documentation for the HSI subsystem

 - Add Device Tree support for the HSI subsystem

 - Add OMAP3 SSI driver (SSI is a legacy variant of HSI)

 - Add Nokia N900 Modem driver (without speech support for now)

----------------------------------------------------------------
Sebastian Reichel (11):
      Documentation: HSI: Add some general description for the HSI subsystem
      MAINTAINERS: update HSI entry
      HSI: hsi-char: fix driver for multiport scenarios
      HSI: method to unregister clients from an hsi port
      HSI: Add channel resource support to HSI clients
      HSI: export method to (un)register clients
      HSI: Add common DT binding for HSI client devices
      HSI: Introduce OMAP SSI driver
      Documentation: DT: omap-ssi binding documentation
      HSI: Introduce driver for SSI Protocol
      HSI: Introduce Nokia N900 modem driver

 Documentation/devicetree/bindings/hsi/client-devices.txt |   44 +++
 Documentation/devicetree/bindings/hsi/nokia-modem.txt    |   57 ++++
 Documentation/devicetree/bindings/hsi/omap-ssi.txt       |   97 ++++++
 Documentation/hsi.txt                                    |   75 +++++
 MAINTAINERS                                              |    4 +-
 drivers/hsi/Kconfig                                      |    1 +
 drivers/hsi/Makefile                                     |    1 +
 drivers/hsi/clients/Kconfig                              |   17 ++
 drivers/hsi/clients/Makefile                             |    4 +-
 drivers/hsi/clients/hsi_char.c                           |   14 +-
 drivers/hsi/clients/nokia-modem.c                        |  285 ++++++++++++++++++
 drivers/hsi/clients/ssi_protocol.c                       | 1191 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hsi/controllers/Kconfig                          |   19 ++
 drivers/hsi/controllers/Makefile                         |    6 +
 drivers/hsi/controllers/omap_ssi.c                       |  625 +++++++++++++++++++++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi.h                       |  166 +++++++++++
 drivers/hsi/controllers/omap_ssi_port.c                  | 1399 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h                  |  171 +++++++++++
 drivers/hsi/hsi.c                                        |  275 ++++++++++++++++-
 include/linux/hsi/hsi.h                                  |   39 ++-
 include/linux/hsi/ssi_protocol.h                         |   42 +++
 21 files changed, 4513 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hsi/client-devices.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/nokia-modem.txt
 create mode 100644 Documentation/devicetree/bindings/hsi/omap-ssi.txt
 create mode 100644 Documentation/hsi.txt
 create mode 100644 drivers/hsi/clients/nokia-modem.c
 create mode 100644 drivers/hsi/clients/ssi_protocol.c
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h
 create mode 100644 include/linux/hsi/ssi_protocol.h

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTjGKsAAoJENju1/PIO/qaJ6AQAIHlotUwIfHXkjrLvPjKlkNt
IhoAWaOq+4DwXx84WHCa5HxgYBc39vlJrQxAHMAuCSFv126hOOiO5Kwgmjs9Brj3
jRUXAFgAcIfTObRmOsnNyIg2Zug3l1V6t8oMxvFUZCTRbz0M9NoOCtMuQlQKasKJ
dyUBrDUy10HU20qqstcnoyV/utAd1a2LY8Z8DVgoq/ga7LxSbJ73TCozGDN5fUL9
WELlKPZy2NMKppYeOB8YEZyvTOg9BwUjrznE9Xi3d0ZgqJ54WX/hZ6n58/se/7vq
OUAKczz6zMFB3wvP9aMUyiDmlYUxqxxzpS92RwMSSlBJ5hw8Ha34RzBgtjTrLIdB
02Xcsm3QIMLkkqU4AnHESfrmofXQGui3uDN+Su0Kb7f4wUtT1D8pJkEjpI/whkeB
F9j8hXPil6eTHSz9LeRUOMKeBK685+T061+fId150SOfIPPOLGRDyPQRzCp5D27i
eVigN5HOOhz/PX3cCydijzM/5/0jgqQvI26VH6Lpnr5BwxbD+VDRJfN7MD2/EcHY
93Sncr1d48q7weDr2AqAmFTItTjGCi56Z1xPaqkPlKSWwvW2ZnG/Q/xFo78Pa7B8
S1kO33dTld5BVqSWUnpws6IN+Zc4cH2ZXK/cPDNxN1z5epvH5in5NOX5YOGA4K2b
fXwNNc0JyLX4Tdb1tynA
=spgt
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
