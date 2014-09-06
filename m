Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaIFPcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 11:32:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39950 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaIFPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 11:32:51 -0400
Date: Sat, 6 Sep 2014 08:32:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>, Jade Bilkey <herself@thefumon.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: Tree for Sep 5: build error due to 'ath5k: added debugfs
 file for dumping eeprom'
Message-ID: <20140906153245.GA25739@roeck-us.net>
References: <20140905165052.GF29327@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140905165052.GF29327@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see the following build error on linux-next-20140905.

Guenter

---

Building alpha:allmodconfig ... failed
Building sparc64:allmodconfig ... failed

drivers/net/wireless/ath/ath5k/debug.c: In function 'open_file_eeprom':
drivers/net/wireless/ath/ath5k/debug.c:933:2: error:
	implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath5k/debug.c:933:6: warning:
	assignment makes pointer from integer without a cast [enabled by default]
drivers/net/wireless/ath/ath5k/debug.c:960:2: error:
	implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[5]: *** [drivers/net/wireless/ath/ath5k/debug.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath5k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2

Bisect results:

db906eb2101b0564b0c65edf4a8647395196342e is the first bad commit
commit db906eb2101b0564b0c65edf4a8647395196342e
Author: Jade Bilkey <herself@thefumon.com>
Date:   Sat Aug 30 15:14:14 2014 -0400

ath5k: added debugfs file for dumping eeprom

Signed-off-by: Jade Bilkey <herself@thefumon.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>

Bisect log:

# bad: [92d88cb068a5dc66d53ef017999b2419b125f764] Add linux-next specific files for 20140905
# good: [69e273c0b0a3c337a521d083374c918dc52c666f] Linux 3.17-rc3
git bisect start 'HEAD' 'v3.17-rc3'
# bad: [9ecc6d43871f92e01c8aafa9563538ed92825778] Merge remote-tracking branch 'drm/drm-next'
git bisect bad 9ecc6d43871f92e01c8aafa9563538ed92825778
# good: [43b1c66453f3f04c5faa271c9918aa9764e04f98] Merge remote-tracking branch 'hwmon-staging/hwmon-next'
git bisect good 43b1c66453f3f04c5faa271c9918aa9764e04f98
# good: [92bfbb73a8714144c5d74bf886b3b8b6b93a29dc] Merge remote-tracking branch 'ipsec-next/master'
git bisect good 92bfbb73a8714144c5d74bf886b3b8b6b93a29dc
# bad: [15f51956b321a1ddf683c2b151aa85e84fbc3c4d] Merge remote-tracking branch 'l2-mtd/master'
git bisect bad 15f51956b321a1ddf683c2b151aa85e84fbc3c4d
# good: [705d0bf83dbef34d49927d3bf05c6d497f42e8b0] ath9k: Add a routine for initializing channel contexts
git bisect good 705d0bf83dbef34d49927d3bf05c6d497f42e8b0
# good: [d17ec4d55223d9487df195012762da6f85862d4c] Merge branch 'for-john' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
git bisect good d17ec4d55223d9487df195012762da6f85862d4c
# bad: [d377921ed031588e1a39e4be730033d962b2c456] Merge remote-tracking branch 'mtd/master'
git bisect bad d377921ed031588e1a39e4be730033d962b2c456
# good: [15c9ec43b0948940926ce4c063b5d78a28511771] Bluetooth: Remove hci_conn_hold/drop from hci_chan
git bisect good 15c9ec43b0948940926ce4c063b5d78a28511771
# good: [cf0ba860a91ed2f912f5598a331e3fbd40688f8d] Bluetooth: Move clock offset reading into hci_disconnect()
git bisect good cf0ba860a91ed2f912f5598a331e3fbd40688f8d
# bad: [c728ab656f738adfd5da968b5039789edad1ebc3] Merge remote-tracking branch 'wireless-next/master'
git bisect bad c728ab656f738adfd5da968b5039789edad1ebc3
# bad: [db906eb2101b0564b0c65edf4a8647395196342e] ath5k: added debugfs file for dumping eeprom
git bisect bad db906eb2101b0564b0c65edf4a8647395196342e
# good: [87fed556d08d21dd7dd3e0222c94c187e4c2d5e2] bcma: get info about flash type SoC booted from
git bisect good 87fed556d08d21dd7dd3e0222c94c187e4c2d5e2
# first bad commit: [db906eb2101b0564b0c65edf4a8647395196342e] ath5k: added debugfs file for dumping eeprom
