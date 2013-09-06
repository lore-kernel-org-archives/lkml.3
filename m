Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab3IFNPs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 09:15:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab3IFNPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 09:15:45 -0400
Date: Fri, 6 Sep 2013 15:17:40 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130906131739.GA27922@dhcp-26-207.brq.redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
 <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
 <20130905130902.GA26314@htj.dyndns.org>
 <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 05:40:41PM +0200, Alexander Gordeev wrote:
> On Thu, Sep 05, 2013 at 11:04:42AM -0400, Tejun Heo wrote:
> > The thing is, do we even have cases where arch code returns positive
> > return to indicate possible partial allocation?  If not, the whole
> > interface is convoluted for no good reason and we can just make
> > everything return 0 or -errno, which is a lot simpler.  No?
> 
> As I mentioned in my other note, at least PPC has a concept of MSI quota,
> so exceeding it would be the very case, I believe.

An update here. No other arch supports multiple MSIs besides Intel (+IOMMU).
Yet, ironically, the concept of possible partial allocation was adopted from
MSI-X. I briefly checked all archs and it seems none of them throws out a
possible other number of MSIs > 1 (including PPC I mistakenly read).

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
