Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbaKUBcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:32:50 -0500
Received: from www.linutronix.de ([62.245.132.108]:54108 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaKUBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:32:49 -0500
Date: Fri, 21 Nov 2014 02:32:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
cc: jiang.liu@linux.intel.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] irqdomain: Fix NULL pointer dererence in
 irq_domain_free_irqs_parent
In-Reply-To: <1416531745-24661-1-git-send-email-suravee.suthikulpanit@amd.com>
Message-ID: <alpine.DEB.2.11.1411210219370.6439@nanos>
References: <1416531745-24661-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, suravee.suthikulpanit@amd.com wrote:
> This patch checks if the parent domain is NULL before recursively freeing
> irqs in the parent domains.

Which is nonsense, because if the thing has not been allocated in the
first place, then it cannot explode in the free path magically, except
there is a missing check in the allocation path error handling.
 
And that's obviously not the case simply because this originates from:
> [<fffffe0000449278>] pci_disable_msix+0x40/0x50
 
Suravee, this is the last warning. I'm tired of your half baken
patches which lack any explanation. Read back on my previous replies
to your mails for further explanation.

This is not a 'try and error and hack enough nonsensical checks into
the code' commercial project.

This is core kernel code and requires proper explanation.

Thanks,

	tglx
