Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab3LSOgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:36:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:16027 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3LSOgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:36:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="446998947"
Date: Thu, 19 Dec 2013 22:37:13 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>
Cc: Ming Lei <tom.leiming@gmail.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Huang Ying <ying.huang@intel.com>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Re: changes caused by 0d11e6ac("blk-mq: fix use-after-free of
 request")
Message-ID: <20131219143713.GX31783@yliu-dev.sh.intel.com>
References: <20131218085007.GP31783@yliu-dev.sh.intel.com>
 <52B1790A.5070105@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B1790A.5070105@bjorling.me>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:29:30AM +0100, Matias Bjørling wrote:
> On 12/18/2013 09:50 AM, Yuanhan Liu wrote:
> >Hi,
> >
> >FYI, we noticed some changes caused by 0d11e6ac("blk-mq: fix use-after-free of request"):
> >
> 
> The blk-mq accounting was faulty up to that commit. We should
> compare the blk-mq with the previous block layer.
> 
> Could you try to revert the following patches:
> 
> f02b9ac virtio-blk: virtqueue_kick() must be ordered with other...
> 1cf7e9c virtio_blk: blk-mq support
> 
> and compare the two runs (upto 0d11e6ac applied, and the same, with
> the two patches reverted)

Hi Matias,

You are right. Those counter restore back with the two patches reverted(d1b4e3825c8848b0ea0f).

959a35f13eb785f982d7       0d11e6aca396e679c07b       d1b4e3825c8848b0ea0f  
---------------            -------------------------  -------------------------  
      0.00                      60.02 ~42%                  0.00       vpx/micro/xfstests/4HDD-btrfs-generic-quick
      0.00                     367.81 ~27%                  0.00       vpx/micro/xfstests/4HDD-ext4-generic-mid
      0.00                     411.64 ~13%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-mid
      0.00                     208.39 ~10%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-quick
      0.00                    1047.86                       0.00       TOTAL iostat.vdd.await

959a35f13eb785f982d7       0d11e6aca396e679c07b       d1b4e3825c8848b0ea0f  
---------------            -------------------------  -------------------------  
      0.00                     301.60 ~34%                  0.00       vpx/micro/xfstests/4HDD-btrfs-generic-mid
      0.00                     249.16 ~12%                  0.00       vpx/micro/xfstests/4HDD-btrfs-generic-quick
      0.00                      51.45 ~26%                  0.00       vpx/micro/xfstests/4HDD-ext4-generic-mid
      0.00                      91.51 ~21%                  0.04       vpx/micro/xfstests/4HDD-xfs-generic-127
      0.00                    1919.27 ~43%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-mid
      0.00                     121.04 ~11%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-quick
      0.00                    2734.03                       0.04       TOTAL iostat.vda.r_await

959a35f13eb785f982d7       0d11e6aca396e679c07b       d1b4e3825c8848b0ea0f  
---------------            -------------------------  -------------------------  
      0.00                     406.12 ~10%                  0.00       vpx/micro/xfstests/4HDD-btrfs-generic-mid
      0.00                     433.66 ~ 7%                  0.00       vpx/micro/xfstests/4HDD-btrfs-generic-quick
      0.00                     807.79 ~15%                  0.00       vpx/micro/xfstests/4HDD-ext4-generic-mid
      0.00                      42.94 ~67%                  0.51       vpx/micro/xfstests/4HDD-xfs-generic-127
      0.00                     592.20 ~16%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-mid
      0.00                     401.74 ~12%                  0.00       vpx/micro/xfstests/4HDD-xfs-generic-quick
      0.00                    2684.45                       0.51       TOTAL iostat.vda.w_await



	--yliu
