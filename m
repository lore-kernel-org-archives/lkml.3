Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757AbaLVWED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:04:03 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38039 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbaLVWEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:04:01 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1412221553230.32109-100000@netrider.rowland.org>
References: <CAD=FV=UWOOwr3K6vPbAiHTUuv1DdbVRQ1yKKWWS6KOv6J4B51w@mail.gmail.com>
	<Pine.LNX.4.44L0.1412221553230.32109-100000@netrider.rowland.org>
Date: Mon, 22 Dec 2014 14:03:59 -0800
Message-ID: <CAD=FV=XzL7gEEHc6TN3nLSiscag9mUFbRZLsi48c5JZQ4D+Qig@mail.gmail.com>
Subject: Re: [PATCH 2/2] USB: ehci-platform: Support ehci reset after resume quirk
From: Doug Anderson <dianders@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wu Liang feng <wulf@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        Eddie Cai <eddie.cai@rock-chips.com>, Roy Li <roy.li@rock-chips.com>,
        Chris <zyw@rock-chips.com>, Julius Werner <jwerner@google.com>,
        Pawel Osciak <posciak@google.com>, Tomasz Figa <tfiga@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 22, 2014 at 1:04 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 22 Dec 2014, Doug Anderson wrote:
>
>> Alan,
>>
>> On Mon, Dec 22, 2014 at 8:06 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Mon, 22 Dec 2014, Wu Liang feng wrote:
>> >
>> >> The EHCI controller doesn't properly detect the case when
>> >
>> > "The" EHCI controller?  I don't know what EHCI controller you're
>> > talking about, but my controllers don't have any trouble detecting
>> > device removal during suspend.
>>
>> This is specifically the EHCI controller on rk3288.  Not sure why Wu
>> Liang feng removed that part of the description.
>
> Maybe it could be put back in.

Sounds good.  Wu Liang feng, could you spin and make sure you say that
this is the EHCI controller in rk3288?  Make sure to keep tags that
were added (Acked, Reviewed, Tested).


>> On rk3288-pinky I have tested that without this patch the EHCI
>> controller flips out when a USB webcam is plugged into the port and is
>> power cycled across suspend/resume.  With this patch the controller
>> properly unplugs / replugs the webcam.
>>
>> Tested-by: Doug Anderson <dianders@chromium.org>
>
> I assume you also tested the case where the webcam is _not_
> power-cycled during the suspend.

Good point.  I was about 99% sure I tested that case, but I just
retested now and now I'm 100% sure.  ;)

-Doug
