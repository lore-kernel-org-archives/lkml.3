Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab3DZIz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 04:55:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:47481 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758706Ab3DZIzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 04:55:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,557,1363104000"; 
   d="scan'208";a="7145744"
Message-ID: <517A41C1.1010208@cn.fujitsu.com>
Date: Fri, 26 Apr 2013 16:58:41 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1365728168-32067-1-git-send-email-yinghai@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/26 16:54:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/26 16:54:17,
	Serialize complete at 2013/04/26 16:54:17
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,

It has been a long time since this patch-set was sent. I think we need to
do something to push it.

In my understanding, this patch-set did 2 things.
1. Parse numa info earlier, some improvements for 
ACPI_INITRD_TABLE_OVERRIDE.
    (patch1 ~ patch20)

2. Allocate pagetable in local node at boot time. (patch21 ~ patch22)


As you know, the current implement of memory hot-remove is not based on
putting pagetable in local node. If we put pagetable in local node at boot
time, the memory hot-remove won't be able to work as before.

I agree that this should be fixed. But we have the following two reasons to
push "Parse numa info earlier" part first, and improve the performance 
later.

1. patch21 and patch22 only affect the performance, not the functionality.
    I think we can make memory hot-remove work in the kernel, and than 
improve
    the performance.

2. Besides putting pagetable in local node at boot time, there are many 
other
    things need to do. I'm working on improving hot-add code to allocate 
pagetable
    and vmemmap in local node, and improving hot-remove code to support 
freeing
    this kind of memory.


So in order to push this patch-set and memory hot-remove functionality,
shall we divide this patch-set into 2 steps:

1. Push patch1 ~ patch20, and I'll push the remaining memory hot-remove 
work together.

2. Merge your "putting pagetable in local node" work with the 
performance improvement
    work I'm doing, and improve the performance.

How do you think ?

BTW, I'm testing your patch-set, and will give a result next week.
I can also help to rebase it if you like.

Thanks. :)

