Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaLDV2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:28:43 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58594 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaLDV2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:28:42 -0500
Subject: [PATCH 0/5] pcmcia: 64bit fixes, anonymous cards, other bugs
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:28:30 +0000
Message-ID: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches update the PCMCIA layer to work on 64bit machines and also to
support anonymous memory cards (a feature that was broken in the conversion
from the old pcmcia_cs model to the pccard drivers).

In addition they fix various bugs found during the work, and provide an
alternative rather less hideously convoluted resource manager that gets used
when the only PCMCIA present is via PCI bridges. In that situation the core
pci layer can do the job perfectly well for us and just needs a bit of
wrapping.

Alan

---

Alan Cox (5):
      pcmcia: correct types
      pcmcia cis: on an out of range CIS read return 0xff, don't just warn
      pcmcia: Fix requery
      pcmcia: handle anonymous cards by generating a fake CIS
      pcmcia: add a new resource manager for non ISA systems


 drivers/pcmcia/Kconfig       |   12 ++-
 drivers/pcmcia/Makefile      |    1 
 drivers/pcmcia/cistpl.c      |   31 ++++++--
 drivers/pcmcia/cs_internal.h |    6 +
 drivers/pcmcia/ds.c          |    3 +
 drivers/pcmcia/rsrc_mgr.c    |    5 +
 drivers/pcmcia/rsrc_pci.c    |  172 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 216 insertions(+), 14 deletions(-)
 create mode 100644 drivers/pcmcia/rsrc_pci.c

--
"Writing in comic sans is like talking earnestly whilst you have hiccups"
