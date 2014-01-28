Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaA1A7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:59:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:15648 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbaA1A66 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:58:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,732,1384272000"; 
   d="scan'208";a="9459268"
Message-ID: <52E70165.8070709@cn.fujitsu.com>
Date: Tue, 28 Jan 2014 09:01:25 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com> <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 08:57:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/28 08:57:22,
	Serialize complete at 2014/01/28 08:57:22
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 08:32 AM, David Rientjes wrote:
> On Wed, 22 Jan 2014, David Rientjes wrote:
>
>>>   arch/x86/mm/numa.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
>>> index 81b2750..ebefeb7 100644
>>> --- a/arch/x86/mm/numa.c
>>> +++ b/arch/x86/mm/numa.c
>>> @@ -562,10 +562,10 @@ static void __init numa_init_array(void)
>>>   	}
>>>   }
>>>
>>> +static nodemask_t numa_kernel_nodes __initdata;
>>>   static void __init numa_clear_kernel_node_hotplug(void)
>>>   {
>>>   	int i, nid;
>>> -	nodemask_t numa_kernel_nodes;
>>>   	unsigned long start, end;
>>>   	struct memblock_type *type =&memblock.reserved;
>>>
>>
>> Isn't this also a bugfix since you never initialize numa_kernel_nodes when
>> it's allocated on the stack with NODE_MASK_NONE?
>>
>
> This hasn't been answered and the patch still isn't in linux-kernel yet
> Dave tested it as good.  I'm suspicious of the changelog that indicates
> this nodemask is the result of a stack overflow itself which only manages
> to reproduce itself in the init patch slightly more than 50% of the time.
> How is that possible?
>
> I think the changelog should indicate this also fixes an uninitialized
> nodemask issue.

Hi David,

I'm still working on this problem, but unfortunately nothing new for now.
And the test till now shows no more problem here.

I'm digging into it, but need more time.

I'll resend a new patch and modify the changelog soon. Before we find the
root cause, I think we can use this patch as a temporary solution.

Thanks.


