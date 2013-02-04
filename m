Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3BDLPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:15:12 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42892 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3BDLPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:15:05 -0500
MIME-Version: 1.0
In-Reply-To: <0b0001ce0002$12ecda90$38c68fb0$@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com>
	<1358257112-19595-3-git-send-email-gautam.vivek@samsung.com>
	<2542030.a14I18dBkO@flatron>
	<0b0001ce0002$12ecda90$38c68fb0$@samsung.com>
Date: Mon, 4 Feb 2013 16:45:03 +0530
Message-ID: <CAFp+6iEEtq=ncTb9pWQSMpvW2S-eRpSPBBYM2SnUmmvVaA=Zvg@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, jg1.han@samsung.com,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,


On Fri, Feb 1, 2013 at 3:56 AM, Kukjin Kim <kgene.kim@samsung.com> wrote:
> Tomasz Figa wrote:
>>
>> Hi Vivek,
>
> [...]
>
>> > +   usb@12120000 {
>> > +           compatible = "samsung,exynos4210-ohci";
>> > +           reg = <0x12120000 0x100>;
>> > +           interrupts = <0 71 0>;
>>
>> For Samsung platforms we decided per board enabling of nodes and so this
>> node should also contain:
>>
>>               status = "disabled";
>>
>> while in dts file of board using ohci there would be an overriding entry:
>>
>>       usb@12120000 {
>>               status = "okay";
>>       };
>>
>> I know that Exynos5250 has not been yet converted into this convention,
>> but using it when adding new devices will simplify the process.
>>
> Well, I have another opinion on this...
>
> Let's see, yeah, we are using following method in EXYNOS4 DT...
> - disabling IPs in SoC DT source and enabling IPs in board DT source
>
> But as I said, in EXYNOS5440 DT, I want to use following, because most of
> them should be enabled/used.
> - enabling IPs in SoC DT source and no need enabling in board DT source.
>
> I mean, it depends on each SoC's situation.
>

So, since USB 2.0 (EHCI/OHCI) shall be always enabled on almost all the boards,
so we shall keep it enabled in SOC DT source.

In that case following patches can be picked for a merge:
[PATCH v5 1/4] ARM: Exynos5250: Enabling ehci-s5p driver
http://www.mail-archive.com/linux-usb@vger.kernel.org/msg12330.html

[PATCH v4 2/4] ARM: Exynos5250: Enabling ohci-exynos driver
http://www.mail-archive.com/linux-usb@vger.kernel.org/msg12266.html

These will enable EHCI and OHCI support on exynos5250.
Please let me know if you want me to resend them. ;-)


-- 
Thanks & Regards
Vivek
