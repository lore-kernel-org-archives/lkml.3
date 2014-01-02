Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaABWo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:44:27 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28538 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbaABWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:44:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,593,1384297200"; 
   d="scan'208";a="51446859"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: alsa-devel@alsa-project.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/3] use named constants for pci_power_t values
Date: Fri,  3 Jan 2014 00:40:28 +0100
Message-Id: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace numbers by named constants.  The complete semantic patch used is as
follows (http://coccinelle.lip6.fr/):

// <smpl>
@@
expression pdev;
@@

pci_set_power_state(pdev,
(
- 0
+ PCI_D0
|
- 1
+ PCI_D1
|
- 2
+ PCI_D2
|
- 3
+ PCI_D3hot
|
- 4
+ PCI_D3cold
|
- 5
+ PCI_UNKNOWN
|
- -1
+ PCI_POWER_ERROR
)
 )

@@
expression e1,e2;
@@

pci_enable_wake(e1,
(
- 0
+ PCI_D0
|
- 1
+ PCI_D1
|
- 2
+ PCI_D2
|
- 3
+ PCI_D3hot
|
- 4
+ PCI_D3cold
|
- 5
+ PCI_UNKNOWN
|
- -1
+ PCI_POWER_ERROR
)
,e2)
// </smpl>

