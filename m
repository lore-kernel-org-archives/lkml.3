Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaD3A7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:59:42 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:59596 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaD3A7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:59:40 -0400
Subject: [PATCH 0/7] PCI: BAR sizing fixes
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 18:59:38 -0600
Message-ID: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are intended to fix some corner-case BAR sizing issues: cases where
resource_size_t or dma_addr_t is too small to handle a BAR larger than 4GB
or one placed above 4GB.  There's also a message clarification in the
resource sanity check and a subtractive bridge window fix.

Comments welcome.

---

Bjorn Helgaas (7):
      PCI: Fail safely if we can't handle BARs larger than 4GB
      PCI: Reject BAR above 4GB if dma_addr_t is too small
      PCI: Don't convert BAR address to resource if dma_addr_t is too small
      PCI: Don't set BAR to zero if dma_addr_t is too small
      PCI: Don't print anything while decoding is disabled
      resources: Clarify sanity check message
      PCI: Don't add disabled subtractive decode bus resources


 drivers/pci/probe.c |   48 +++++++++++++++++++++++++++++-------------------
 kernel/resource.c   |    7 ++-----
 2 files changed, 31 insertions(+), 24 deletions(-)
