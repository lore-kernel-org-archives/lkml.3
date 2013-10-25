Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab3JYECP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 00:02:15 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:46702 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab3JYECO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 00:02:14 -0400
MIME-Version: 1.0
In-Reply-To: <20131023105931.GG1275@quack.suse.cz>
References: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
	<20131023105931.GG1275@quack.suse.cz>
Date: Fri, 25 Oct 2013 12:02:12 +0800
Message-ID: <CACVXFVPRto2PX6J5CqNDTB42Ef7=+ZmgTdA=7Qdswc6NvN93bQ@mail.gmail.com>
Subject: Re: A thought about IO scheduler in linux kernel for SSD
From: Ming Lei <tom.leiming@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: =?UTF-8?B?6Z+p56OK?= <bonben1989@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 6:59 PM, Jan Kara <jack@suse.cz> wrote:
> On Wed 23-10-13 08:47:44, 韩磊 wrote:
>> Nowadays,the IO schedulers in linux kernel have four types:
>>
>> deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is
>> not a good scheduler for SSD,dealine may be a good choice.
>
>> When deadline runs,it has a mount of computation about merging and
>> sorting.Merge has three types: front_merge,no_merge and back_merge.
>> Why don't have  another type: merge based same sector.For example,it have
>> two bios in a request list,theyboth have the same bi->sector,the bi->size
>> maybe not equal. Whether can we put the latter bio replace the former?What
>> do you find that significant?Or the other levels in OS has finished this
>> function?
>   That doesn't make much sense to me. If there are two bios in flight for
> some sector, results are undefined. Thus we usually avoid such situation
> (usually we want to have defined contents of the disk :). The exclusion is
> usually achieved at higher level using page locking etc. So adding code
> speeding up such requests doesn't seem worth it.

The situation might be triggered when same file is read from two tasks,
one is read via page cache, and another one is read by O_DIRECT.

But still not sure if that makes sense.

Thanks,
-- 
Ming Lei
