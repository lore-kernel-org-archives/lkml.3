Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab3LDQwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:52:37 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:37997 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932901Ab3LDQwf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <20131204070442.GA31665@kroah.com>
References: <CANsc=4VRLWhaVA15HrBEeM+FJC0tS+b5KKopDb7bP8nxzR8=zA@mail.gmail.com>
	<20131204070442.GA31665@kroah.com>
Date: Wed, 4 Dec 2013 11:52:34 -0500
Message-ID: <CANsc=4UHEG5cmg9SD3r3rsuJnM9zqq2WiTQdUwrYFr_kkbsVvg@mail.gmail.com>
Subject: Re: [PATCH 0/3] ARM Coresight: Enhance ETM tracing control
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

First, please excuse me for these misformatted patches that my email
client messed up. Next time I will use git send-email. The 3 patches
can be found on
http://git.dorsal.polymtl.ca/~averge?p=linux.git;a=shortlog;h=refs/heads/etm_with_addr_and_pid

Greg: you're right, sysfs is a questionable place for tracing/debug
code. Debugfs or /dev entries would be the right place.

Though, the only support for ETM in Linux is there, and currently very
limited because tracing options such as address and pid are not
configurable. The code I propose would make it usable, until someone
with time (and more experience than me ;)) moves it out from sysfs.

Thanks,

Adrien

2013/12/4 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Tue, Dec 03, 2013 at 11:39:21PM -0500, Adrien Vergé wrote:
>> Usage of ETM tracing facility is currently very limited: user can
>> only start/stop tracing. This set of patches enables management of
>> address combinations and PIDs that trigger tracing.
>>
>> ETM management was done via sysfs entries (trace_info,
>> trace_running...), this code adds trace_addrrange and trace_pid to
>> let the user read/write custom values.
>
> I have lots to say about this from a sysfs point of view, but first, why
> is it in sysfs at all?  Shouldn't all of this be in debugfs?
>
> greg k-h
