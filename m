Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834Ab3BNKlT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:41:19 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49848 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab3BNKlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:41:18 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <24327774.p6haZy6gvA@vostro.rjw.lan>
References: <1360113112.17267.1.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
	<CAJfpegvV0zQ5Lftx=ELP0MAH1-7oY5HfT-CSYEaFUWJLmXoD7A@mail.gmail.com>
	<CAJfpegsFThkzv3uF60AMXO7Y-yEzU_20HeGyPra0O8Vk5OqCGQ@mail.gmail.com>
	<24327774.p6haZy6gvA@vostro.rjw.lan>
Date: Thu, 14 Feb 2013 11:41:16 +0100
Message-ID: <CAJfpegtUOCTNR-uzrFBcFY3K8to2+y3hvJx=vuBYS7emzU-SRA@mail.gmail.com>
Subject: Re: Getting rid of freezer for suspend [was Re: [fuse-devel] [PATCH]
 fuse: make fuse daemon frozen along with kernel threads]
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Goswin von Brederlow <goswin-v-b@web.de>,
        Li Fei <fei.li@intel.com>, len.brown@intel.com, mingo@redhat.com,
        peterz@infradead.org, biao.wang@intel.com, linux-pm@vger.kernel.org,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 10:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, February 13, 2013 06:34:16 PM Miklos Szeredi wrote:

>>
>> So I think the PF_FREEZE_DAEMON idea (the patch from Li Fei that
>> started this thread) may still be our best bet at handling this
>> situation.  The idea being that pure "originator" processes (ones that
>> take no part in serving filesystem syscalls) can be frozen up-front.
>> Then the "fuse daemon" (or "server") processes are hopefully in a
>> quiescent state and can be frozen without difficulty.
>>
>> Unfortunately it needs help from userspace: the kernel can't easily
>> guess which processes are part of a "fuse daemon" and which aren't.
>> Fortunately we have a standard library (libfuse) that can tell it to
>> the kernel for the vast majority of cases.
>
> So basically the idea would be to introduce something like PF_FREEZE_LATE
> for user space processes that need to be frozen after all of the other
> (non-PF_FREEZE_LATE) user space processes have been frozen and hack fuse
> to use that flag?

Yes.

It is essentially the same mechanism that is used to delay the
freezing of kernel threads after userspace tasks have been frozen.
Except it's a lot more difficult to determine which userspace tasks
need to be suspended late and which aren't.

Thanks,
Miklos
