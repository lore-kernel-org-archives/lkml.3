Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3C1JK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 05:10:29 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:37457 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3C1JK1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Thu, 28 Mar 2013 05:10:27 -0400
X-Greylist: delayed 634 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Mar 2013 05:10:27 EDT
Message-Id: <51541493020000A100010188@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 28 Mar 2013 09:59:47 +0100
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Suggestion for improving kernel messages on ext3-mount for
 consistency
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a kind of trivial suggestion for improving the kernel messages for ext3-fs mounts to be more consistent and useful:

Most messages for ext3-mounting include the device, like:
kernel: [  823.233892] EXT3-fs (dm-7): using internal journal
kernel: [  823.233899] EXT3-fs (dm-7): mounted filesystem with ordered data mode

However some messages do not include a device, even though they seem device specific. For example:
kernel: [  823.210989] EXT3-fs: barriers not enabled
kernel: [  823.233218] kjournald starting.  Commit interval 15 seconds

This was observed in the current SLES11 SP2 kernel (3.0.58-0.6.6).

I haven't queried the sources, but it looks like an easy change...

BTW: The kjournal threads are also anonymous in the process list (while xfs (for example) names them):
# ps ax |grep journ
  418 ?        S      0:00 [kjournald]
 1070 ?        S      0:00 [kjournald]
 1071 ?        S      0:00 [kjournald]
 1072 ?        S      0:00 [kjournald]
 1073 ?        S      0:00 [kjournald]
 1074 ?        S      0:00 [kjournald]
 1075 ?        S      0:00 [kjournald]
 5461 ?        S      0:00 [kjournald]
 5499 ?        S      0:00 [kjournald]
 5601 ?        S      0:00 [kjournald]
 5642 ?        S      0:00 [kjournald]
 5648 ?        S      0:00 [kjournald]
 5653 ?        S      0:00 [kjournald]
 5661 ?        S      0:00 [kjournald]
 5873 tty1     S+     0:00 grep journ

# ps ax |grep xfs
 5506 ?        S<     0:00 [xfs_mru_cache]
 5507 ?        S<     0:00 [xfslogd]
 5508 ?        S<     0:00 [xfsdatad]
 5509 ?        S<     0:00 [xfsconvertd]
 5510 ?        S      0:00 [xfsbufd/dm-10]
 5511 ?        S      0:00 [xfsaild/dm-10]
 5518 ?        S      0:00 [xfsbufd/dm-11]
 5519 ?        S      0:00 [xfsaild/dm-11]
 5560 ?        S      0:00 [xfsbufd/dm-12]
 5561 ?        S      0:00 [xfsaild/dm-12]
 5593 ?        S      0:00 [xfsbufd/dm-13]
 5594 ?        S      0:00 [xfsaild/dm-13]
 5875 tty1     S+     0:00 grep xfs

Regards,
Ulrich


