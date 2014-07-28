Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaG1SZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:25:18 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38219 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaG1SZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:25:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140728181456.GO15536@arm.com>
References: <20140722153623.25088.37742.stgit@buzz>
	<20140722153635.25088.14197.stgit@buzz>
	<20140728181456.GO15536@arm.com>
Date: Mon, 28 Jul 2014 22:25:14 +0400
Message-ID: <CALYGNiNJDHfQm2yk067hh-Wywsb_Ki5AEE_sTMkYegJi9spSzw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: LPAE: reduce damage caused by idmap to virtual
 memory layout
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Vitaly Andrianov <vitalya@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Cyril Chemparathy <cyril@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 10:14 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Jul 22, 2014 at 04:36:35PM +0100, Konstantin Khlebnikov wrote:
>> idmap layout combines both phisical and virtual addresses.
>> Everything works fine if ram physically lays below PAGE_OFFSET.
>> Otherwise idmap starts punching huge holes in virtual memory layout.
>> It maps ram by 2MiB sections, but when it allocates new pmd page it
>> cuts 1GiB at once.
>>
>> This patch makes a copy of all affected pmds from init_mm.
>> Only few (usually one) 2MiB sections will be lost.
>> This is not eliminates problem but makes it 512 times less likely.
>
> I'm struggling to understand your commit message, but making a problem `512
> times less likely' does sound like a bit of a hack to me. Can't we fix this
> properly instead?

Yep, my comment sucks.

Usually idmap looks like this:

|0x00000000 -- <chunk of physical memory in identical mapping > --- |
TASK_SIZE -- <kernel space vm layoyt> --- 0xFFFFFFFF |

But when that physical memory chunk starts from 0xE8000000 or even
0xF2000000 evenything becomes very complicated.

>
> Will
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
