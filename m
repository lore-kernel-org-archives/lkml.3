Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaFMWU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:20:27 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:44695 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaFMWU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:20:26 -0400
Date: Fri, 13 Jun 2014 19:20:20 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull request: bluetooth 2014-06-13
Message-ID: <20140613222020.GD1944@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

This is our first batch of fixes for 3.16. Be aware that two patches here
are not exactly bugfixes:

* 71f28af57066 Bluetooth: Add clarifying comment for conn->auth_type
This commit just add some important security comments to the code, we found
it important enough to include it here for 3.16 since it is security related.

* 9f7ec8871132 Bluetooth: Refactor discovery stopping into its own function
This commit is just a refactor in a preparation for a fix in the next
commit (f8680f128b).

All the other patches are fixes for deadlocks and for the Bluetooth protocols,
most of them related to authentication and encryption

This is rebased on net.git of yesterday, so we need you to pull it first and then
pull from us. This rebase was necessary for us.

Please pull or let me know of any concerns you may have. Thanks!

	Gustavo

---
The following changes since commit f9da455b93f6ba076935b4ef4589f61e529ae046:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-06-12 14:27:40 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git for-upstream

for you to fetch changes up to 92d1372e1a9fec00e146b74e8b9ad7a385b9b37f:

  Bluetooth: Allow change security level on ATT_CID in slave role (2014-06-13 14:36:39 +0200)

----------------------------------------------------------------
Johan Hedberg (9):
      Bluetooth: Fix incorrectly overriding conn->src_type
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Add clarifying comment for conn->auth_type
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Refactor discovery stopping into its own function
      Bluetooth: Reuse hci_stop_discovery function when cleaning up HCI state
      Bluetooth: Fix locking of hdev when calling into SMP code

Jukka Taimisto (1):
      Bluetooth: Fix deadlock in l2cap_conn_del()

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

 net/bluetooth/hci_conn.c   |   7 +---
 net/bluetooth/hci_event.c  |  17 ++++++++--
 net/bluetooth/l2cap_core.c |   8 ++++-
 net/bluetooth/l2cap_sock.c |   5 ---
 net/bluetooth/mgmt.c       | 104 ++++++++++++++++++++++++++++++++----------------------------
 net/bluetooth/smp.c        |   9 ++++--
 6 files changed, 85 insertions(+), 65 deletions(-)


--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTm3kjAAoJEPs3PUX4s20oKz0QAKG5jctJcX4Zyh1195X3+hrF
VlO3Y62Y98HJfd1ewRrP/qFXooXhjgD+gBYjMSAZIsMqrplwJuky2fH9coi/mTeo
DVcpOks69HgIdO18vL54RICXlJI3kI0KJMXBhpGbMITQxuRFrRybCUJXd3edJc2O
WQyFu12jOILvRRZN5MzLQZL02Bs4edNsMiYZM4rwkHTxuaCxRV9eMdYq71tMk3sm
JGHJQDG0vA5TEckkOBEQS245bS7NE5+JovggYyTrYyGT3MdwfNkYkZ3fqnOsP1L3
HED3zf37Y8zpoiQ/zhWBftMD7bPUoKkNdyqzDPJ0wWbkaKCGT/Q0PytB26j+z9+m
g4qDf3ekYsFFYYZUVuMdvaTCrKJfErG7vo8rsFh0KyyopJ6edjBwqiwuLM7tx0Bw
jyrjmPnes2zrw61+yBttTEWJUkTmV4JnTNZyunXOEYGAxF0QUU7yXWoLcnyuJG1k
Cr8eswiRzVzqmdoojfpbci+YIZxuMXqg+DXQEDd9aBRCHxLj546NZXJ8geatJXpQ
iFBIdNAh92hXcD0QAZVjcFFKKyPSC+U9IwT34ycytcQmiDetCPRAn4tfkbkWPgOy
WUp/tGxfg0Rf3FgfrdcTxuyThfNQXbSTb7xQsNbrMmwj93g9cviqPzlAkCq8gu17
In6Ew435ZQ2AWbvJKJn7
=IUyB
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
