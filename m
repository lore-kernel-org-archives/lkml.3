Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbaGOJBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:01:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56618 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbaGOJB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:01:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53C4EDE5.2040507@roeck-us.net>
Date: Tue, 15 Jul 2014 02:01:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
References: <20140715132946.771def89@canb.auug.org.au>	<53C4BF8E.4010509@roeck-us.net> <20140715155547.25959587@canb.auug.org.au>
In-Reply-To: <20140715155547.25959587@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 10:55 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Mon, 14 Jul 2014 22:43:42 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On 07/14/2014 08:29 PM, Stephen Rothwell wrote:
>>>
>>> After merging the v4l-dvb tree, today's linux-next build (powerpc ppc64_defconfig)
>>> failed like this:
>>>
>>> arch/powerpc/kernel/smp.c:764:2: error: initialization from incompatible pointer type [-Werror]
>>>     { cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
>>>     ^
>>> arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'powerpc_topology[0].sd_flags') [-Werror]
>>>
>>> Caused by commit 6a0b50087a89 ("Merge branch 'patchwork' into
>>> to_next").  The change to include/linux/sched.h in this merge commit
>>> does not seem to appear in either of the parents of the merge.
>>>
>>> Its also a change that (when suggested) was shown to cause more
>>> problems than it was worth and dropped.  I can't imagine how it ended
>>> up in the merge commit.
>>>
>>
>> Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that was accepted
>> a week or so ago.
>
> That is in the tip tree and includes the fixups to powerpc and arm.  I
> don't merge the tip tree till well after the v4l-dvb tree.  The merge
> in the v4l-dvb tree included only the change to include/linus/sched.h
> and neither parent fo that merge was based on the tip tree ...
>

Ah, looks like that is the older version of my patch. You are right, this version
did have problems.

Thanks,
Guenter

