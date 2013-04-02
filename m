Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3DBOf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:35:26 -0400
Received: from 8bytes.org ([85.214.48.195]:53735 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab3DBOfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:35:24 -0400
Date: Tue, 2 Apr 2013 16:35:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: suravee.suthikulpanit@amd.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/amd: Add IOMMU event log injection interface
 for testing event flag decoding logic
Message-ID: <20130402143521.GC15687@8bytes.org>
References: <1364428294-2579-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364428294-2579-1-git-send-email-suravee.suthikulpanit@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Apr  2 16:35:23 2013
X-DSPAM-Confidence: 0.9989
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 515aecab23671893720817
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 27, 2013 at 06:51:34PM -0500, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> Add IOMMU event log injection interface for testing event flag decoding logic.
> This interface allows users to specify device id, event flag, and event types via debugfs.
> 
> echo 0x300 > /sys/kernel/debug/amd-iommu-evninj/devid // (e.g. Bus:Dev.fun 3:0.0)
> echo 0xfff > /sys/kernel/debug/amd-iommu-evninj/flags // (e.g. Specify flag value)
> echo 2 > /sys/kernel/debug/amd-iommu-evninj/type      // (e.g. for IO_PAGE_FAULT event)
> 
> Once the event is injected, IOMMU driver will parse and print out the event information
> in kernel log (dmesg) with the various information depending on the types of event and flag
> specified.

Why is this needed? I think the risk of regressions in the
event-handling code is to low to justify the need for an event-injection
mechanism.

	Joerg


