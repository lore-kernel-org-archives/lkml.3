Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab3CZPOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:14:43 -0400
Received: from 8bytes.org ([85.214.48.195]:45357 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934485Ab3CZPOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:14:42 -0400
Date: Tue, 26 Mar 2013 16:14:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Andrew Cooks <acooks@gmail.com>
Cc: Gaudenz Steinlin <gaudenz@soziologie.ch>, jyli@marvell.com,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>, Shun Fu <fushun@marvell.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Marvell 88NV9143 in mini-PCIe not working with intel_iommu=on
Message-ID: <20130326151436.GE2727@8bytes.org>
References: <874ngpj3d9.fsf@meteor.durcheinandertal.bofh>
 <CAJtEV7Zyq3+YPu9Vvcxcm8nw41-ENjLuRHUzyFFzXQn-wiSf1w@mail.gmail.com>
 <87zjyfy325.fsf@meteor.durcheinandertal.bofh>
 <CAJtEV7aL0TeSYB-+1bTgq=8Rbt2wijLfQF7jrHHXTeXeR811DQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJtEV7aL0TeSYB-+1bTgq=8Rbt2wijLfQF7jrHHXTeXeR811DQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Mar 26 16:14:40 2013
X-DSPAM-Confidence: 0.9980
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5151bb6023671848696469
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 10:53:16AM +0800, Andrew Cooks wrote:
> I'm hoping one of the veteran developers would give some guidance for
> the best approach to enable more devices in future.

In cases like this where a device just uses the request-id of another
device you can make use of the existing quirk-code in
drivers/pci/quirks.c. Look at the function pci_get_dma_source() and add
your device there. This should also make it work with VT-d and AMD-Vi.


	Joerg


