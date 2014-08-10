Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaHJCGM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 22:06:12 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60537 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbaHJCGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 22:06:08 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140810112127.60b195b7@canb.auug.org.au>
References: <20140808213457.511493898@linuxfoundation.org>
	<53E57279.1030106@roeck-us.net>
	<20140809034911.GA2348@kroah.com>
	<20140809034950.GB2348@kroah.com>
	<53E5A0D1.10507@roeck-us.net>
	<20140809141609.GA21639@kroah.com>
	<53E63871.5040504@roeck-us.net>
	<CA+55aFwFMFgj2PqftqZLntjYkbm+pG8adJPMO+sD9=U67WOYkg@mail.gmail.com>
	<53E65747.9070108@roeck-us.net>
	<CA+55aFw=1YEfa+J5xLMbSycT4YBvEmgbDGN62nD1AL9-q1NPoA@mail.gmail.com>
	<20140810112127.60b195b7@canb.auug.org.au>
Date: Sat, 9 Aug 2014 19:06:07 -0700
Message-ID: <CAOesGMhmcM6JeAhYVW5MzDY5NuN6F-TeZNT2-Y11c=L3J_D7oQ@mail.gmail.com>
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
From: Olof Johansson <olof@lixom.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        YoungJun Cho <yj44.cho@samsung.com>, Inki Dae <inki.dae@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        satoru takeuchi <satoru.takeuchi@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 6:21 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
>
> On Sat, 9 Aug 2014 10:43:51 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> On Sat, Aug 9, 2014 at 10:15 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> >
>> > ERROR (phandle_references): Reference to non-existent node or label
>> > "disp_pd"
>> >
>> > ERROR: Input tree has errors, aborting (use -f to force output)
>> > make[1]: *** [arch/arm/boot/dts/exynos5420-arndale-octa.dtb] Error 2
>>
>> Ok, so it's something else that was apparently known about in -next,
>> but not mentioned when pushing to me. Oh well.

Yeah, I had missed this one since I thought the DRM guys would fix it
in their tree when it was reported.

It didn't show up for me since when I did my build/test before sending
pull requests since that was done with a mainline branch that hadn't
merged DRM yet.

>> The new disp_dt use was added by commit 5a8da524049c ("ARM: dts:
>> exynos5420: add dsi node"), while commit d51cad7df871 ("ARM: dts:
>> remove display power domain for exynos5420") removed the node.
>>
>> I'll leave it broken until the ARM people get around to fixing it.
>> Likely by just removing the disp_dt line from the dsi node, but I'll
>> let the proper people sort it out.
>
> Yeah, that's the correct fix (it was even tested).  Olof has the patch
> for you.

Yep, I've got the patch to do that in my current fixes branch that
I'll send tonight.


-Olof
