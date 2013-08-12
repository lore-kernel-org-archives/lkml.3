Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585Ab3HLRY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51584 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725Ab3HLRYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:24:52 -0400
Message-ID: <52091A10.4030501@zytor.com>
Date: Mon, 12 Aug 2013 10:23:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tang Chen <imtangchen@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Tang Chen <tangchen@cn.fujitsu.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com> <20130812145016.GI15892@htj.dyndns.org> <52090225.6070208@gmail.com> <20130812154623.GL15892@htj.dyndns.org> <52090AF6.6020206@gmail.com> <20130812162247.GM15892@htj.dyndns.org> <520914D5.7080501@gmail.com>
In-Reply-To: <520914D5.7080501@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:01 AM, Tang Chen wrote:
>>
>>> I'm just thinking of a more extreme case. For example, if a machine
>>> has only one node hotpluggable, and the kernel resides in that node.
>>> Then the system has no hotpluggable node.
>>
>> Yeah, sure, then there's no way that node can be hotpluggable and the
>> right thing to do is booting up the machine and informing the userland
>> that memory is not hotpluggable.
>>
>>> If we can prevent the kernel from using hotpluggable memory, in such
>>> a machine, users can still do memory hotplug.
>>>
>>> I wanted to do it as generic as possible. But yes, finding out the
>>> nodes the kernel resides in and make it unhotpluggable can work.
>>
>> Short of being able to remap memory under the kernel, I don't think
>> this can be very generic and as a compromise trying to keep as many
>> hotpluggable nodes as possible doesn't sound too bad.
> 
> I think making one of the node hotpluggable is better. But OK, it is
> no big deal. There won't be such machine in reality, I think. :)
> 

The user may very well have configured a system with mirrored memory for
the kernel node as that will be non-hotpluggable, but not for the
others.  One can wonder how much that actually buys in real life, but
still...

	-hpa


