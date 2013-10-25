Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551Ab3JYFA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:00:29 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:64027 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3JYFA2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:00:28 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPRto2PX6J5CqNDTB42Ef7=+ZmgTdA=7Qdswc6NvN93bQ@mail.gmail.com>
References: <CAK2Ky6xH9rvmpqQ31bi1QrC=dvt9T_8+ELHUZf_MFZccV6MiAw@mail.gmail.com>
	<20131023105931.GG1275@quack.suse.cz>
	<CACVXFVPRto2PX6J5CqNDTB42Ef7=+ZmgTdA=7Qdswc6NvN93bQ@mail.gmail.com>
Date: Fri, 25 Oct 2013 13:00:27 +0800
Message-ID: <CAK2Ky6xRDcePGWB3Je7_5U5B+qq2Hx4Nv61VOcX3isL8hy7ynw@mail.gmail.com>
Subject: Re: A thought about IO scheduler in linux kernel for SSD
From: =?GB2312?B?uqvA2g==?= <bonben1989@gmail.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your thought!  It may not make much sense. Because I think
the probability of two bios have the same start sector and the
situation mentioned by Ming Lei is too low.
Thanks ,
Bonben

2013/10/25 Ming Lei <tom.leiming@gmail.com>:
> On Wed, Oct 23, 2013 at 6:59 PM, Jan Kara <jack@suse.cz> wrote:
>> On Wed 23-10-13 08:47:44, º«ÀÚ wrote:
>>> Nowadays,the IO schedulers in linux kernel have four types:
>>>
>>> deadline,noop,Anticiptory and CFQ.CFQ is the default scheduler.But CFQ is
>>> not a good scheduler for SSD,dealine may be a good choice.
>>
>>> When deadline runs,it has a mount of computation about merging and
>>> sorting.Merge has three types: front_merge,no_merge and back_merge.
>>> Why don't have  another type: merge based same sector.For example,it have
>>> two bios in a request list,theyboth have the same bi->sector,the bi->size
>>> maybe not equal. Whether can we put the latter bio replace the former?What
>>> do you find that significant?Or the other levels in OS has finished this
>>> function?
>>   That doesn't make much sense to me. If there are two bios in flight for
>> some sector, results are undefined. Thus we usually avoid such situation
>> (usually we want to have defined contents of the disk :). The exclusion is
>> usually achieved at higher level using page locking etc. So adding code
>> speeding up such requests doesn't seem worth it.
>
> The situation might be triggered when same file is read from two tasks,
> one is read via page cache, and another one is read by O_DIRECT.
>
> But still not sure if that makes sense.
>
> Thanks,
> --
> Ming Lei
