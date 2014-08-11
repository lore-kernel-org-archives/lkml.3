Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaHKMDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:03:32 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44392 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaHKMDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1408110448470.15519@chino.kir.corp.google.com>
References: <CAOLZvyFuDqi4+pEae=n7+ZJoAx-vca-pRS8ZAQqvTk-tSyPiwg@mail.gmail.com>
 <alpine.DEB.2.02.1408110448470.15519@chino.kir.corp.google.com>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Mon, 11 Aug 2014 14:02:49 +0200
Message-ID: <CAOLZvyGUBy_aezR32kUiwGSpT0CJhK9_b6_ApCi8GJwJAQNpQw@mail.gmail.com>
Subject: Re: MIPS: hang in kmalloc with seccomp writer locks
To: David Rientjes <rientjes@google.com>
Cc: Kees Cook <keescook@chromium.org>, Linux-MIPS <linux-mips@linux-mips.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 1:49 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 11 Aug 2014, Manuel Lauss wrote:
>
>> Hi Kees,
>>
>> My MIPS32 toys hang early during bootup at the first kmalloc() with
>> seccomp enabled.
>> I've bisected it to commit dbd952127d11bb44a4ea30b08cc60531b6a23d71
>> ("seccomp: introduce writer locking").  And indeed, reverting this
>> commit fixes the hang.
>>
>> I'm not sure if seccomp is even working on MIPS, but I've never had
>> problems with
>> it before so I thought I let you know.
>>
>
> Does enabling CONFIG_DEBUG_SPINLOCK fix the issue?

Yes it does indeed.


Manuel
