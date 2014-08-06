Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbaHFWNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:13:38 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:34519 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaHFWNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:13:36 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844C44CF@US01WEMBX2.internal.synopsys.com>
References: <1407159942-7063-1-git-send-email-kever.yang@rock-chips.com>
	<1407159942-7063-3-git-send-email-kever.yang@rock-chips.com>
	<CAD=FV=WO5TxzWEv3XwO7T6_F6ynyi0P0yF+Y=LD495dEOyWw_w@mail.gmail.com>
	<53E0373C.5090309@rock-chips.com>
	<A2CA0424C0A6F04399FB9E1CD98E0304844C44CF@US01WEMBX2.internal.synopsys.com>
Date: Wed, 6 Aug 2014 15:13:35 -0700
X-Google-Sender-Auth: lvP7GCpG10l3dHzZYDYPgG1Cbo4
Message-ID: <CAD=FV=XBnVy+c-VFSC0MdExqGsDSMO9LXBAFgwPn+toWBcxe5w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] usb: dwc2: add 'mode' which based on Kconfig
 select or dts setting
From: Doug Anderson <dianders@chromium.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: Kever Yang <kever.yang@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, wulf <wulf@rock-chips.com>,
        lyz <lyz@rock-chips.com>, Jingoo Han <jg1.han@samsung.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, Aug 5, 2014 at 1:08 PM, Paul Zimmerman
<Paul.Zimmerman@synopsys.com> wrote:
>> Maybe dwc2 is refer to the Kconfig in dwc3 for there is a choice from
>> one of "Host only mode", "Gadget only mode" and "Dual Role mode",
>> which means the role is decided by the Kconfig.
>>
>> In my opinion, there maybe more than one controller in a Soc, and for
>> different
>> usage, the mode select should not be done in Kconfig, it's better to do that
>> in dts file.
>> I agree with you that the CONFIG_USB_DWC2_HOST should defined for host
>> functionality, not for role definition.
>>
>> Paul: what do you think?
>
> I'm confused about how your dual-role mode implementation is supposed
> to work. Right now, the host and peripheral modes are compiled as
> separate drivers, and there is no dual-role mode in the Kconfig. So I
> don't see how your code can work. Have you tested it?

Ah, interesting.  I just assumed that since you could compile both in
that dual mode was there, but I clearly was confused.

I don't think Kever had tested dual_role mode.


> Dinh Nguyen is working on a patch series to add dual-role support, I
> think you have seen that, right? That adds the Kconfig options for all
> three modes. Maybe you should build on top of that?

I hadn't personally seen it, but now I have!  I guess this is the
newest <https://www.mail-archive.com/linux-usb@vger.kernel.org/msg46103.html>.

I haven't done a thorough review, but I think Kever's patch v4
<https://patchwork.kernel.org/patch/4682711/> is still relevant since
I don't see anything parsing the dr_mode in Dinh's patches.

-Doug
