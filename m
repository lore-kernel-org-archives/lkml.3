Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaFJUFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:05:45 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36434 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaFJUFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkiR2xt7xnkgGDg5zKfGRoPtveWG8Jjh5=aD76L6jK7C8w@mail.gmail.com>
References: <20140428212517.200264067@openvz.org> <20140428213301.507657833@openvz.org>
 <alpine.DEB.2.02.1405220643170.9695@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1405220656130.9695@ionos.tec.linutronix.de>
 <20140610163530.GF2243@moon> <CAKgNAkiR2xt7xnkgGDg5zKfGRoPtveWG8Jjh5=aD76L6jK7C8w@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 10 Jun 2014 13:05:22 -0700
Message-ID: <CALCETrV5augTv4bXFmfnifiAGZGw2DfNHrpBUYAp_bBsJvWRBQ@mail.gmail.com>
Subject: Re: [patch 3/3] timerfd: Implement write method
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, vdavydov@parallels.com,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 1:03 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> [CC += linux-api@]
>
> On Tue, Jun 10, 2014 at 6:35 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> On Thu, May 22, 2014 at 06:58:19AM +0900, Thomas Gleixner wrote:
>>> >
>>> > So what wakes a potential waiter in read/poll?
>>>
>>> And who is updating timerfd_create(2) ?
>>
>> Thomas, could you please take a look if the approach below is acceptable?
>> If it will be fine I update manpage then.
>> ---
>> From: Cyrill Gorcunov <gorcunov@openvz.org>
>> Subject: timerfd: Implement timerfd_ioctl method to restore timerfd_ctx::ticks
>>
>> The read() of timerfd files allows to fetch the number of timer ticks
>> while there is no way to set it back from userspace.
>>
>> To restore the timer's state as it was at checkpoint moment we need
>> a path to bring @ticks back. Initially I thought about writing ticks
>> back via write() interface but it seems such API is somehow obscure.
>>
>> Instead implement timerfd_ioctl() method with TFD_IOC_SET_TICKS
>> command which requires CAP_SYS_RESOURCE capability to be able to
>> set @ticks into arbitrary value. Note this command doesn't wake
>> up readers/waiters and its purpose only to serve C/R needs
>> (for same sake I wrapped code with CONFIG_CHECKPOINT_RESTORE).
>> Still if needed the ioctl may be extended for new commands
>> and CONFIG_CHECKPOINT_RESTORE dropped off.

Why does this need CAP_SYS_RESOURCE?

--Andy
