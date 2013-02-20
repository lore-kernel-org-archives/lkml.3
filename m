Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935230Ab3BTM0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:26:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab3BTM0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:26:49 -0500
X-IronPort-AV: E=Sophos;i="4.84,701,1355068800"; 
   d="scan'208";a="6736858"
Message-ID: <5124B991.1020302@cn.fujitsu.com>
Date: Wed, 20 Feb 2013 19:54:57 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        bcrl@kvack.org, viro@zeniv.linux.org.uk, khlebnikov@openvz.org,
        walken@google.com, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org,
        riel@redhat.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, jiang.liu@huawei.com,
        mhocko@suse.cz, linux-mm@kvack.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: hotplug: implement non-movable version of get_user_pages()
 called get_user_pages_non_movable()
References: <1359972248-8722-1-git-send-email-linfeng@cn.fujitsu.com> <1359972248-8722-2-git-send-email-linfeng@cn.fujitsu.com> <20130204160624.5c20a8a0.akpm@linux-foundation.org> <20130205115722.GF21389@suse.de> <20130205133244.GH21389@suse.de> <51249E3E.9070909@gmail.com> <5124A42B.1020905@cn.fujitsu.com> <5124B42A.1020908@gmail.com>
In-Reply-To: <5124B42A.1020908@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:55:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 19:55:59,
	Serialize complete at 2013/02/20 19:55:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/20/2013 07:31 PM, Simon Jeons wrote:
> On 02/20/2013 06:23 PM, Lin Feng wrote:
>> Hi Simon,
>>
>> On 02/20/2013 05:58 PM, Simon Jeons wrote:
>>>> The other is that this almost certainly broken for transhuge page
>>>> handling. gup returns the head and tail pages and ordinarily this is ok
>>> When need gup thp? in kvm case?
>> gup just pins the wanted pages(for x86 is 4k size) of user address space in memory.
>> We can't expect the pages have been allocated for user address space are thp or
>> normal page. So we need to deal with them and I think it have nothing to do with kvm.
> 
> Ok, I'm curious about userspace process call which funtion(will call gup) to pin pages except make_pages_present?
No, userspace process doesn't pin any pages directly but through some syscalls like io_setup() indirectly
for other purpose because kernel can't pagefault and it have to keep the page alive.
Kernel wants to communicate with the userspace such as to notify some events so it need some sort of buffer
that both Kernel and User space can both access, which leads to so called pin pages by gup.  

thanks,
linfeng
