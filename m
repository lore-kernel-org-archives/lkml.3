Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab3CPMy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 08:54:27 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40356 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab3CPMy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 08:54:26 -0400
Date: Sat, 16 Mar 2013 13:54:12 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wei WANG <wei_wang@realsil.com.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: mmc: rts_pstor worked fine, but rtsx_pci_sdmmc does not
Message-ID: <20130316125411.GB3753@netboy.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have an Acer Aspire One netbook with a built in card reader, and I
have two cards, one with 32 MB and one with 4 GB. The card reader used
to work with the staging driver in 3.7.10, but the new 3.8.3 driver
does not work with the larger card. The old driver was removed in
commit cd211222.

Now, when inserting the larger card, the kernel just prints an error,
as shown below. Anyone know how to fix this?

Thanks,
Richard

** With new 3.8.3 driver
*** 32 MB card
Mar 16 11:29:45 netboy kernel: [  149.431780] mmc0: new MMC card at address 0001
Mar 16 11:29:45 netboy kernel: [  149.519891] mmcblk0: mmc0:0001 32M    30.6 MiB 
Mar 16 11:29:45 netboy kernel: [  149.524102]  mmcblk0: p1
Mar 16 11:30:20 netboy kernel: [  184.195164] mmc0: card 0001 removed

*** 4G MB card
Mar 16 11:31:13 netboy kernel: [  237.267134] mmc0: error -110 whilst initialising SD card
Mar 16 11:31:14 netboy kernel: [  238.497137] mmc0: error -110 whilst initialising SD card
Mar 16 11:31:15 netboy kernel: [  239.727136] mmc0: error -110 whilst initialising SD card

** With old 3.7.10 staging driver
*** 32 MB card
Mar 16 13:11:01 netboy kernel: [  129.222352] sd 4:0:0:0: [sdb] 62720 512-byte logical blocks: (32.1 MB/30.6 MiB)
Mar 16 13:11:01 netboy kernel: [  129.222559] sd 4:0:0:0: [sdb] Cache data unavailable
Mar 16 13:11:01 netboy kernel: [  129.222572] sd 4:0:0:0: [sdb] Assuming drive cache: write through
Mar 16 13:11:01 netboy kernel: [  129.222985] sd 4:0:0:0: [sdb] Cache data unavailable
Mar 16 13:11:01 netboy kernel: [  129.223002] sd 4:0:0:0: [sdb] Assuming drive cache: write through
Mar 16 13:11:01 netboy kernel: [  129.226132]  sdb: sdb1
Mar 16 13:11:09 netboy kernel: [  136.909833] sdb: detected capacity change from 32112640 to 0

*** 4 GB card
Mar 16 13:12:45 netboy kernel: [  232.909525] sd 4:0:0:0: [sdb] 7626752 512-byte logical blocks: (3.90 GB/3.63 GiB)
Mar 16 13:12:45 netboy kernel: [  232.909769] sd 4:0:0:0: [sdb] Cache data unavailable
Mar 16 13:12:45 netboy kernel: [  232.909786] sd 4:0:0:0: [sdb] Assuming drive cache: write through
Mar 16 13:12:45 netboy kernel: [  232.910593] sd 4:0:0:0: [sdb] Cache data unavailable
Mar 16 13:12:45 netboy kernel: [  232.910612] sd 4:0:0:0: [sdb] Assuming drive cache: write through
Mar 16 13:12:45 netboy kernel: [  232.912631]  sdb: sdb1 sdb2
Mar 16 13:12:59 netboy kernel: [  246.909480] sdb: detected capacity change from 3904897024 to 0




