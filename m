Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab3CMR7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 13:59:41 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:49657 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057Ab3CMR7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 13:59:39 -0400
MIME-Version: 1.0
In-Reply-To: <A763CC55-549D-4CCD-8EE8-2BCE17F84606@suse.de>
References: <1363136988-3704-1-git-send-email-agraf@suse.de>
	<CAD=FV=UXaZvZJOZwAguwi=iyYO1iMSvt8fdEsDhr96pgMXDYSg@mail.gmail.com>
	<A763CC55-549D-4CCD-8EE8-2BCE17F84606@suse.de>
Date: Wed, 13 Mar 2013 10:59:37 -0700
X-Google-Sender-Auth: zN4QX7pv_T-dTNRT1xndrf9uWj0
Message-ID: <CAD=FV=W331nkdJJhXrXe739o+-iBSzGAS6anu+C_mmix0MbAUg@mail.gmail.com>
Subject: Re: [PATCH] USB: ehci-s5p: Fix phy reset
From: Doug Anderson <dianders@chromium.org>
To: Alexander Graf <agraf@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Wed, Mar 13, 2013 at 10:45 AM, Alexander Graf <agraf@suse.de> wrote:
>
>>> +       gpio_free(gpio);
>>
>> Freeing the gpio is a little on the iffy side since you actually care
>> about keeping the value.  Perhaps you can change this to
>> devm_gpio_request_one() and avoid the free?  I was about to submit a
>> patch to do just that (since otherwise you run into trouble if you
>> ever defer the probe) but then ran across your patch.
>
> I could also just return it when the function exits and only free it when we exit the probe function with a negative value. The reason I put it in here was that on probe deferral, the pin simply gets blocked.
>
> However, I could probably also just completely take the gpio_free() out of this patch and resubmit, as it should be pretty much unrelated. Then you can patch it properly.

Sure, if you want to resubmit without the gpio_free() I'll submit a
new patch atop yours with the change to devm and people can see if
they like it...
