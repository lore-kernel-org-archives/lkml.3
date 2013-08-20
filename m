Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467Ab3HTOvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:51:15 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36852 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3HTOvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:51:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130819044444.GD26832@bbox>
References: <CAKcLGm8EMruO5e8yw+nArTjyCGSvLB5pjnGZYvz0xdF9M99iwQ@mail.gmail.com>
	<52119B4E.4060409@linux.vnet.ibm.com>
	<20130819044444.GD26832@bbox>
Date: Tue, 20 Aug 2013 09:51:13 -0500
Message-ID: <CAKcLGm-wJjBeSczCi7-XkyDMd444HoQcFVfmpkPYZ2WcExCxaA@mail.gmail.com>
Subject: Re: BUG: scheduling while atomic 3.10.7 in ZRAM Swap
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Michael wang <wangyun@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchand@redhat.com>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 11:44 PM, Minchan Kim <minchan@kernel.org> wrote:
> Hello,
>
> On Mon, Aug 19, 2013 at 12:13:02PM +0800, Michael wang wrote:
>> Hi, Mitch
>>
>> On 08/17/2013 10:01 PM, Mitch Harder wrote:
>> > I'm encountering a BUG while using a ZRAM Swap device.
>> >
>> > The call trace seems to involve the changes recently added to 3.10.6
>> > by the patch:
>> > zram: use zram->lock to protect zram_free_page() in swap free notify path
>> >
>> > The hardware is a x86 single CPU AMD Athlon XP system with 1GB RAM.
>> >
>> > I'm implementing a 352MB ZRAM swap device, and also have 1GB swap
>> > space on the hard disk.
>>
>> IMHO, it was caused by that swap_entry_free() was invoked with page
>> spin-locked, thus zram_slot_free_notify() should not use rw-lock which
>> may goto sleep.
>>
>> CC folks related.
>
> Thanks for Ccing me, Michael,
>
> Mitch, It's known problem and it should be fixed by [1] in recent linux-next.
>
> [1] a0c516cbfc, zram: don't grab mutex in zram_slot_free_noity
>
> Thanks for the report!
>

Thanks.

If I apply the zram patches from linux-next, the problem seems to be resolved.
