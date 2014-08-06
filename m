Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaHFL1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:27:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34674 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbaHFL1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:27:36 -0400
Message-ID: <53E21125.9080308@plexistor.com>
Date: Wed, 06 Aug 2014 14:27:33 +0300
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Ross Zwisler <ross.zwisler@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCHSET 0/4] brd: partition fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Jens for me this should go into current 3.17-rcX Kernel. Current situation is
that any attempt to use partitions with brd device would create the partition
but then any use will trash the data.
(But after review from Ross Zwisler)

See: http://www.spinics.net/lists/linux-scsi/msg76737.html

So these patches fixes up all the problems we saw with the code, but not sacrificing
any of the old fixtures. See [patch 3/4] for more explanations.

Ross please review.

list of patches:
[PATCH 1/4] Change direct_access calling convention

    This is a Matthew's patch from the DAX series which fixes the interface to
    direct_access taking into account the partition offset. It must be applied
    here for partitions to work with direct_access() API.

[PATCH 2/4] brd: Add getgeo to block ops

    Ross I put this patch on your name please confirm that you agree and
    that you allow the sign-off. Though your original patch was for prd,
    this here is the exact same one for brd.

[PATCH 3/4] brd: Fix all partitions BUGs
[PATCH 4/4] brd: Request from fdisk 4k alignment

Thanks
Boaz
