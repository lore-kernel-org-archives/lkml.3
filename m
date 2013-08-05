Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab3HEWWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:22:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3HEWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:22:08 -0400
Date: Mon, 5 Aug 2013 15:22:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Caizhiyong <caizhiyong@huawei.com>
Cc: Karel Zak <kzak@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Quyaxin <quyaxin@huawei.com>, Jens Axboe <axboe@kernel.dk>,
        David Woodhouse <dwmw2@infradead.org>, Marius Groeger <mag@sysgo.de>
Subject: Re: [PATCH] block: support embedded device command line partition
Message-Id: <20130805152206.76462cc4a42e51b16a0532f1@linux-foundation.org>
In-Reply-To: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C061D75@szxeml512-mbs.china.huawei.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Aug 2013 09:57:04 +0000 Caizhiyong <caizhiyong@huawei.com> wrote:

> From: Cai Zhiyong <caizhiyong@huawei.com>
> 
> Read block device partition table from command line.
> The partition used for fixed block device (eMMC) embedded device.
> It is no MBR, save storage space. Bootloader can be easily accessed by
> absolute address of data on the block device.
> Users can easily change the partition.
> 
> This code reference MTD partition, source "drivers/mtd/cmdlinepart.c"
> About the partition verbose reference "Documentation/block/cmdline-partition.txt"
> 

Seems OK to me.

The obvious question is: can we consolidate this with
drivers/mtd/cmdlinepart.c in some fashion so the kernel doesn't have
two parsers which do the same thing?

