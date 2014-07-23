Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbaGWOtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:49:24 -0400
Received: from legacy.ddn.com ([64.47.133.206]:36713 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbaGWOtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:49:21 -0400
Date: Wed, 23 Jul 2014 08:49:17 -0600
From: Greg Edwards <gedwards@ddn.com>
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iommu/vt-d: fix race between free_irte() and get_irte()
Message-ID: <20140723144917.GA26986@psuche.datadirectnet.com>
References: <20140722142719.GA28143@psuche.datadirectnet.com>
 <20140723144024.GA14017@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140723144024.GA14017@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.32.22.129]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 04:40:24PM +0200, Joerg Roedel wrote:
> On Tue, Jul 22, 2014 at 08:27:19AM -0600, Greg Edwards wrote:
>> get_irte() can race with free_irte() and dereference a NULL iommu
>> pointer.
>
> Have you seen any real occurance of this race? Get_irte is called in the
> set_affinity path, how can that race with the irq being freed?

Yes, that's how we hit it.  A process was setting the CPU affinity while
QEMU was releasing the IRQ.  We have a CI stress test that turned this
up.

Greg
