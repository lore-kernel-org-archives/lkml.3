Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaHHAsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:48:16 -0400
Received: from smtpw.263xmail.com ([63.217.87.9]:38257 "EHLO
	smtpw.263xmail.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755330AbaHHAsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:48:13 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2014 20:48:12 EDT
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <ad73e23f143e91e1b408f4089484edb0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53E41C29.9070501@rock-chips.com>
Date: Fri, 08 Aug 2014 08:39:05 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "heiko@sntech.de" <heiko@sntech.de>
CC: "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
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
References: <1407404095-3265-1-git-send-email-kever.yang@rock-chips.com> <1407404095-3265-3-git-send-email-kever.yang@rock-chips.com> <A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C4DF6@US01WEMBX2.internal.synopsys.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On 08/08/2014 02:26 AM, Paul Zimmerman wrote:
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
>>    for most transfer, the hardware auto-detect will set this
>>    to 0x7ffff which may make dma_alloc_coherent fail when
>>    non-dword aligned buf from driver like usbnet happen.
> Hi Kever,
>
> Did you test this change thoroughly? I have vague memories of any
> value above 65535 causing problems, at least on my hardware. And I
> see it is set to 65535 in both pci.c and platform.c. I could be
> wrong, but I thought I should mention it.
I test it on rk3288 evb, it works find with 65536, I'm sorry for didn't 
mention it in my patch.
The problem in my platform is if the value use hardware auto-detect, it 
will be 0x7ffff,
and that will cause the dma_alloc_coherent fail in hcd driver.

The value less than 0x7ffff should be fine for hardware, but for the 
software, it depends on
how we use it.

What kind of problem did you met? Software problem or hardware problem? 
Maybe I should
pay more attention for this value. :)

>

