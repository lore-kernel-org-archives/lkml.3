Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaAVXgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:36:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:46087 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752338AbaAVXgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:36:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,702,1384272000"; 
   d="scan'208";a="9445257"
Message-ID: <52E056AF.8060005@cn.fujitsu.com>
Date: Thu, 23 Jan 2014 07:39:27 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: hang on early boot, numa init code stack overflow?
References: <20140122163244.GA24936@redhat.com>
In-Reply-To: <20140122163244.GA24936@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 07:35:22,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 07:35:22,
	Serialize complete at 2014/01/23 07:35:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:32 AM, Dave Jones wrote:
> I'm seeing a hang during boot on my test box running the current tree,
> It doesn't always happen, perhaps one in five boots.
> I managed to get a partial trace after booting with earlyprintk=vga
>
> dump_stack
> panic
> ? numa_clear_kernel_node_hotplug
> __stack_chk_fail
> numa_clear_kernel_node_hotplug
> ? memblock_search_pfn_nid
> ? __early_pfn_to_nid
> numa_init
> x86_numa_init
> initmem_init
> setup_arch
> start_kernel
>
> Looks like something overflowed the stack.
> This is just a quad-core i5, nothing fancy numa-wise.
>
> This code was added in a0acda917284183f9b71e2d08b0aa0aea722b321

Will send a patch to fix it today.

Thanks.

>
> 	Dave
>
>
