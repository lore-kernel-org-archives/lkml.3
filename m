Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaHHNzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 09:55:08 -0400
Received: from isis.lip6.fr ([132.227.60.2]:56534 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbaHHNzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 09:55:02 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: bhelgaas@google.com
Cc: benoit.taine@lip6.fr, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/1] Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri,  8 Aug 2014 15:56:02 +0200
Message-Id: <1407506163-8371-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 08 Aug 2014 15:54:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `const struct pci_device_id` over
`DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
This issue was reported by checkpatch.

A simplified version of the semantic patch that makes this change is as
follows (http://coccinelle.lip6.fr/):

// <smpl>

@@
identifier i;
declarer name DEFINE_PCI_DEVICE_TABLE;
initializer z;
@@

- DEFINE_PCI_DEVICE_TABLE(i)
+ const struct pci_device_id i[]
= z;

// </smpl>

I previously sent parts of this patch to check wether or not it was
worth sending, and Bjorn answered:
> Benoit, how about if you wait until about half-way through the merge
> window after v3.16 releases, generate an up-to-date single patch, and
> post that?  Then we can try to get it in before v3.17-rc1 to minimize
> merge hassles.

So here it is, based on linux-next on 2014-08-07.

