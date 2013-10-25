Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3JYL0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 07:26:52 -0400
Received: from mail.lang.hm ([64.81.33.126]:39973 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573Ab3JYL0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 07:26:50 -0400
Date: Fri, 25 Oct 2013 04:26:37 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: NeilBrown <neilb@suse.de>
cc: "Artem S. Tashkinov" <t.artem@lycos.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, linux-mm@kvack.org
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
In-Reply-To: <20131025214952.3eb41201@notabene.brown>
Message-ID: <alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07> <20131025214952.3eb41201@notabene.brown>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Oct 2013, NeilBrown wrote:

> On Fri, 25 Oct 2013 07:25:13 +0000 (UTC) "Artem S. Tashkinov"
> <t.artem@lycos.com> wrote:
>
>> Hello!
>>
>> On my x86-64 PC (Intel Core i5 2500, 16GB RAM), I have the same 3.11 kernel
>> built for the i686 (with PAE) and x86-64 architectures. What's really troubling me
>> is that the x86-64 kernel has the following problem:
>>
>> When I copy large files to any storage device, be it my HDD with ext4 partitions
>> or flash drive with FAT32 partitions, the kernel first caches them in memory entirely
>> then flushes them some time later (quite unpredictably though) or immediately upon
>> invoking "sync".
>>
>> How can I disable this memory cache altogether (or at least minimize caching)? When
>> running the i686 kernel with the same configuration I don't observe this effect - files get
>> written out almost immediately (for instance "sync" takes less than a second, whereas
>> on x86-64 it can take a dozen of _minutes_ depending on a file size and storage
>> performance).
>
> What exactly is bothering you about this?  The amount of memory used or the
> time until data is flushed?

actually, I think the problem is more the impact of the huge write later on.

David Lang

> If the later, then /proc/sys/vm/dirty_expire_centisecs is where you want to
> look.
> This defaults to 30 seconds (3000 centisecs).
> You could make it smaller (providing you also shrink
> dirty_writeback_centisecs in a similar ratio) and the VM will flush out data
> more quickly.
>
> NeilBrown
>
>
>>
>> I'm _not_ talking about disabling write cache on my storage itself (hdparm -W 0 /dev/XXX)
>> - firstly this command is detrimental to the performance of my PC, secondly, it won't help
>> in this instance.
>>
>> Swap is totally disabled, usually my memory is entirely free.
>>
>> My kernel configuration can be fetched here: https://bugzilla.kernel.org/show_bug.cgi?id=63531
>>
>> Please, advise.
>>
>> Best regards,
>>
>> Artem
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
