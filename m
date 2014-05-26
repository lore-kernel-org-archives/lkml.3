Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbaEZRma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:42:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46717 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaEZRm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:42:29 -0400
Date: Mon, 26 May 2014 10:42:25 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincenzo Aliberti <vincenzo.aliberti@gmail.com>
Subject: Re: linux-next: build failure after merge of the l2-mtd tree
Message-ID: <20140526174225.GC5241@norris-Latitude-E6410>
References: <20140522153047.62c1721c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522153047.62c1721c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, May 22, 2014 at 03:30:47PM +1000, Stephen Rothwell wrote:
> Hi Artem,

FYI, I'm managing this tree now, not Artem.

> After merging the l2-mtd tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/mtd/lpddr/lpddr2_nvm.c: In function 'ow_enable':
> drivers/mtd/lpddr/lpddr2_nvm.c:149:2: error: implicit declaration of function 'writel_relaxed' [-Werror=implicit-function-declaration]
>   writel_relaxed(build_mr_cfgmask(pcm_data->bus_width) | 0x18,
>   ^
> 
> Caused by commit 96ba9dd65788 ("mtd: lpddr: add driver for LPDDR2-NVM
> PCM memories").

Vincenzo and I have already identified the build failure. It's because
the I/O accessors are not implemented uniformly across architectures.
I just pushed a patch to restrict this driver to ARM for now, but I hope
this inconsistency will be improved soon. (I believe there's a patch
series out there right now.)

> I have used the l2-mtd tree from next-20140521 for today.

Thanks, and thanks for the report.

Regards,
Brian
