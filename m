Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbbAWN1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:27:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbbAWN11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:27:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, arnd@arndb.de, jkosina@suse.cz,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Keyrings, modsigning adjustments
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27883.1422019625.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 23 Jan 2015 13:27:05 +0000
Message-ID: <27884.1422019625@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Could you pull these into security/next?  There are the following pieces:

 (1) Make /proc/keys unconditional as it's used by libkeyutils now.

 (2) Reduce the verbosity of the ASN.1 compiler and the X.509 certificate
     collection during building.

Thanks,
David
---
The following changes since commit 961be7ef6963806cb978ccd6acf6bf84b0c63346:

  tpm/tpm_tis: Add missing ifdef CONFIG_ACPI for pnp_acpi_device (2015-01-22 13:37:33 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20150123

for you to fetch changes up to e994393acd65e729a574aaca466eab22b5b39cc6:

  X.509: silence asn1 compiler debug output (2015-01-23 12:10:39 +0000)

----------------------------------------------------------------
Keyrings changes for next

----------------------------------------------------------------
Arnd Bergmann (2):
      X.509: shut up about included cert for silent build
      X.509: silence asn1 compiler debug output

David Howells (1):
      KEYS: Make /proc/keys unconditional if CONFIG_KEYS=y

 Documentation/security/keys.txt |  2 --
 kernel/Makefile                 |  2 +-
 scripts/asn1_compiler.c         | 30 +++++++++++++++++++-----------
 security/keys/Kconfig           | 18 ------------------
 security/keys/proc.c            |  8 --------
 5 files changed, 20 insertions(+), 40 deletions(-)
