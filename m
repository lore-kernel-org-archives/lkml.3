Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3AZMju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 07:39:50 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:36254 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3AZMjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 07:39:48 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 26 Jan 2013 13:39:46 +0100
Message-ID: <CA+icZUXsi0jZZE9HBWG0D6-+oJBeX+8nHpZ9F02x=B7dG3X+yg@mail.gmail.com>
Subject: Re: block: optionally snapshot page contents to provide stable pages
 during write
From: Sedat Dilek <sedat.dilek@gmail.com>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

can you tell me why you do not put your help text where it normally
belongs ("help" Kconfig item)?

273 # We also use the bounce pool to provide stable page writes for jbd.  jbd
274 # initiates buffer writeback without locking the page or setting
PG_writeback,
275 # and fixing that behavior (a second time; jbd2 doesn't have this
problem) is
276 # a major rework effort.  Instead, use the bounce buffer to snapshot pages
277 # (until jbd goes away).  The only jbd user is ext3.
278 config NEED_BOUNCE_POOL
279         bool
280         default y if (TILE && USB_OHCI_HCD) || (BLK_DEV_INTEGRITY && JBD)
281         help
282         line #273..277

Noticed while hunting a culprit commit in Linux-Next as my
kernel-config got changed between next-20130123..next-20130124.

Regards,
- Sedat -

[1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=3f1c22e#patch5
