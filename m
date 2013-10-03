Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3JCUKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab3JCUKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:10:16 -0400
Date: Thu, 3 Oct 2013 22:12:05 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Jon Mason <jon.mason@intel.com>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH RFC 34/77] ioat: Update MSI/MSI-X interrupts enablement
 code
Message-ID: <20131003201204.GA28050@dhcp-26-207.brq.redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
 <63caad476ca6b7f3481d5512febcb4ef3db72209.1380703263.git.agordeev@redhat.com>
 <CAPcyv4j=Huz8d+00vMJa8mCFCKWeNG9-XAc1u19v89fNruM9kg@mail.gmail.com>
 <CAPcyv4gB7R2_zn=Wvowtxcn4muWNd6aK6rsURss3rnhj0VAyfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gB7R2_zn=Wvowtxcn4muWNd6aK6rsURss3rnhj0VAyfA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 11:00:51AM -0700, Williams, Dan J wrote:
> I see patch 00/77 now and I still don't see the need for ioatdma to be
> updated.  If we fail the subsequent request_irq, the driver will still
> fall back to trying less interrupts.

In the proposed design pci_enable_msix() will never return a positive value.
Therefore if the driver is not updated it will fallback to single MSI if
device->common.chancnt MSI-X vectors were not allocated while it used to
fallback to a single MSI-X in the same situation. Not to mention 'if (err > 0)'
dead code.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
