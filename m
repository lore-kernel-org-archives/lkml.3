Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaCMJyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:54:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50659 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbaCMJyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:54:53 -0400
X-IronPort-AV: E=Sophos;i="4.97,646,1389715200"; 
   d="scan'208";a="9689732"
Message-ID: <53217E46.3060100@cn.fujitsu.com>
Date: Thu, 13 Mar 2014 17:45:42 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: stable@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, miaox@cn.fujitsu.com,
        tangchen <tangchen@cn.fujitsu.com>, guz.fnst@cn.fujitsu.com
Subject: Re: [RESEND v2 PATCH 0/2] Bug fix in aio ring page migration
References: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1394439334-28523-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/13 17:51:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/13 17:51:54,
	Serialize complete at 2014/03/13 17:51:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset has been applied to linux-next, and these problems also exist
in 3.12.y and 3.13.y stable tree.
So please merge this patchset to 3.12.y and 3.13.y stable tree.

commit 692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Mon Mar 10 16:15:33 2014 +0800

    aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.

commit e0f5e0add36d2e3c456cf2f4283673ed834b3c24
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Mon Mar 10 16:15:34 2014 +0800

    aio, mem-hotplug: Add memory barrier to aio ring page migration.

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=692c9b8c5ee8d263bb8348171f0bebd3d84eb2c1
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/fs/aio.c?id=e0f5e0add36d2e3c456cf2f4283673ed834b3c24

https://lkml.org/lkml/2014/3/10/56
https://lkml.org/lkml/2014/3/10/58


On 03/10/2014 04:15 PM, Tang Chen wrote:

> This patch-set fixes the following two problems:
> 
> 1. Need to use ctx->completion_lock to protect ring pages
>    from being mis-written while migration.
> 
> 2. Need memory barrier to ensure memory copy is done before
>    ctx->ring_pages[] is updated.
> 
> NOTE: AIO ring page migration was implemented since Linux 3.12.
>       So we need to merge these two patches into 3.12 stable tree.
> 
> Tang Chen (2):
>   aio, memory-hotplug: Fix confliction when migrating and accessing
>     ring pages.
>   aio, mem-hotplug: Add memory barrier to aio ring page migration.
> 
>  fs/aio.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 42 insertions(+), 0 deletions(-)
> 


