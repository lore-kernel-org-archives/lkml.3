Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3IESwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:52:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab3IESwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:52:46 -0400
Date: Thu, 5 Sep 2013 20:54:40 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
 <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
 <20130905130902.GA26314@htj.dyndns.org>
 <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905154436.GC24148@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 11:44:36AM -0400, Tejun Heo wrote:
> Given that multiple MSI is something which isn't too popular / already
> superseded and that the condition is highly unlikely, do we really
> care about possible partial success?  This sort of interface is
> unnecessarily complex and actively harmful.  It forces all users to
> wonder what could possibly happen and implement all sorts of nutty
> fallback logic which is highly likely to be error-prone on both the
> software and hardware side.  Seriously, how much testing would such
> code path would get both on the driver and firmware sides?
> 
> It's an operation which isn't too likely to fail with a firm
> known-to-work fallback.  It's pointless and error-prone to try to
> extract the last point zero zero one percent.

I assume reasons for having this type of interface at the moment of
taking design decision about pci_enable_msi_block() still hold true.
I do not know what those reasons were, but I think the fact multiple
MSIs are rarely used and MSI-X exists does not invalidate them now.

I did consider the other argument - since pci_enable_msi_block_part()
is explicitly provided with a value of MME the caller will not be
satisfied with any other value and hence a repeated call with a lesser
MME does not make sense for the caller. Therefore we could just fail
in case the architecture returned a positive value. Same result, but
different reasoning.

At the moment I still prefer pci_enable_msi_block_part() to be similar
to pci_enable_msi_block(). I do agree the fallback logic is error-prone,
but I would not dare to scrap it all right away.

Bjorn?

> 
> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
