Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaFSTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:20:53 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33336 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757570AbaFSTUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:20:50 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140619181918.GA24155@kroah.com>
References: <20140618102957.15728.43525.stgit@patser>
	<20140618103653.15728.4942.stgit@patser>
	<20140619011327.GC10921@kroah.com>
	<CAF6AEGv4Ms+zsrEtpA10bGq04LnRjzVb925co49eVxh4ugkd=A@mail.gmail.com>
	<20140619170059.GA1224@kroah.com>
	<CAF6AEGuXKw1w=outX+QgFE2XZxV8c6pyhORL+mRp4uZR8Jnq7g@mail.gmail.com>
	<20140619181918.GA24155@kroah.com>
Date: Thu, 19 Jun 2014 21:20:50 +0200
X-Google-Sender-Auth: GwuFBkoey5wVKWlXeG6Szgf_Ww4
Message-ID: <CAKMK7uF-TpQpZYgZkt3pt55TNcoB-8dU3NCHYKmswTsC=Ka4rw@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
From: Daniel Vetter <daniel@ffwll.ch>
To: Greg KH <gregkh@linuxfoundation.org>, Dave Airlie <airlied@gmail.com>
Cc: Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
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

On Thu, Jun 19, 2014 at 8:19 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> >> > EXPORT_SYMBOL_GPL()?  Same goes for all of the exports in here.
>> >> > Traditionally all of the driver core exports have been with this
>> >> > marking, any objection to making that change here as well?
>> >>
>> >> tbh, I prefer EXPORT_SYMBOL()..  well, I'd prefer even more if there
>> >> wasn't even a need for EXPORT_SYMBOL_GPL(), but sadly it is a fact of
>> >> life.  We already went through this debate once with dma-buf.  We
>> >> aren't going to change $evil_vendor's mind about non-gpl modules.  The
>> >> only result will be a more flugly convoluted solution (ie. use syncpt
>> >> EXPORT_SYMBOL() on top of fence EXPORT_SYMBOL_GPL()) just as a
>> >> workaround, with the result that no-one benefits.
>> >
>> > It has been proven that using _GPL() exports have caused companies to
>> > release their code "properly" over the years, so as these really are
>> > Linux-only apis, please change them to be marked this way, it helps
>> > everyone out in the end.
>>
>> Well, maybe that is the true in some cases.  But it certainly didn't
>> work out that way for dma-buf.  And I think the end result is worse.
>>
>> I don't really like coming down on the side of EXPORT_SYMBOL() instead
>> of EXPORT_SYMBOL_GPL(), but if we do use EXPORT_SYMBOL_GPL() then the
>> result will only be creative workarounds using the _GPL symbols
>> indirectly by whatever is available via EXPORT_SYMBOL().  I don't
>> really see how that will be better.
>
> You are saying that you _know_ companies will violate our license, so
> you should just "give up"?  And how do you know people aren't working on
> preventing those "indirect" usages as well?  :)
>
> Sorry, I'm not going to give up here, again, it has proven to work in
> the past in changing the ways of _very_ large companies, why stop now?

Dave should chime in here since currently dma-buf is _GPL and the
drm_prime.c wrapper for it is not (and he merged that one, contributed
from said $vendor). And since we're gfx people everything we do is MIT
licensed (that's where X is from after all), so _GPL for for drm stuff
really doesn't make a lot of sense for us. ianal and all that applies.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
