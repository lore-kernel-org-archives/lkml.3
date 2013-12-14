Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3LNQLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 11:11:54 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42285 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3LNQLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 11:11:52 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20131214123709.GE17467@mithrandir>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
	<52AA0FC4.3090606@vmware.com>
	<CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com>
	<20131214123709.GE17467@mithrandir>
Date: Sat, 14 Dec 2013 17:05:31 +0100
X-Google-Sender-Auth: NPafyf4qUA5fvlXLttwANN3UKSA
Message-ID: <CAKMK7uFG3tB4iQi8p4wdA8+g0P7uDxk4JwLMEXiG0fxx1qvrWw@mail.gmail.com>
Subject: Re: [RFC] dma-buf: Implement test module
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 1:37 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Thu, Dec 12, 2013 at 11:30:23PM +0100, Daniel Vetter wrote:
>> On Thu, Dec 12, 2013 at 8:34 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
>> > On 12/12/2013 03:36 PM, Thierry Reding wrote:
>> >>
>> >> This is a simple test module that can be used to allocate, export and
>> >> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
>> >> systems that lack a real second driver.
>> >>
>> >>
>> >
>> > Looks nice. I wonder whether this could be extended to create a "streaming"
>> > dma-buf from a user space mapping. That could be used as a generic way to
>> > implement streaming (user) buffer objects, rather than to add explicit
>> > support for those in, for example, TTM.
>>
>> Atm there's no way to get gpus to unbind their dma-buf mappings, so
>> their essentially pinned forever from first use on.
>
> Shouldn't this work by simply calling the GEM_CLOSE IOCTL on the handle
> returned by drmPrimeFDToHandle()? I mean that should drop the last
> reference on the GEM object and cause it to be cleaned up (which should
> include detaching the DMA-BUF).

Yeah, but that has the side-effect of also dropping the reference. And
requires an explicit action from userspace. The entire point of kernel
buffer managers is that this is all done transparently in the kernel
and when low on memory some objects get swapped out behind userspaces
back (and then pulled in again if needed).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
