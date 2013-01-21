Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3AUXBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 18:01:55 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:36570 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3AUXBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 18:01:53 -0500
X-Greylist: delayed 2477 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 18:01:53 EST
MIME-Version: 1.0
In-Reply-To: <20130121224526.GA23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com>
 <201301212041.17951.arnd@arndb.de> <CAKGA1bn0-83d+BFRMGZDZ9MZ2nnx8e8wh-VS3XoG5UQJDC0npg@mail.gmail.com>
 <201301212230.07393.arnd@arndb.de> <20130121224526.GA23505@n2100.arm.linux.org.uk>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 17:01:30 -0600
Message-ID: <CAKGA1b=R+KJEJx1KmBy4oshy23QVJ1=Q9qXDyrzmdMAj3bN_uw@mail.gmail.com>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Ben Dooks <ben@simtec.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 4:45 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Jan 21, 2013 at 10:30:07PM +0000, Arnd Bergmann wrote:
>> On Monday 21 January 2013, Matt Sealey wrote:
>> > So is that a bug in that it is not available to ARM right now, a bug
>> > in that it would be impossible for anyone on ARM to have ever tested
>> > this code, or a bug in that it should NEVER be enabled for ARM for
>> > some reason? John? Ingo? :)
>> >
>>
>> I think it's a bug that it's not available. That does not look intentional.
>
> What's a bug?  kernel/Kconfig.hz not being available?  No, it's
> intentional.  (See my replies).

The bug I saw as real is that CONFIG_SCHED_HRTICK is defined only in
kernel/Kconfig.hz (and used in kernel/sched only) - so if we want that
functionality enabled we will also have to opencode it in
arch/arm/Kconfig. Everyone else, by virtue of using kernel/Kconfig.hz,
gets this config item enabled for free if they have hrtimers or
generic smp helpers.. if I understood what John just said, this means
on ARM, since we don't use kernel/Kconfig.hz and we don't also define
an item for CONFIG_SCHED_HRTICK, the process scheduler is completely
oblivious that we're running in HRT mode?

The thing I don't know is real is if that really matters one bit..

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
