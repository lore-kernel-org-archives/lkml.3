Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaATEme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 23:42:34 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48579 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbaATEmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 23:42:31 -0500
X-AuditID: 9c930179-b7c84ae000000e38-8d-52dca9351e40
Date: Mon, 20 Jan 2014 13:43:36 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] zram: delete zram_init_device() function
Message-ID: <20140120044336.GA28712@bbox>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1389956657-5486-2-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389956657-5486-2-git-send-email-sergey.senozhatsky@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sergey,

Looks good to me and I found a bug which had been in there so I rebased
this patch on the top.
https://git.kernel.org/cgit/linux/kernel/git/minchan/linux.git/commit/?h=zram-next&id=241e34fc6c3c1a41575fbe6383436be70df300d1

On Fri, Jan 17, 2014 at 02:04:15PM +0300, Sergey Senozhatsky wrote:
> allocate new `zram_meta' in disksize_store() only for uninitialised
> zram device, saving a number of allocations and deallocations in case
> if disksize_store() was called on currently used device. at the same
> time zram_meta stack variable is not necessary, because we can set
> ->meta directly. there is also no need in setting QUEUE_FLAG_NONROT
> queue on every disksize_store(), set it once during device creation.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Otherwise,

Acked-by: Minchan Kim <minchan@kernel.org>

-- 
Kind regards,
Minchan Kim
