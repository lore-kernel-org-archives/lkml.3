Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbbALKCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:02:42 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44665 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbbALKCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:02:40 -0500
Date: Mon, 12 Jan 2015 11:02:39 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] moving from pci to dma
Message-ID: <20150112100239.GA9009@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

