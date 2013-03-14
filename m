Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3CNPbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:31:25 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:56021 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3CNPbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuYYwQgXx67rSNeBFBJQfkbaf17vP6XXhFZ2Zc5hRqxshUFbw@mail.gmail.com>
References: <1363219179-14900-1-git-send-email-agraf@suse.de>
	<CAJuYYwRYp0dvf=veg1UVAj8rJ2CdpFy32LUE6zeq1sH9FbZ=KQ@mail.gmail.com>
	<6F88F86A-8C8E-4C2E-BD15-14C788FC6E48@suse.de>
	<CAJuYYwQgXx67rSNeBFBJQfkbaf17vP6XXhFZ2Zc5hRqxshUFbw@mail.gmail.com>
Date: Thu, 14 Mar 2013 08:31:20 -0700
X-Google-Sender-Auth: 8HfgGVaemzGgNmJqe-fnhK8RwI4
Message-ID: <CAD=FV=Veidj_1MdPLEUCfMy7gEVGszdkJv_oMPVF8yQTQUbJ=A@mail.gmail.com>
Subject: Re: [PATCH v2] USB: ehci-s5p: Fix phy reset
From: Doug Anderson <dianders@chromium.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Alexander Graf <agraf@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dmueller@suse.de, Vivek Gautam <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>, jwerner@chromium.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 14, 2013 at 7:58 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
>> I can see your point, but as I mentioned earlier there seems to be some timing issue here. By simply doing the reset a few ms earlier (in the first probe, before the driver detects that it needs to defer probing), I already can't find the hub on the bus later.
>>
>> So I'm assuming that the same thing would also happen if I put it even earlier in machine init.
>
> True, I missed that point. The usb hub connected over hsic interface,
> after power-on-reset, might have initiated the 'connect' state on
> seeing the idle condition on the bus and since the host/phy controller
> is not ready yet, the connect might have failed.
>
> So the correct sequence would be, after the usb host controller and
> the phy controllers are initialized, the 'reset' pin on the on-board
> usb hub should be asserted. Upon releasing that reset, the usb hub
> would initiate the 'connect' state on the HSIC bus.

I think we ran into similar issues on one of our boards that had a hub
attached to the HSIC port.  We had to make our fix in a version of the
code that's nowhere near what landed upstream (so our change is not
relevant), but we're definitely interested in whatever solution you
come up with.  :)

-Doug
