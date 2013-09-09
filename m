Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3IIPna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:43:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3IIPn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:43:28 -0400
Date: Mon, 9 Sep 2013 17:45:22 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130909154522.GA13855@dhcp-26-207.brq.redhat.com>
References: <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130909153754.GG25434@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909153754.GG25434@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 11:37:54AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 09, 2013 at 05:20:44PM +0200, Alexander Gordeev wrote:
> > The series is what it seems a direction to take.
> 
> It can definitely use better descriptions explaining why this is
> happening but the general direction seems good to me.

Oh, those are not even tested. Did not want turn to drivers before
the interface/direction generally agreed.

> > Looks like we need PPC folks to agree on the quota check update
> > for pSeries (yes, they do bail out with a positive return value
> > from arch_msi_check_device()):
> > 
> > 	quota = msi_quota_for_device(pdev, nvec);
> > 
> > 	if (quota && quota < nvec)
> > 		return quota;
> 
> I think it should return -ENOSPC.

Absolutely, in patch #2 :)

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
