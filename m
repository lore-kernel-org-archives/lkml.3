Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab3IFQG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 12:06:29 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:56499 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3IFQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 12:06:26 -0400
Date: Fri, 6 Sep 2013 12:06:21 -0400
From: Tejun Heo <tj@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130906160621.GF22763@mtj.dyndns.org>
References: <cover.1378383792.git.agordeev@redhat.com>
 <c5ff8fbf905a3df2b75369da725ab5ebf31544ff.1378383792.git.agordeev@redhat.com>
 <20130905130902.GA26314@htj.dyndns.org>
 <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bjorn.

On Fri, Sep 06, 2013 at 10:01:38AM -0600, Bjorn Helgaas wrote:
> Sorry, I haven't jumped in here yet because I saw your discussion and
> was hoping you guys would figure something out without my help.  It
> will take me a few hours to look into this and come up with anything
> constructive to say.
> 
> I do remember disliking the complicated interface of
> pci_enable_msi_block() (return negative errno, return positive "we
> might be able to do this" values, or zero), but I'll have to do some
> more research before I can say much more than that.

According to Alexander, it doesn't even seem like we have any actual
use case for the positive return numbers.  I say just rip it out and
do the regular 0/-errno all the way through.

Thanks.

-- 
tejun
