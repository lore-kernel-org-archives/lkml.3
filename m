Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3IEPom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:44:42 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:45800 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753439Ab3IEPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:44:40 -0400
Date: Thu, 5 Sep 2013 11:44:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130905154436.GC24148@htj.dyndns.org>
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

Hello,

On Thu, Sep 05, 2013 at 05:40:42PM +0200, Alexander Gordeev wrote:
> On Thu, Sep 05, 2013 at 11:04:42AM -0400, Tejun Heo wrote:
> > The thing is, do we even have cases where arch code returns positive
> > return to indicate possible partial allocation?  If not, the whole
> > interface is convoluted for no good reason and we can just make
> > everything return 0 or -errno, which is a lot simpler.  No?
> 
> As I mentioned in my other note, at least PPC has a concept of MSI quota,
> so exceeding it would be the very case, I believe.

Given that multiple MSI is something which isn't too popular / already
superseded and that the condition is highly unlikely, do we really
care about possible partial success?  This sort of interface is
unnecessarily complex and actively harmful.  It forces all users to
wonder what could possibly happen and implement all sorts of nutty
fallback logic which is highly likely to be error-prone on both the
software and hardware side.  Seriously, how much testing would such
code path would get both on the driver and firmware sides?

It's an operation which isn't too likely to fail with a firm
known-to-work fallback.  It's pointless and error-prone to try to
extract the last point zero zero one percent.

Thanks.

-- 
tejun
