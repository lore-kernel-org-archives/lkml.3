Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3HUO4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:56:40 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50477 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3HUO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:56:39 -0400
Date: Wed, 21 Aug 2013 10:56:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [GIT PULL] (xen) stable/for-linus-3.11-rc6-tag
Message-ID: <20130821145630.GA21743@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.11-rc6-tag

which is full of bug-fixes that took a while to figure out right.
The signed git tag says it all:
<start>
 - On ARM did not have balanced calls to get/put_cpu.
 - Fix to make tboot + Xen + Linux boot correctly.
 - Fix events VCPU binding issues.
 - Fix a vCPU online race where IPIs are sent to not-yet-online vCPU.
<end>

The 'stable/for-linus-3.11' branch (from which this signed tag is) was
based on v3.10-rc1. Stefano merged the v3.10-rc2 as the fix from Julien
depended on features added during that time.

Please pull!

Thanks.

 arch/arm/xen/enlighten.c |  1 +
 arch/x86/xen/setup.c     | 22 ++++++++++++++++++++++
 arch/x86/xen/smp.c       | 11 +++++++++--
 drivers/xen/events.c     | 13 ++++++++++++-
 4 files changed, 44 insertions(+), 3 deletions(-)

Chuck Anderson (1):
      xen/smp: initialize IPI vectors before marking CPU online

David Vrabel (3):
      x86/xen: do not identity map UNUSABLE regions in the machine E820
      xen/events: initialize local per-cpu mask for all possible events
      xen/events: mask events when changing their VCPU binding

Julien Grall (1):
      xen/arm: missing put_cpu in xen_percpu_init

Stefano Stabellini (1):
      Merging v3.10-rc2 as I need to apply a fix for


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAEBAgAGBQJSFNUaAAoJEFjIrFwIi8fJVOwH/155pZS5vzzE9GbwdC9NMeJL
Kb9fP93mEoGmXW78B88Qc3PEIc6LyEZcqd+dyGcPpP2ZjqyYFOaiZtJmFJlUN+Du
7h9liA7fA5YQ6v/wKaIy+QcehmTbaAQApzTYJkMAu4aJefV3YCAMPmWOIvz3J81Z
V4+MoW6fJczK46ZQlAzIvffZhq/irfVQU30a97ImhsSgxWQT4z75at7G1+CtAC7Z
GfK3SAZDgB3uXYXPzHYjsWprL1ae2bY5GwOsNIPmfAJMY0qze2sLJDM9CezhnBht
5kMr5b/yBURkm333nh1VLQncQOgTlmMtW207WLtL/dDj1iJ7JujTklxT3U6yMmU=
=hmoH
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
