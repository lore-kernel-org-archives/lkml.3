Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab3FCJGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:06:07 -0400
Received: from mfow510.mose-mail.jp ([203.180.220.223]:59360 "EHLO
	mfow.mose-mail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab3FCJGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:06:05 -0400
X-Greylist: delayed 2126 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2013 05:06:05 EDT
Message-ID: <51AC5422.1080103@labs.cybozu.co.jp>
Date: Mon, 03 Jun 2013 17:30:26 +0900
From: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ric Wheeler <rwheeler@redhat.com>, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Takashi HOSHINO <hoshino@labs.cybozu.co.jp>
Subject: WalB: a wrapper block device driver for efficient backup and replication
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm developing a wrapper block device driver called 'WalB'
that provides wrapper block devices to get consistent diff blocks
without full-scans of devices using Write-Ahead Logging technology,
in order to achieve incremental backup and asynchronous replication.

Its source code and documents are available in GitHub:
https://github.com/starpos/walb
https://github.com/starpos/walb/blob/develop/doc/index.creole

You can try it from now.
It supports kernel 3.2 to 3.9 and x86_64 architecture currently.

WalB achieves small overhead of IO response with:
- No persistent indexes.
- No undo-logs, just redo-logs.
- No block-level fragmentation.

I've talked about WalB at LinuxCon Japan 2013.
The slides in pdf are here:
http://www.slideshare.net/starpos/wal-b-linuxconjapan2013

At the conference, I asked Mr. Ric Wheeler what to do for the module to
be merged to the mainline kernel, and he suggested submitting an e-mail
ASAP.

WalB is provided as a single module currently.
It seems not so difficult to create 'drivers/block/walb' directory like
DRBD.
Is that nice idea? or do you have any comments?

Regards,

Takashi Hoshino
