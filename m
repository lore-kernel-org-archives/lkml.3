Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaDNSI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:08:28 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:6717 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaDNSI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:08:26 -0400
Message-ID: <1397498902.31076.15.camel@buesod1.americas.hpqcorp.net>
Subject: Re: hpsa driver bug crack kernel down!
From: Davidlohr Bueso <davidlohr@hp.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bhe@redhat.com" <bhe@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "James.Bottomley@hansenpartnership.com" 
	<James.Bottomley@hansenpartnership.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>,
        Linda Knippers <linda.knippers@hp.com>, aswin@hp.com
Date: Mon, 14 Apr 2014 11:08:22 -0700
In-Reply-To: <534BA30B.5040102@linux.intel.com>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
	 <1397084904.9519.62.camel@dabdike> <1397085044.9519.63.camel@dabdike>
	 <1397086817.2608.25.camel@buesod1.americas.hpqcorp.net>
	 <1397087425.9519.67.camel@dabdike>
	 <1397089180.2608.27.camel@buesod1.americas.hpqcorp.net>
	 <CAErSpo4H=hcro8sMnt2MzDDVCROpASuUTQWBw37OxodHTyOfyw@mail.gmail.com>
	 <1397111557.2608.29.camel@buesod1.americas.hpqcorp.net>
	 <20140410071535.GX13491@8bytes.org>
	 <1397119587.19944.14.camel@shinybook.infradead.org>
	 <1397146781.2608.46.camel@buesod1.americas.hpqcorp.net>
	 <534BA30B.5040102@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 16:57 +0800, Jiang Liu wrote:
> Hi all,
> 	I guess I found the root cause. It's a bug in matching
> device scope, variable 'level' should be decreased when walking up PCI
> topology.
> 	Could you please help to test following patch?
> Thanks!
> Gerry

Worked like a charm -- I no longer see all those DMAR messages and the
hpsa hard lockup is gone, thanks. Feel free to add my:

Reported-and-tested-by: Davidlohr Bueso <davidlohr@hp.com>

