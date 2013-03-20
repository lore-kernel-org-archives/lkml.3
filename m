Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3CTQVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:21:33 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56734 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab3CTQVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:21:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130320160327.GD2273@redhat.com>
References: <20130319133326.GB3872@redhat.com>
	<1363705526-3197-1-git-send-email-yinghai@kernel.org>
	<20130320130855.GB17274@redhat.com>
	<CAE9FiQWNtNe1LdBVe9MJ-rhP1KymKUQDudHrUqQ3VuGh6nY-0w@mail.gmail.com>
	<20130320160327.GD2273@redhat.com>
Date: Wed, 20 Mar 2013 09:21:31 -0700
X-Google-Sender-Auth: vc6IXjluH14Bv_dk7pd3qJkJvR0
Message-ID: <CAE9FiQWPekbf=E98-dp+jXnXBdd+2dbzyEBCvr-ND6P2sTDXnw@mail.gmail.com>
Subject: Re: [PATCH v5] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>, Simon Horman <horms@verge.net.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 9:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 20, 2013 at 08:53:29AM -0700, Yinghai Lu wrote:
>> On Wed, Mar 20, 2013 at 6:08 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> > Have a general question about crashkernel_low. Why does it need to
>> > show up as "Crash kernel low" in /proc/iomem. Will it not be better
>> > that all memory reserved for crashkernel (whether high or low), shows
>> > as "Crash Kernel" and let kexec-tools decide whether to load kernel
>> > high or low etc.
>> >
>> > IOW, there should not be any need to differentiate between "Crash kernel"
>> > and "Crash kernel low". There are address ranges associated and looking
>> > at addresses it is obivious that certain memory is below 4G.
>>
>> yes. it is doable.
>> but
>> 1. will need to add more code to expand parse_iomem_single to handle
>> multiple "Crash kernel" in kexec-tools.
>> 2. also we already have "crashkernel_low=" in command line, so it is
>> good to keep them consistent in /proc/iomem.
>
> I think command line and /proc/iomem output are very different.
> crashkernel_low is just enforcing that reserve it below 4G and memory
> type still remains "Crash Kernel".
>
> So to me, /proc/iomem is showing ranges and memory type and both the
> memory types should be "Crash Kernel".
>
> IMHO, we should add code in kexec-tools to deal with it (multiple
> entries for memory type "Crash Kernel"), instead of especial casing
> "Crash Kernel Low". Who knows down the line we end up reserving more
> crash kernel memory which is not contiguous. Keeping all reserved
> memory of same type will help then.

ok.

Need to fix kexec-tools at first, and the drop Low in kernel.

Before v3.9 and kexec-tools 2.0.4?

Thanks

Yinghai
