Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbaGWOk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:40:29 -0400
Received: from 8bytes.org ([81.169.241.247]:55792 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964AbaGWOk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:40:28 -0400
Date: Wed, 23 Jul 2014 16:40:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Greg Edwards <gedwards@ddn.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/vt-d: fix race between free_irte() and get_irte()
Message-ID: <20140723144024.GA14017@8bytes.org>
References: <20140722142719.GA28143@psuche.datadirectnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722142719.GA28143@psuche.datadirectnet.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 08:27:19AM -0600, Greg Edwards wrote:
> get_irte() can race with free_irte() and dereference a NULL iommu
> pointer.

Have you seen any real occurance of this race? Get_irte is called in the
set_affinity path, how can that race with the irq being freed?


	Joerg

