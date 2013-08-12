Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3HLQaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:30:11 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50856 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab3HLQaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:30:06 -0400
Message-ID: <52090D7F.6060600@gmail.com>
Date: Tue, 13 Aug 2013 00:29:51 +0800
From: Tang Chen <imtangchen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Tang Chen <tangchen@cn.fujitsu.com>,
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
        linux-acpi@vger.kernel.org,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com> <20130812145016.GI15892@htj.dyndns.org> <5208FBBC.2080304@zytor.com> <20130812152343.GK15892@htj.dyndns.org>
In-Reply-To: <20130812152343.GK15892@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 11:23 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, Aug 12, 2013 at 08:14:04AM -0700, H. Peter Anvin wrote:
>> It gets really messy if it is advisory.  Suddenly you have the user
>> thinking they can hotswap a memory bank and they just can't.
>
> I'm very skeptical that not doing the strict re-ordering would
> increase the chance of reaching memory allocation where hot unplug
> would be impossible by much.  Given that, it'd be much better to be
> able to boot w/o hotunplug capability than to fail boot.  The kernel
> can whine loudly when hotunplug conditions aren't met but I think that
> really is as far as that should go.

As you said, we can ensure at least one node to be unhotplug. Then the
kernel will boot anyway. Just like CPU0. But we have the chance to lose
one movable node.

The best way is firmware and software corporate together. SRAT provides
several movable node and enough non-movable memory for the kernel to
boot. The hotplug users only use movable node.

>
>> Overall, I'm getting convinced that this whole approach is just doomed
>> to failure -- it will not provide the user what they expect and what
>> they need, which is to be able to hotswap any particular chunk of
>> memory.  This means that there has to be a remapping layer, either using
>> the TLBs (perhaps leveraging the Xen machine page number) or using
>> things like QPI memory routing.
>
> For hot unplug to work in completely generic manner, yeah, there
> probably needs to be an extra layer of indirection.

I agree too.

> Have no idea what
> the correct way to achieve that would be tho.  I'm also not sure how
> practicial memory hot unplug is for physical machines and improving
> ballooning could be a better approach for vms.

But, different users have different ways to use memory hotplug.

Hotswaping any particular chunk of memory is the goal we will reach
finally. But it is on specific hardware. In most current machines, we
can use movable node to manage resource in node unit.

And also, without this movablenode boot option, the MOVABLE_NODE
functionality, which is already in the kernel, will not be able to
work. All nodes has kernel memory means no movable node.

So, how about this: Just like MOVABLE_NODE functionality, introduce
a new config option. When we have better solutions for memory hotplug,
we shutoff or remove the config and related code.

For now, at least make movable node work.

Thanks.

