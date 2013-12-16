Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab3LPIwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:52:46 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42745 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab3LPIwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:52:44 -0500
Message-ID: <52AEBF36.9010400@ti.com>
Date: Mon, 16 Dec 2013 14:22:06 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, "balbi@ti.com" <balbi@ti.com>
CC: Belisko Marek <marek.belisko@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Subject: Re: [PATCH] omap: twl-common: Fix musb-hdrc device name.
References: <1386059589-4030-1-git-send-email-marek.belisko@open-nandra.com> <529D9D43.6040101@ti.com> <CAAfyv37Vie1vZK2XQ1cfVq6eVnSuaBLfykk6pU8fwEyqvPF4BA@mail.gmail.com> <CAAfyv35gVVNydrk8vifSyidpFjEXjGiT4-i2dgN5Un2=FuHaqQ@mail.gmail.com> <20131205184323.GF26766@atomide.com> <CAAfyv37e9+OLH-KegPCEhc0sbBS7UVnaSGU0mBw2AxAN9D7Akw@mail.gmail.com> <20131209175006.GD12527@atomide.com> <CAAfyv36P7DDcdaLWtXnZXPfQWPL20shE3kOHWtD0mSmH7aixdg@mail.gmail.com> <52AAF5E6.1050900@ti.com> <20131213173636.GG28184@atomide.com>
In-Reply-To: <20131213173636.GG28184@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 13 December 2013 11:06 PM, Tony Lindgren wrote:
> * Kishon Vijay Abraham I <kishon@ti.com> [131213 03:57]:
>> On Friday 13 December 2013 04:57 PM, Belisko Marek wrote:
>>> Kishon can you please comment on that? Would be possible to get your
>>> patch to 3.13 (I seen some comments from Felipe).
>>
>> I'm not sure as my patch modifies all the board files. There was initially some
>> confusion w.r.t when the board files will be dropped. But since board files
>> will still be there in 3.13, I'd recommend my patch  [1] to be taken. Anyways
>> if you have tested my patch (series), pls give your Tested-by.
>>
>> Tony, summary of the issue..
>> After the platform devices are created using PLATFORM_DEVID_AUTO, the
>> device names given in usb_bind_phy (in board file) does not match with
>> the actual device name causing the USB PHY library not to return the
>> PHY reference when the MUSB controller request for the PHY in the non-dt boot
>> case. So removed creating platform devices using PLATFORM_DEVID_AUTO in
>> omap2430.c. So had to make the corresponding changes in board files.
> 
> OK. Can you please repost with a proper commit id for what caused the
> regression and summararize why it should be fixed this way. Something like:
> 
> Commit abcd1234 (usb: blah foo bar) caused blah blah blah. Fix the issue
> with blah blah blah. Note that the board-*.c files will be removed soon,
> but for v3.13 we still support both legacy booting and device tree based
> booting and need to fix it.

huh.. I think we can have a much simpler fix. All this binding in board file
was introduced to support platforms that has multiple PHYs of the same type.
But musb/omap2430.c serves platforms that has only one PHY of a particular
type. We can just go back to usb_get_phy(enum usb_phy_type type) instead of
'usb_get_phy_dev' in omap2430.c. Felipe, what do you think?

Cheers
Kishon

> 
> Regards,
> 
> Tony
>  
>> [1] -> http://lists.scusting.com/index.php?t=msg&th=375579&start=0&S=Google

