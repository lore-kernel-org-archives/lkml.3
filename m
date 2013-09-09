Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3IIPSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:18:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab3IIPSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:18:52 -0400
Date: Mon, 9 Sep 2013 17:20:44 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
References: <20130905130902.GA26314@htj.dyndns.org>
 <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906233205.GF12956@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:32:05PM -0600, Bjorn Helgaas wrote:
> I propose that you rework it that way, and at least find out what
> (if anything) would break if we do that.  Or maybe we just give up
> some optimization; it would be nice to quantify that, too.

Hi Bjorn,

The series is what it seems a direction to take.

Looks like we need PPC folks to agree on the quota check update
for pSeries (yes, they do bail out with a positive return value
from arch_msi_check_device()):

	quota = msi_quota_for_device(pdev, nvec);

	if (quota && quota < nvec)
		return quota;

	return 0;

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
