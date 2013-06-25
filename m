Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403Ab3FYJfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:35:46 -0400
Received: from 8bytes.org ([85.214.48.195]:40678 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab3FYJfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:35:45 -0400
Date: Tue, 25 Jun 2013 11:35:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: James Georgas <james.georgas@yahoo.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Integrated MegaRAID controller and AMD IOMMU issue
Message-ID: <20130625093542.GR11309@8bytes.org>
References: <FA29E63A-76F3-4F53-8945-59E47BC8C4E4@yahoo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA29E63A-76F3-4F53-8945-59E47BC8C4E4@yahoo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Jun 25 11:35:43 2013
X-DSPAM-Confidence: 0.9955
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c9646f20864878855447
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Tue, Jun 25, 2013 at 12:12:53AM -0600, James Georgas wrote:
> I discussed the issue with an LSI engineer, and he said that since the
> integrated controller uses system memory, which it gets from the BIOS
> during initialization, there will be issues with the IOMMU. I assume
> he is referring to DMA address problems due to IOMMU translation.

Looks like the problem is in the LSI driver. The driver needs to dma-map
the system memory it gets from the BIOS (for example with dma_map_single)
and use the dma_handle returned for transactions. Otherwise the IOMMU
will block the accesses from the device and make it unusable.


	Joerg


