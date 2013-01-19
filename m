Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964Ab3ASKuR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:50:17 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35760 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3ASKuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:50:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
References: <1358182435-19245-1-git-send-email-avagin@openvz.org>
	<1358182435-19245-3-git-send-email-avagin@openvz.org>
	<20130116123502.70af6b85.akpm@linux-foundation.org>
	<CAKgNAkgHVB3=k_XOevobcMWuEqy2r75tdTc85ZYiD8rkn5OZKA@mail.gmail.com>
Date: Sat, 19 Jan 2013 14:50:12 +0400
Message-ID: <CANaxB-wXdPZFzD3BhkD6niDA6M1NiNrc5coKf9bSx+ar_fZecg@mail.gmail.com>
Subject: Re: [PATCH 2/3] signalfd: add ability to return siginfo in a raw
 format (v2)
From: Andrey Wagin <avagin@gmail.com>
To: mtk.manpages@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        criu@openvz.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/19 Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>:
>> As SFD_RAW is being added to the kernel API we should document it.
>> Please keep Michael cc'ed and work with him on getting the manpages
>> updated.
>
> The API is certainly no thing of beauty, as I already remarked here:
> http://thread.gmane.org/gmane.linux.file-systems/70420/focus=1420228

All of us have similar thoughts, but we don't know a better solution.

Here is an example of usage signalfd and pread:
http://lists.openvz.org/pipermail/criu/2013-January/007040.html

>
> A description of the API can be found here:
> https://lwn.net/Articles/531939/

Thanks you for the attempt to involve more people to this discussion.

>
> The main problem is the ugliness of changing the meaning of pread()'s
> 'offset' argument to be a multiplexed [signal queue selector + queue
> position].
>
> I do wonder if we can do better, though I have no particular solution
> to offer beyond the sledgehammer of adding a new system call.

If we are choosing between this interface or a new syscall, I would
prefer this interface. signalfd is a special descriptor, so I think it
is not a big deal, that it works a bit strange. If all other would
decides, that a new syscall is better, I will not ague.

Michael, thank you for the comments.

>
> Cheers,
>
> Michael
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Author of "The Linux Programming Interface"; http://man7.org/tlpi/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
