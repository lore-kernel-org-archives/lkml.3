Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562Ab3DJWNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:13:43 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42306 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3DJWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:13:42 -0400
Date: Wed, 10 Apr 2013 15:13:39 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Toshi Kani <toshi.kani@hp.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxram@us.ibm.com,
        guz.fnst@cn.fujitsu.com, tmac@hp.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, jiang.liu@huawei.com
Subject: Re: [PATCH v3 3/3] mm: Change __remove_pages() to call
 release_mem_region_adjustable()
In-Reply-To: <1365614221-685-4-git-send-email-toshi.kani@hp.com>
Message-ID: <alpine.DEB.2.02.1304101513260.1526@chino.kir.corp.google.com>
References: <1365614221-685-1-git-send-email-toshi.kani@hp.com> <1365614221-685-4-git-send-email-toshi.kani@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Toshi Kani wrote:

> Changed __remove_pages() to call release_mem_region_adjustable().
> This allows a requested memory range to be released from
> the iomem_resource table even if it does not match exactly to
> an resource entry but still fits into.  The resource entries
> initialized at bootup usually cover the whole contiguous
> memory ranges and may not necessarily match with the size of
> memory hot-delete requests.
> 
> If release_mem_region_adjustable() failed, __remove_pages() emits
> a warning message and continues to proceed as it was the case
> with release_mem_region().  release_mem_region(), which is defined
> to __release_region(), emits a warning message and returns no error
> since a void function.
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Reviewed-by : Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>
