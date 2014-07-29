Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaG2Kpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:45:34 -0400
Received: from 8bytes.org ([81.169.241.247]:49878 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaG2Kpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:45:32 -0400
Date: Tue, 29 Jul 2014 12:45:31 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg Edwards <gedwards@ddn.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iommu/vt-d: race setting IRQ CPU affinity while
 freeing IRQ
Message-ID: <20140729104531.GB9809@8bytes.org>
References: <20140722142719.GA28143@psuche.datadirectnet.com>
 <20140723144024.GA14017@8bytes.org>
 <20140723144917.GA26986@psuche.datadirectnet.com>
 <20140723151040.GB14017@8bytes.org>
 <20140723161326.GB32422@psuche.datadirectnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723161326.GB32422@psuche.datadirectnet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 10:13:26AM -0600, Greg Edwards wrote:
> A user process setting the CPU affinity of an IRQ for a KVM
> direct-assigned device via /proc/irq/<IRQ#>/smp_affinity can race with
> the IRQ being released by QEMU, resulting in a NULL iommu pointer
> dereference in get_irte().

Maybe I wasn't clear enough, what I am missing is a panic message with a
backtrace from the NULL pointer deref you are seeing in the commit
message.

Also I am still wondering why it is possible to set affinity from
userspace while the irq is about to be freed. Shouldn't the proc files
are already unregistered when the irq is freed?


	Joerg

