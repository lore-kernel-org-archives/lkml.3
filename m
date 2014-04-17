Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaDQRGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:06:48 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:63344 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaDQRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:06:45 -0400
Date: Thu, 17 Apr 2014 13:06:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Milburn <dmilburn@redhat.com>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ahci: Do not receive interrupts sent by dummy ports
Message-ID: <20140417170641.GR15326@htj.dyndns.org>
References: <cover.1397750166.git.agordeev@redhat.com>
 <dbaed51ffe73dec1966eba256c3b42ed22ed58f3.1397750166.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbaed51ffe73dec1966eba256c3b42ed22ed58f3.1397750166.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 06:06:15PM +0200, Alexander Gordeev wrote:
> In multiple MSI mode all AHCI ports (including dummy) get
> assigned separate MSI vectors and (as result of execution
> pci_enable_msi_exact() function) separate IRQ numbers,
> (mapped to the MSI vectors).
> 
> Therefore, although interrupts from dummy ports are not
> desired they are still enabled. We do not request IRQs
> for dummy ports, but that only means we do not assign
> AHCI-specific ISRs to corresponding IRQ numbers.
> 
> As result, dummy port interrupts still could come and
> traverse all the way from the PCI device to the kernel,
> causing unnecessary overhead.
> 
> This update disables IRQs for dummy ports and prevents
> the described issue.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: David Milburn <dmilburn@redhat.com>
> Cc: linux-ide@vger.kernel.org

David, can you please test the patch?

Thanks.

-- 
tejun
