Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbaHHBnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:43:11 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:36870 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435AbaHHBnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:43:10 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <f3a1af67003a45d05068c6a0dfa99031>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <53E42B1E.2080605@rock-chips.com>
Date: Fri, 08 Aug 2014 09:42:54 +0800
From: "Kever.Yang" <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "heiko@sntech.de" <heiko@sntech.de>, "olof@lixom.net" <olof@lixom.net>,
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
Subject: Re: [PATCH v4 2/4] usb: dwc2: add compatible data for rockchip soc
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com>	<1407404095-3265-3-git-send-email-kever.yang@rock-chips.com>	<A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com> <CAD=FV=UqeDWQiA7sAS6CuM74B0GS+5HcJD9Bd8FfF7awsdG7Vg@mail.gmail.com>
In-Reply-To: <CAD=FV=UqeDWQiA7sAS6CuM74B0GS+5HcJD9Bd8FfF7awsdG7Vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/08/2014 04:52 AM, Doug Anderson wrote:
> Paul,
>
> On Thu, Aug 7, 2014 at 11:26 AM, Paul Zimmerman
> <Paul.Zimmerman@synopsys.com> wrote:
>>> From: Kever Yang [mailto:kever.yang@gmail.com] On Behalf Of Kever Yang
>>> Sent: Thursday, August 07, 2014 2:35 AM
>>>
>>> This patch add compatible data for dwc2 controller found on
>>> rk3066, rk3188 and rk3288 processors from rockchip.
>>>
>>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>>> Acked-by: Paul Zimmerman <paulz@synopsys.com>
>>> ---
>>>
>>> Changes in v4:
>>> - max_transfer_size change to 65536, this should be enough
>>>    for most transfer, the hardware auto-detect will set this
>>>    to 0x7ffff which may make dma_alloc_coherent fail when
>>>    non-dword aligned buf from driver like usbnet happen.
>> Hi Kever,
>>
>> Did you test this change thoroughly? I have vague memories of any
>> value above 65535 causing problems, at least on my hardware. And I
>> see it is set to 65535 in both pci.c and platform.c. I could be
>> wrong, but I thought I should mention it.
> Certainly it is documented in the header file to have a max of 65535:
>
>   * @max_transfer_size:  The maximum transfer size supported, in bytes
>   *                       2047 to 65,535
>   *                      Actual maximum value is autodetected and also
>   *                      the default.
Sorry for didn't check the header file, I'll change it to 65535 and 
resubmit.
>
> ...but looking at the register definition that I see, the size can be
> up to 19 bits.  A 19-bit transfer far exceeds 65535.  Do you remember
> what the error was?  Certainly I can imagine there being errors with
> large calls to dma_alloc_coherent()...
>
> I know that with Kever's change I can do USB Ethernet downloads, so it
> is at least working to some degree.  ...to me it feels like Kever
> should resubmit with 65535 (to match the documentation) and then work
> in the background to figure out what the max_transfer_size really
> ought to be.
You are right.
> -Doug
>
>
>


