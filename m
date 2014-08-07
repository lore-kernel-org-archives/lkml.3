Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbaHGUwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 16:52:38 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:51689 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaHGUwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 16:52:34 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>
	<1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
Date: Thu, 7 Aug 2014 13:52:33 -0700
X-Google-Sender-Auth: JMl_7LtdkH-zICbQZ_GIzY0Fi98
Message-ID: <CAD=FV=UqeDWQiA7sAS6CuM74B0GS+5HcJD9Bd8FfF7awsdG7Vg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
From: Doug Anderson <dianders@chromium.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>, "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Thu, Aug 7, 2014 at 11:26 AM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> From: Kever Yang [mailto:kever.yang@gmail.com] On Behalf Of Kever Yang
>> Sent: Thursday, August 07, 2014 2:35 AM
>>
>> This patch add compatible data for dwc2 controller found on
>> rk3066, rk3188 and rk3288 processors from rockchip.
>>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>> ---
>>
>> Changes in v4:
>> - max_transfer_size change to 65536, this should be enough
>>   for most transfer, the hardware auto-detect will set this
>>   to 0x7ffff which may make dma_alloc_coherent fail when
>>   non-dword aligned buf from driver like usbnet happen.
>
> Hi Kever,
>
> Did you test this change thoroughly? I have vague memories of any
> value above 65535 causing problems, at least on my hardware. And I
> see it is set to 65535 in both pci.c and platform.c. I could be
> wrong, but I thought I should mention it.

Certainly it is documented in the header file to have a max of 65535:

 * @max_transfer_size:  The maximum transfer size supported, in bytes
 *                       2047 to 65,535
 *                      Actual maximum value is autodetected and also
 *                      the default.

...but looking at the register definition that I see, the size can be
up to 19 bits.  A 19-bit transfer far exceeds 65535.  Do you remember
what the error was?  Certainly I can imagine there being errors with
large calls to dma_alloc_coherent()...

I know that with Kever's change I can do USB Ethernet downloads, so it
is at least working to some degree.  ...to me it feels like Kever
should resubmit with 65535 (to match the documentation) and then work
in the background to figure out what the max_transfer_size really
ought to be.

-Doug
