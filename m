Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbaERXYE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 19:24:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:33413 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaERXYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 19:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,864,1392192000"; 
   d="scan'208";a="533877626"
Date: Sun, 18 May 2014 19:24:03 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        Sagi Manole <sagi.manole@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v7 00/22] Support ext4 on NV-DIMMs
Message-ID: <20140518232403.GF6121@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <5378CA88.3080105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5378CA88.3080105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 05:58:16PM +0300, Boaz Harrosh wrote:
> We are experimenting with NV-DIMMs. The experiment will use its own
> FS not based on ext4 at all, more like the infamous PMFS but we want
> to start DAX based and not current XIP based. We want to make sure the proposed
> new API can be utilized stand alone and there are no extX based assumptions.
> (Like the need for direct directory access instead of the ext4
>  copy-from-nvdimm-to-ram directory)

Hi Boaz,

Best of luck with your new filesystem.

> Could you please put these patches on a public tree somewhere, or perhaps some
> later version, that I can pull directly from? this would help alot.

I'm preparing a v8 right now; probably be availble by the end of the week.

> Also I'm curios. I see you guys where working on PMFS for a while
> fixing and enhancing stuff. Then development stopped and these DAX
> patches started showing. Now, PMFS is based on current XIP (I was able
> to easily port it to 3.14-rc7). Do you guys have an Internal attempt
> to port PMFS to DAX? (We might do it in future just as an exercise
> to get intimate with DAX and to make sure nothing is missing.)
> What are your plans with PMFS is it dead?

My group has no plans to do any more work with PMFS, and I'm not aware of
anyone else planning on turning PMFS into a production-quality filesystem.
But the code is out there and we can't stop anybody else from working
on it.

PMFS uses neither DAX nor XIP; it doesn't sit on top of a block device.
We would probably have moved it to sit on top of a block device by now
had we been developing it further.
