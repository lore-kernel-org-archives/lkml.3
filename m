Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbaKSUpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:45:44 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:41008 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbaKSUpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:45:43 -0500
MIME-Version: 1.0
X-Originating-IP: [172.19.1.2]
In-Reply-To: <546CE366.1030405@collabora.co.uk>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
	<1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
	<20141118170001.6256c6df@lxorguk.ukuu.org.uk>
	<546CE366.1030405@collabora.co.uk>
Date: Wed, 19 Nov 2014 12:45:41 -0800
Message-ID: <CAOesGMhaSmjcyzNuCCN_avb_DNk130KuGu5ByjML4gL5aA8TwQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
From: Olof Johansson <olof@lixom.net>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 10:37 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Hello Alan,
>
> Thanks a lot for your feedback.
>
> On 11/18/2014 06:00 PM, One Thousand Gnomes wrote:
>>> +#ifdef CONFIG_COMPAT
>>> +struct compat_cros_ec_command {
>>> +    uint32_t version;
>>> +    uint32_t command;
>>> +    compat_uptr_t outdata;
>>> +    uint32_t outsize;
>>> +    compat_uptr_t indata;
>>> +    uint32_t insize;
>>> +    uint32_t result;
>>> +};
>>> +
>>> +struct compat_cros_ec_readmem {
>>> +    uint32_t offset;
>>> +    uint32_t bytes;
>>> +    compat_uptr_t buffer;
>>> +};
>>>
>>
>> This is a new API - arrange them to be 64bit safe and properly padded,
>> there is no excuse for needing compat crap except for legacy interfaces
>> you can't fix.
>>
>
> Is true that this is a new API for mainline but there is a lot of ChromeOS
> installations that depends on this API which means that just replacing the
> kernel with a mainline one there, will break existing user-space programs.

I think we can deal with that, at least if we pick new ioctl numbers
so we can tell from the userspace tool which interface is in use
during transition.

> But I understand that since those binaries were using a non-ustream kernel
> it is expected that the kernel API could be changed.
>
> I think it would be great to keep existing binaries working but if changing
> the API is required, then I can certainly do that when doing a re-spin.

I think there's some value in that, but i'm also somewhat embarrassed
to have missed this aspect when doing internal review, and do agree
with Alan. :) And we have only a few tools that use this interface so
we should be able to cope with it.


-Olof
