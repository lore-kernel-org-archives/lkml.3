Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaBXR3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:29:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38510 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240AbaBXR3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:29:01 -0500
Date: Mon, 24 Feb 2014 17:28:50 +0000
From: Will Deacon <will.deacon@arm.com>
To: srikanth TS <srikantht.shivanand@gmail.com>
Cc: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ts.srikanth@samsung.com" <ts.srikanth@samsung.com>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>
Subject: Re: your mail
Message-ID: <20140224172850.GG2553@mudshark.cambridge.arm.com>
References: <CAM0G4zvu1BHcOrSgBuobvb-+fVsNWXjXdzZdV51T70B9_ZC4XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0G4zvu1BHcOrSgBuobvb-+fVsNWXjXdzZdV51T70B9_ZC4XQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:12:21PM +0000, srikanth TS wrote:
> Hi Will Deacon,

Hello,

> Currently SMMU driver expecting all stream ID used by respective master
> should be defined in the DT.
> 
> We want to know how to handle in the case of virtual functions dynamically
> created and destroyed.
> 
> Is PCI driver responsible for creating stream ID respective BDand
> requesting SMMU to add to the mapping table[stream Id to context mapping
> table]?
> 
> Or is there any right way of doing it?

Correct, the driver currently doesn't support dynamic mappings (mainly
because I didn't want to try and invent something that I couldn't test).

There are a couple of ways to solve this:

  (1) Add a way for a PCI RC to dynamically allocate StreamIDs on an SMMU
      within a fixed range. That would probably need some code in the bus
      layer, so that a bus notifier can kick and call back to the relevant
      SMMU.

  (2) Describe the RID -> SID mapping in the device-tree. We probably want
      to avoid an enormous table, so this would only work for simple `SID =
      RID + offset' or 'SID = RID & mask' cases.

How do your IDs map to each other?

Will
