Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbaBLNYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 08:24:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbaBLNYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 08:24:43 -0500
Date: Wed, 12 Feb 2014 14:26:40 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/34] bnx2: Use pci_enable_msix_range()
Message-ID: <20140212132640.GA3147@dhcp-26-207.brq.redhat.com>
References: <cover.1391172839.git.agordeev@redhat.com>
 <434a34e01c353441131204edef36126a95e8928a.1391172839.git.agordeev@redhat.com>
 <20140131.133051.483295479425700960.davem@davemloft.net>
 <20140211003814.GC12851@google.com>
 <20140211010803.GD12851@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140211010803.GD12851@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 06:08:03PM -0700, Bjorn Helgaas wrote:
> I skimmed these and the scsi patches, and I think you were right in
> proposing an MSI-X enable function that takes a single "number of vectors"
> argument, in addition to pci_enable_msix_range(), which takes a minimum and
> a maximum.  Obviously the pci_enable_msix_fixed() or whatever could be a
> simple #define wrapper or something.
> 
> Of the fifty-some net and scsi patches, I counted 23 that use the min ==
> max pattern, and it seems a shame to have to repeat that expression.

(un-CCing netdev@vger.kernel.org)

Hi Bjorn,

I propose pci_enable_msix_exact(pdev, entries, nvec) rather than
pci_enable_msix_fixed().

Do you prefer this one to return 0/-errno or nvec/-errno?

Do you want pci_enable_msi_exact() in addition to pci_enable_msix_exact()?

Thanks!

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
