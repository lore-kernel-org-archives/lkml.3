Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab3LLWa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 17:30:26 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42984 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3LLWaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 17:30:24 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <52AA0FC4.3090606@vmware.com>
References: <1386858989-1487-1-git-send-email-treding@nvidia.com>
	<52AA0FC4.3090606@vmware.com>
Date: Thu, 12 Dec 2013 23:30:23 +0100
X-Google-Sender-Auth: a9iju-CSC5hBCrhzMVWb7Vqhe8w
Message-ID: <CAKMK7uGOt2CYCgyE5rnXE3wJJjJiRpoQMB_-+_+m_qhk3TH8QQ@mail.gmail.com>
Subject: Re: [RFC] dma-buf: Implement test module
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 8:34 PM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> On 12/12/2013 03:36 PM, Thierry Reding wrote:
>>
>> This is a simple test module that can be used to allocate, export and
>> delete DMA-BUF objects. It can be used to test DMA-BUF sharing in
>> systems that lack a real second driver.
>>
>>
>
> Looks nice. I wonder whether this could be extended to create a "streaming"
> dma-buf from a user space mapping. That could be used as a generic way to
> implement streaming (user) buffer objects, rather than to add explicit
> support for those in, for example, TTM.

Atm there's no way to get gpus to unbind their dma-buf mappings, so
their essentially pinned forever from first use on. Userptr won't
really make this worse, but imo we should fix this first before
expanding the use-cases too much. And getting dma-bufs to integrate
better into existing memory mangers like ttm will be a lot of pain.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
