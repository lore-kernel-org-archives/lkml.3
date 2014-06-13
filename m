Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaFMPKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:10:32 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42809 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbaFMPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:10:29 -0400
Message-ID: <1402671668.7963.16.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2 RESEND 2/2] mem-hotplug: Introduce MMOP_OFFLINE to
 replace the hard coding -1.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: hutao@cn.fujitsu.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, tj@kernel.org, hpa@zytor.com, mingo@elte.hu,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Fri, 13 Jun 2014 09:01:08 -0600
In-Reply-To: <1402032829-18455-1-git-send-email-tangchen@cn.fujitsu.com>
References: <20140606051535.GC4454@G08FNSTD100614.fnst.cn.fujitsu.com>
	 <1402032829-18455-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 13:33 +0800, Tang Chen wrote:
> In store_mem_state(), we have:
> ......
>  334         else if (!strncmp(buf, "offline", min_t(int, count, 7)))
>  335                 online_type = -1;
> ......
>  355         case -1:
>  356                 ret = device_offline(&mem->dev);
>  357                 break;
> ......
> 
> Here, "offline" is hard coded as -1.
> 
> This patch does the following renaming:
>  ONLINE_KEEP     ->  MMOP_ONLINE_KEEP
>  ONLINE_KERNEL   ->  MMOP_ONLINE_KERNEL
>  ONLINE_MOVABLE  ->  MMOP_ONLINE_MOVABLE
> 
> and introduce MMOP_OFFLINE = -1 to avoid hard coding.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  drivers/base/memory.c          | 18 +++++++++---------
>  include/linux/memory_hotplug.h |  9 +++++----
>  mm/memory_hotplug.c            |  9 ++++++---
>  3 files changed, 20 insertions(+), 16 deletions(-)

The patch does not apply cleanly to the current top of the tree.  Can
you rebase the patch?

Thanks,
-Toshi

