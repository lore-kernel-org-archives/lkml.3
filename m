Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaEGP3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:29:20 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:62740 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaEGP3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <20140507080650.GA28564@pengutronix.de>
References: <1399439776-18535-1-git-send-email-bjorn.andersson@sonymobile.com>
	<20140507080650.GA28564@pengutronix.de>
Date: Wed, 7 May 2014 08:29:17 -0700
Message-ID: <CAJAp7OiVrz+epys3Ko79GmMr6ahv8ii8XphVHE77NSM+wK2mOA@mail.gmail.com>
Subject: Re: [PATCH] ARM: zImage: Allow DTB to override broken ATAG_MEM
From: Bjorn Andersson <bjorn@kryo.se>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 1:06 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> On Tue, May 06, 2014 at 10:16:16PM -0700, Bjorn Andersson wrote:
>> Support overriding ATAG_MEM, by specifying non-zero content of the /memory/reg
>> property in the appended DTB. This is needed to work around bootloaders passing
>> broken tags.
> This feels wrong. I think it's quite usual that the device tree
> specifies a non-0 /memory/reg property. I checked four more or less
> random dts files[1], and three of them have this property set with
> actual values.

I thought u-boot did something like this, but after checking the code
it seems that I
was wrong.

But if that's not the case then you're right; we have to continue to
be bug-compatible
with all those dtbs out there.

>
> So I wouldn't be surprised if this patch results in more damage than
> it's worth. The optimal fix would be to make the bootloader do the right
> thing. And if you trust your dtb more than your bootloader, disable
> ARM_ATAG_DTB_COMPAT.

I unfortunately have a boot loader passing information in ATAG_CMDLINE that I
need, so I can't disable ARM_ATAG_DTB_COMPAT.


My problem is that the boot loader on every shipped Qualcomm MSM8x60, MSM8960
and APQ8064 based device passes ATAG_MEM with the incorrect start address. There
is no way to update the boot loader for these.

For development I have a .init_meminfo in my board file patching the
meminfo; this looks
really bad so I'm hoping we can find some alternative solution.

The proposed solution from some of the people working on this is to
(post build) patch the
zImage to inject code that corrects the ATAG_MEM before jumping to the
kernel; but I am
hoping we can find some sane way instead...

Regards,
Bjorn
