Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab3IPV2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:28:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60873 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3IPV2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:28:19 -0400
Message-ID: <523776D4.4070402@jp.fujitsu.com>
Date: Mon, 16 Sep 2013 17:23:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: liwanp@linux.vnet.ibm.com
CC: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
        iamjoonsoo.kim@lge.com, rientjes@google.com,
        zhangyanfei@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v5 3/4] mm/vmalloc: revert "mm/vmalloc.c: check
 VM_UNINITIALIZED flag in s_show instead of show_numa_info"
References: <1379202342-23140-1-git-send-email-liwanp@linux.vnet.ibm.com> <1379202342-23140-3-git-send-email-liwanp@linux.vnet.ibm.com>
In-Reply-To: <1379202342-23140-3-git-send-email-liwanp@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/14/2013 7:45 PM, Wanpeng Li wrote:
> Changelog:
>  *v2 -> v3: revert commit d157a558 directly
> 
> The VM_UNINITIALIZED/VM_UNLIST flag introduced by commit f5252e00(mm: avoid
> null pointer access in vm_struct via /proc/vmallocinfo) is used to avoid
> accessing the pages field with unallocated page when show_numa_info() is
> called. This patch move the check just before show_numa_info in order that
> some messages still can be dumped via /proc/vmallocinfo. This patch revert 
> commit d157a558 (mm/vmalloc.c: check VM_UNINITIALIZED flag in s_show instead 
> of show_numa_info);

Both d157a558 and your patch don't explain why your one is better. Yes, some
messages _can_ be dumped. But why should we do so?

And No. __get_vm_area_node() doesn't use __GFP_ZERO for allocating vm_area_struct.
dumped partial dump is not only partial, but also may be garbage.

I wonder why we need to call setup_vmalloc_vm() _after_ insert_vmap_area.
