Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3LRItS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:49:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:64295 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab3LRItQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 03:49:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="426499763"
Date: Wed, 18 Dec 2013 16:50:07 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Huang Ying <ying.huang@intel.com>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: changes caused by 0d11e6ac("blk-mq: fix use-after-free of request")
Message-ID: <20131218085007.GP31783@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

FYI, we noticed some changes caused by 0d11e6ac("blk-mq: fix use-after-free of request"):

- 959a35f13eb785f982d7 is parent of 0d11e6aca396e679c07b
- kbuildx and vpx are KVM testbox

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                40592.80      +314.1%    168112.22  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                19763.87      +941.6%    205868.32  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
                60356.68      +519.6%    373980.55  TOTAL iostat.vdb.wkB/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.64      +345.7%         2.87  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                    0.64      +345.7%         2.87  TOTAL iostat.vdb.wrqm/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    303.01  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    252.31  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    163.05  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                   2442.01  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                    507.41  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    404.00  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   4071.80  TOTAL iostat.vda.r/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    860.50  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    112.49  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    360.58  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                   4937.56  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                   2070.37  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    106.65  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   8448.15  TOTAL iostat.vda.w/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
               166400.75                      0.45  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                13934.99                      0.12  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                 5483.25                      0.83  vpx/micro/xfstests/4HDD-ext4-generic-mid
               168450.24                      0.51  vpx/micro/xfstests/4HDD-xfs-generic-127
               316831.98                      0.32  vpx/micro/xfstests/4HDD-xfs-generic-mid
                28037.99                      0.23  vpx/micro/xfstests/4HDD-xfs-generic-quick
               699139.21                      2.45  TOTAL iostat.vda.avgqu-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    326.86  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    281.25  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    811.90  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     47.78  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                   2117.30  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    163.09  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   3748.18  TOTAL iostat.vda.await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    301.60  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    249.16  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                     51.45  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     91.51  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                   1919.27  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    121.04  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   2734.03  TOTAL iostat.vda.r_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    406.12  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    433.66  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    807.79  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     42.94  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                    592.20  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    401.74  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   2684.45  TOTAL iostat.vda.w_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  40062.13  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  40062.13  TOTAL iostat.vdd.w_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                58002.95                      3.65  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                 5321.49                      2.35  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                  744.30                      0.03  vpx/micro/xfstests/4HDD-ext4-generic-mid
                  904.34                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-127
                  927.75                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-mid
                  928.80                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-quick
                66829.64                      6.02  TOTAL iostat.vdb.avgqu-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    334.18  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                    0.00                    427.32  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    483.98  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                     54.09  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     38.20  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                   1337.77  TOTAL iostat.vdb.await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    314.51  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                    0.00                    434.91  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    655.06  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                     52.35  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     25.65  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                   1482.48  TOTAL iostat.vdb.w_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  43637.20  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  43637.20  TOTAL iostat.vdd.r_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                  283.49                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                  348.49                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                  739.93                      0.02  vpx/micro/xfstests/4HDD-ext4-generic-mid
                  896.90                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-127
                  922.17                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-mid
                  900.48                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-quick
                 4091.47                      0.02  TOTAL iostat.vdc.avgqu-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     48.63  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                     47.05  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     44.51  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                    140.19  TOTAL iostat.vdc.await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     74.79  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                     44.73  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                     31.82  vpx/micro/xfstests/4HDD-xfs-generic-127
                    0.00                    151.34  TOTAL iostat.vdc.w_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                   99.93                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                   99.74                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                   99.75       -99.9%         0.09  vpx/micro/xfstests/4HDD-ext4-generic-mid
                   99.58                      0.04  vpx/micro/xfstests/4HDD-xfs-generic-127
                   99.95                      0.03  vpx/micro/xfstests/4HDD-xfs-generic-mid
                   99.81       -99.9%         0.06  vpx/micro/xfstests/4HDD-xfs-generic-quick
                  598.77                      0.22  TOTAL iostat.vdc.util

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                  271.92                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                  267.49                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                41591.47                      8.11  vpx/micro/xfstests/4HDD-ext4-generic-mid
                 1545.31                      0.00  vpx/micro/xfstests/4HDD-xfs-generic-127
               199016.55                      3.93  vpx/micro/xfstests/4HDD-xfs-generic-mid
                19592.46                      0.98  vpx/micro/xfstests/4HDD-xfs-generic-quick
               262285.20                     13.02  TOTAL iostat.vdd.avgqu-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  40062.13  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  40062.13  TOTAL iostat.vdd.await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
               264379.27                     46.63  vpx/micro/xfstests/4HDD-xfs-generic-mid
               264379.27                     46.63  TOTAL iostat.vdd.avgqu-sz.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00  +22435195.0%       337.66  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                    0.00  +52740796.1%       412.04  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
                    0.00                    207.60  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    278.33  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00  +54044748.7%      1235.63  TOTAL iostat.vdb.w/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    187.74  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                    0.00                    334.23  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    521.97  TOTAL iostat.vdb.r_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     60.02  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    367.81  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    411.64  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    208.39  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   1047.86  TOTAL iostat.vdd.await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     85.62  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.00                    372.66  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    438.01  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    235.66  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                   1131.94  TOTAL iostat.vdd.w_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     60.55  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                     60.55  TOTAL iostat.vdd.r/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    925.15  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    353.72  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.01  +16003327.6%      1052.91  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.01  +35441112.9%      2331.78  TOTAL iostat.vdd.w/s

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                   2084.28  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                   2084.28  TOTAL iostat.vdc.r_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    827.73  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    827.73  TOTAL iostat.vdc.w_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    462.35  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    462.35  TOTAL iostat.vda.avgrq-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    445.55  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    148.60  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    594.15  TOTAL iostat.vdd.avgrq-sz

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
              1018060.51                     24.78  vpx/micro/xfstests/4HDD-xfs-generic-mid
              1018060.51                     24.78  TOTAL iostat.vda.avgqu-sz.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  55151.60  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  55151.60  TOTAL iostat.vda.await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  54408.38  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  54408.38  TOTAL iostat.vda.r_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                  65896.75  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                  65896.75  TOTAL iostat.vda.w_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                  934.24                      0.08  vpx/micro/xfstests/4HDD-xfs-generic-mid
                  934.24                      0.08  TOTAL iostat.vdb.avgqu-sz.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                   1061.09  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                   1061.09  TOTAL iostat.vdb.await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                   1999.51  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                   1999.51  TOTAL iostat.vdb.r_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                    908.53  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    908.53  TOTAL iostat.vdb.w_await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                  928.65                      0.08  vpx/micro/xfstests/4HDD-xfs-generic-mid
                  928.65                      0.08  TOTAL iostat.vdc.avgqu-sz.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                   1001.78  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                   1001.78  TOTAL iostat.vdc.await.max

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.00                     39.51  vpx/micro/xfstests/4HDD-ext4-generic-mid
                    0.00                    236.20  vpx/micro/xfstests/4HDD-xfs-generic-mid
                    0.00                    171.93  vpx/micro/xfstests/4HDD-xfs-generic-quick
                    0.00                    447.63  TOTAL iostat.vdd.r_await

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                   24.35      +302.7%        98.07  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqrewr-sync
                    9.48      +914.2%        96.18  kbuildx/sysbench/fileio/600s-100%-1HDD-xfs-64G-1024-seqwr-sync
                   99.93       -90.3%         9.74  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                   99.75       -93.4%         6.59  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                   99.75       -99.9%         0.13  vpx/micro/xfstests/4HDD-ext4-generic-mid
                   99.59                      0.04  vpx/micro/xfstests/4HDD-xfs-generic-127
                   99.95                      0.02  vpx/micro/xfstests/4HDD-xfs-generic-mid
                   99.81       -99.9%         0.06  vpx/micro/xfstests/4HDD-xfs-generic-quick
                  632.61       -66.7%       210.82  TOTAL iostat.vdb.util

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                   99.93       -92.3%         7.68  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                   99.75       -97.8%         2.17  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                   99.75       -79.7%        20.22  vpx/micro/xfstests/4HDD-ext4-generic-mid
                   99.59       -65.2%        34.69  vpx/micro/xfstests/4HDD-xfs-generic-127
                   99.96       -85.8%        14.20  vpx/micro/xfstests/4HDD-xfs-generic-mid
                   99.81       -96.8%         3.20  vpx/micro/xfstests/4HDD-xfs-generic-quick
                  598.79       -86.3%        82.16  TOTAL iostat.vda.util

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                   99.93                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                   99.74                      0.00  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                   99.80       -51.8%        48.06  vpx/micro/xfstests/4HDD-ext4-generic-mid
                   99.58       -99.7%         0.33  vpx/micro/xfstests/4HDD-xfs-generic-127
                  100.00       -82.4%        17.57  vpx/micro/xfstests/4HDD-xfs-generic-mid
                   99.81       -92.6%         7.34  vpx/micro/xfstests/4HDD-xfs-generic-quick
                  598.87       -87.8%        73.29  TOTAL iostat.vdd.util


    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                    0.67       +69.2%         1.13  vpx/micro/xfstests/4HDD-btrfs-generic-quick
                    0.67       +69.2%         1.13  TOTAL iostat.cpu.steal

    959a35f13eb785f982d7      0d11e6aca396e679c07b  
------------------------  ------------------------  
                   95.55        -7.5%        88.34  vpx/micro/xfstests/4HDD-btrfs-generic-mid
                   95.55        -7.5%        88.34  TOTAL iostat.vda.wrqm/s
