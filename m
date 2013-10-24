Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab3JXKwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:52:07 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:38678 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003Ab3JXKwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:52:05 -0400
Date: Thu, 24 Oct 2013 11:51:58 +0100
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131024105158.GB13159@mtj.dyndns.org>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Fri, Oct 18, 2013 at 07:12:12PM +0200, Alexander Gordeev wrote:
> So i.e. the request loop described in the documentation...
> 
> 	int foo_driver_enable_msix(struct foo_adapter *adapter,
> 				   int nvec)
> 	{
> 		while (nvec >= FOO_DRIVER_MINIMUM_NVEC) {
> 			rc = pci_enable_msix(adapter->pdev,
> 					     adapter->msix_entries,
> 					     nvec);
> 			if (rc > 0)
> 				nvec = rc;
> 			else
> 				return rc;
> 		}
> 
> 		return -ENOSPC;
> 	}
> 
> ...would turn into a single helper call....
> 
> 	rc = pcim_enable_msix_range(adapter->pdev,
> 				    adapter->msix_entries,
> 				    nvec,
> 				    FOO_DRIVER_MINIMUM_NVEC);

I haven't looked into any details but, if the above works for most use
cases, it looks really good to me.

Thanks!

-- 
tejun
