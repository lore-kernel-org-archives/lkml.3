Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934353AbaFSTPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:15:39 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:39521 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaFSTPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:15:37 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140619170059.GA1224@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
	<CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
	<20140619170059.GA1224@kroah.com>
Date: Thu, 19 Jun 2014 21:15:36 +0200
X-Google-Sender-Auth: kxOSwlaoqmFU0C4R9fAXsRatk98
Message-ID: <CAKMK7uFa57YjeJCFQhWFr_5cRTTpWxBdJ1qtb5Ojnu-KZpe-Lw@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 7:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> +     BUG_ON(f1->context != f2->context);
>> >
>> > Nice, you just crashed the kernel, making it impossible to debug or
>> > recover :(
>>
>> agreed, that should probably be 'if (WARN_ON(...)) return NULL;'
>>
>> (but at least I wouldn't expect to hit that under console_lock so you
>> should at least see the last N lines of the backtrace on the screen
>> ;-))
>
> Lots of devices don't have console screens :)

Aside: This is a pet peeve of mine and recently I've switched to
rejecting all patch that have a BUG_ON, period. Except when you can
prove that the kernel will die in the next few lines and there's
nothing you can do about it a WARN_ON is always better - I've wasted
_way_ too much time debugging hard hangs because such a "benign"
BUG_ON ended up eating my irq handler or a spinlock required by such.
Or some other nonsense that makes debugging a royal pita, especially
if your remote debugger consists of a frustrated users staring at a
hung machine.

</rant>

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
