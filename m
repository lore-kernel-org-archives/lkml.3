Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaELKQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 06:16:06 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:38764 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbaELKQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 06:16:04 -0400
X-IronPort-AV: E=Sophos;i="4.97,1034,1389744000"; 
   d="scan'208";a="129289027"
From: David Vrabel <david.vrabel@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <xen-devel@lists.xenproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 0/2] dma,x86,xen: fix dma_get_required_mask() when dma != phys address
Date: Mon, 12 May 2014 11:15:40 +0100
Message-ID: <1399889742-26165-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 uses the generic dma_get_required_mask() which assumes that DMA
address == physical address.  For Xen PV guests this is not the case
and certain drivers will cause excessive use of the SWIOTLB.

Patch #1 is a straight forward refactoring of a common function.

Patch #2 addes the required arch-specific implementation of
dma_get_required_mask() to x86.

David

