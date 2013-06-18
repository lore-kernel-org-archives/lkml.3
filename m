Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab3FRHNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:13:54 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:63551 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3FRHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVVGdDMxO5RmHSzAcB_cu49EQFiNLxswS7U0Nt5-J774w@mail.gmail.com>
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com>
	<1371128589-8953-17-git-send-email-tangchen@cn.fujitsu.com>
	<20130618015806.GY32663@mtj.dyndns.org>
	<CAE9FiQVVGdDMxO5RmHSzAcB_cu49EQFiNLxswS7U0Nt5-J774w@mail.gmail.com>
Date: Tue, 18 Jun 2013 00:13:52 -0700
X-Google-Sender-Auth: lSu6pDlHcpzP6rFKqIFtSLTuHzA
Message-ID: <CAE9FiQUUcprDmEtTiTAZXWjWP9MCmjF+onFD9S2OcZi=Mr54QQ@mail.gmail.com>
Subject: Re: [Part1 PATCH v5 16/22] x86, mm, numa: Move numa emulation
 handling down.
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        Rik van Riel <riel@redhat.com>, jweiner@redhat.com,
        Prarit Bhargava <prarit@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:22 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Jun 17, 2013 at 6:58 PM, Tejun Heo <tj@kernel.org> wrote:
>> On Thu, Jun 13, 2013 at 09:03:03PM +0800, Tang Chen wrote:
>>> From: Yinghai Lu <yinghai@kernel.org>
>>>
>>> numa_emulation() needs to allocate buffer for new numa_meminfo
>>> and distance matrix, so execute it later in x86_numa_init().
>>>
>>> Also we change the behavoir:
>>>       - before this patch, if user input wrong data in command
>>>         line, it will fall back to next numa probing or disabling
>>>         numa.
>>>       - after this patch, if user input wrong data in command line,
>>>         it will stay with numa info probed from previous probing,
>>>         like ACPI SRAT or amd_numa.
>>>
>>> We need to call numa_check_memblks to reject wrong user inputs early
>>> so that we can keep the original numa_meminfo not changed.
>>
>> So, this is another very subtle ordering you're adding without any
>> comment and I'm not sure it even makes sense because the function can
>> fail after that point.
>
> Yes, if it fail, we will stay with current numa info from firmware.
> That looks like right behavior.
>
> Before this patch, it will fail to next numa way like if acpi srat + user
> input fail, it will try to go with amd_numa then try apply user info.
>
>>
>> I'm getting really doubtful about this whole approach of carefully
>> splitting discovery and registration.  It's inherently fragile like
>> hell and the poor documentation makes it a lot worse.  I'm gonna reply
>> to the head message.
>
> Maybe look at the patch is not clear enough, but if looks at the final changed
> code it would be more clear.

update the patches from 1-15 with your review.

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-mm

https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/log/?h=for-x86-mm

Yinghai
