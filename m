Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaHUO36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:29:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:39621 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018AbaHUO35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,909,1400050800"; 
   d="scan'208";a="579904626"
Date: Thu, 21 Aug 2014 22:30:06 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: ext4@mail.home.local, LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [ext4] 71d4f7d0321: -49.6% xfstests.generic.274.seconds
Message-ID: <20140821143006.GA19943@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Ted,

We noticed increased xfstests 274's test speed and the first good
commit is 71d4f7d032149b935a26eb3ff85c6c837f3714e1 ("ext4: remove
metadata reservation checks").

test case: snb-drag/xfstests/4HDD-ext4-generic-slow2
snb-drag is a Sandy Bridge PC with 6G memory.

d5e03cbb0c88cd1  71d4f7d032149b935a26eb3ff 
---------------  ------------------------- 
        51 ± 2%     -49.6%         25 ± 1%  TOTAL xfstests.generic.274.seconds
       817 ± 1%      -3.0%        792 ± 1%  TOTAL time.elapsed_time

                          xfstests.generic.274.seconds

  60 ++---------------------------------------------------------------------+
     |                                                                      |
  55 ++         .*..*..             *..               *..                   |
     |       .*.       .          ..                ..                      |
  50 *+.*..*.           *..*..*..*     *..*..*..*..*     *                  |
     |                                                                      |
  45 ++                                                                     |
     |                                                                      |
  40 ++                                                                     |
     |                                                                      |
  35 ++                                                                     |
     |                                                                      |
  30 ++                                                                     |
     |                                                                      |
  25 O+-O--O--O--O--O---O--O--O--O--O--O--O--O--O--O--O--O---O--O--O--O--O--O


	[*] bisect-good sample
	[O] bisect-bad  sample


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.

Thanks,
Fengguang

--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
mkfs -t ext4 -q /dev/sda7
mkfs -t ext4 -q /dev/sda10
mkfs -t ext4 -q /dev/sda6
mkfs -t ext4 -q /dev/sda5
mount -t ext4 /dev/sda10 /fs/sda10
mount -t ext4 /dev/sda5 /fs/sda5
mount -t ext4 /dev/sda6 /fs/sda6
mount -t ext4 /dev/sda7 /fs/sda7
export TEST_DIR=/fs/sda10
export TEST_DEV=/dev/sda10
export SCRATCH_MNT=/fs/scratch
mkdir /fs/scratch -p
export SCRATCH_DEV=/dev/sda7
./check generic/224 generic/231 generic/274 generic/299 generic/300

--xHFwDpU9dbj6ez1V--
