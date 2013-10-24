Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3JXO3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 10:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab3JXO3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 10:29:24 -0400
Date: Thu, 24 Oct 2013 16:31:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131024143108.GB26610@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
 <20131024105158.GB13159@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024105158.GB13159@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:51:58AM +0100, Tejun Heo wrote:
> I haven't looked into any details but, if the above works for most use
> cases, it looks really good to me.

Well, if we reuse Michael's statistics:

 - 58 drivers call pci_enable_msix()
 - 24 try a single allocation and then fallback to MSI/LSI
 - 19 use the loop style allocation
 - 14 try an allocation, and if it fails retry once

...then I expect most of 19/58 (loop style) could be converted to
pcim_enable_msix() and pcim_enable_msix_range() and all of 14/58
(single fallback) should be converted to pcim_enable_msix() users.

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
