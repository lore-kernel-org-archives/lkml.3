Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbbALQJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:09:55 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59209 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbbALQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:09:53 -0500
Date: Mon, 12 Jan 2015 17:09:52 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] moving from pci to dma
Message-ID: <20150112160952.GA11353@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second version of this patch fix a mistake in the numbering of the
mails. The following paragraphs are the original cover letter of this
patch.

This patch replaces the references to the deprecated pci api with the
corresponding dma api.

To ensure that it was possible to access the dev field of pci_dev without
checking for nullity we looked for similar access in the execution
flow.

The most straight forward are "&id->dev" and "pci_get_drvdata(id)" where
id is the variable whose type is pci_dev.

We also found "pci_enable_device(id)" to be satisfying since the call
accesses other field without checking for nullity.

Quentin Lambert (1):
  atm: remove deprecated use of pci api

 drivers/atm/eni.c       | 8 +++++---
 drivers/atm/he.c        | 2 +-
 drivers/atm/lanai.c     | 9 +++++----
 drivers/atm/nicstar.c   | 4 ++--
 drivers/atm/solos-pci.c | 2 +-
 drivers/atm/zatm.c      | 8 +++++---
 6 files changed, 19 insertions(+), 14 deletions(-)

-- 
1.9.1

