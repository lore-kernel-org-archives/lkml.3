Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545Ab3DYVS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:18:27 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:27826 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab3DYVS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:18:26 -0400
X-Greylist: delayed 430 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2013 17:18:26 EDT
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] Add aix lvm partitions support
Date: Thu, 25 Apr 2013 23:10:24 +0200
Message-Id: <1366924229-21569-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches serie implements a mapping from AIX LVM logical volumes
to linux partitions, for AIX disks from versions AIX 3 & AIX 4,
maybe later versions also, but this has not been tested.

Because the LVM layer of AIX allows logical volumes to be made of
separate so-called physical partitions which can be anywhere on the
disk, and allows up to 256 logical volumes, while Linux allows
only 16 partitions per disk, partitions which must be contiguous,
only a subset of the AIX logical volumes found can be mappedi to linux
partitions, but that's enough to make it usefull in real life.

AIX partitions discovery has been grafted to the msdos partitions
code, because AIX disks often contain an msdos partition table,
and this grafting avoids removal of the AIX protection already
included in msdos.c while avoiding code duplication.

Comments welcome

Philippe

PS: a companion AIX JFS fs read-only driver will follow

[PATCH 1/5] partitions/msdos.c: end-of-line whitespace and semicolon cleanup
[PATCH 2/5] Add aix lvm partitions support files
[PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
[PATCH 4/5] partitions/Makefile: compile aix.c if configured.
[PATCH 5/5] partitions/Kconfig: add the AIX_PARTITION entry
