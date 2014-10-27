Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaJ0M6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:58:38 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53306 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbaJ0M6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:58:37 -0400
Date: Mon, 27 Oct 2014 08:58:33 -0400
From: Tejun Heo <tj@kernel.org>
To: kernel test robot <fengguang.wu@intel.com>
Cc: LKP <lkp@linux.intel.com>, Alexander Gordeev <agordeev@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: [LKP] [AHCI] 18dcf433f3d: -3.3% fileio.requests_per_sec
Message-ID: <20141027125833.GB4436@htj.dyndns.org>
References: <20141027021651.GF27038@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141027021651.GF27038@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:16:51AM +0800, kernel test robot wrote:
> FYI, we noticed the below changes on
> 
> commit 18dcf433f3ded61eb140a55e7048ec2fef79e723 ("AHCI: Optimize single IRQ interrupt processing")
> 
> 
> 227dfb4dbf109596  18dcf433f3ded61eb140a55e70  testbox/testcase/testparams
> ----------------  --------------------------  ---------------------------
>          %stddev     %change         %stddev
>              \          |                \  
>      61.60 ±  1%      -3.3%      59.56 ±  0%  bay/fileio/performance-600s-100%-1HDD-btrfs-64G-1024f-rndrw-sync
>      61.60            -3.3%      59.56        GEO-MEAN fileio.requests_per_sec

Just skimmed through it and it looks like we're getting lower IO rate
w/ way higher task switch rate.  Maybe this is more pronounced w/
btrfs because it also makes heavy use of worker threads.  Alexander,
can you please look into it?  It looks like we might have to revert
the commit, drop the threaded IRQ and do the split locking after that.

Thanks.

-- 
tejun
