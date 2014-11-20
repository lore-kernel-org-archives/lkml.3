Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbaKTKDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:03:17 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60990 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849AbaKTKDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:03:14 -0500
Message-ID: <546DBC5B.803@collabora.co.uk>
Date: Thu, 20 Nov 2014 11:03:07 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device interface
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>	<1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>	<20141118170001.6256c6df@lxorguk.ukuu.org.uk>	<546CE366.1030405@collabora.co.uk> <CAOesGMhaSmjcyzNuCCN_avb_DNk130KuGu5ByjML4gL5aA8TwQ@mail.gmail.com>
In-Reply-To: <CAOesGMhaSmjcyzNuCCN_avb_DNk130KuGu5ByjML4gL5aA8TwQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Olof,

On 11/19/2014 09:45 PM, Olof Johansson wrote:
>> Is true that this is a new API for mainline but there is a lot of ChromeOS
>> installations that depends on this API which means that just replacing the
>> kernel with a mainline one there, will break existing user-space programs.
> 
> I think we can deal with that, at least if we pick new ioctl numbers
> so we can tell from the userspace tool which interface is in use
> during transition.
> 
>> But I understand that since those binaries were using a non-ustream kernel
>> it is expected that the kernel API could be changed.
>>
>> I think it would be great to keep existing binaries working but if changing
>> the API is required, then I can certainly do that when doing a re-spin.
> 
> I think there's some value in that, but i'm also somewhat embarrassed
> to have missed this aspect when doing internal review, and do agree
> with Alan. :) And we have only a few tools that use this interface so
> we should be able to cope with it.
> 
>

Thanks a lot for your feedback. I'll follow Alan suggestion then and make
the structs to be 64-bit safe and properly padded. Also, I'll follow your
suggestion and use a different magic number for the IOCTLs so user-space
programs can be backward compatible if needed.
 
> -Olof
> 

Best regards,
Javier
