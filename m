Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab3KFW0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:26:10 -0500
Received: from mail.lang.hm ([64.81.33.126]:47652 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3KFW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:26:08 -0500
Date: Mon, 4 Nov 2013 17:47:34 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: "Figo.zhang" <figo1802@gmail.com>
cc: NeilBrown <neilb@suse.de>, "Artem S. Tashkinov" <t.artem@lycos.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        Linux-MM <linux-mm@kvack.org>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
In-Reply-To: <CAF7GXvpJVLYDS5NfH-NVuN9bOJjAS5c1MQqSTjoiVBHJt6bWcw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1311041744460.11629@nftneq.ynat.uz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07> <20131025214952.3eb41201@notabene.brown> <alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz> <154617470.12445.1382725583671.JavaMail.mail@webmail11> <20131026074349.0adc9646@notabene.brown>
 <476525596.14731.1382735024280.JavaMail.mail@webmail11> <20131026091112.241da260@notabene.brown> <CAF7GXvpJVLYDS5NfH-NVuN9bOJjAS5c1MQqSTjoiVBHJt6bWcw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013, Figo.zhang wrote:

>>>
>>> Of course, if you don't use Linux on the desktop you don't really care -
>> well, I do. Also
>>> not everyone in this world has an UPS - which means such a huge buffer
>> can lead to a
>>> serious data loss in case of a power blackout.
>>
>> I don't have a desk (just a lap), but I use Linux on all my computers and
>> I've never really noticed the problem.  Maybe I'm just very patient, or
>> maybe
>> I don't work with large data sets and slow devices.
>>
>> However I don't think data-loss is really a related issue.  Any process
>> that
>> cares about data safety *must* use fsync at appropriate places.  This has
>> always been true.
>>
>> =>May i ask question that, some like ext4 filesystem, if some app motify
> the files, it create some dirty data. if some meta-data writing to the
> journal disk when a power backout,
> it will be lose some serious data and the the file will damage?
>

with any filesystem and any OS, if you create dirty data but do not f*sync() the 
data, there isa possibility that the system can go down between the time the 
application creates the dirty data and the time the OS actually gets it on disk. 
If the system goes down in this timeframe, the data will be lost and it may 
corrupt the file if only some of the data got written.

David Lang
