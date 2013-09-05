Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3IEPBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:01:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3IEPBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:01:06 -0400
Date: Thu, 5 Sep 2013 17:03:00 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
 <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
 <20130905130902.GA26314@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905130902.GA26314@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 09:09:02AM -0400, Tejun Heo wrote:
> Hello, Alexander.
> 
> On Thu, Sep 05, 2013 at 02:52:47PM +0200, Alexander Gordeev wrote:
> One curiosity - with the above factored out, is
> pci_enable_msi_block_part() returning positive number still necessary?
> I followed most of code paths in x86 and nothing seems to need it and
> positive return seems to be just causing confusion - ie. returning 1
> on multiple msi config failure from some functions, which is silly.

You mean we could treat positive numbers returned by architecture as
failures and translate it into negative error codes?
If so, I would prefer not to do this for two reasons:
1. It will not be possible to call pci_enable_msi_block_part() in a loop.
   Although there are no consumers right now I think the very possibility
   is better to keep.
2. The semantics of pci_enable_msi_block_part() is very close to
   pci_enable_msi_block(). I believe having a consisting interface for
   these two helps readability.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
