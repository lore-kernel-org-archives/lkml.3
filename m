Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbaFBRPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:15:43 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59180 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983AbaFBRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAFp+6iFbDfWconRZzMhSXFG_RbXF-rnYwraJK1P1tQSb6R+Dkw@mail.gmail.com>
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
	<536BA9E8.2030306@suse.de>
	<536BAD05.9070401@samsung.com>
	<CAODwPW8FpsF6vo5Z8_+YXwchwab=7Ltv0nEvP_=907HK232xCg@mail.gmail.com>
	<CAFp+6iFbDfWconRZzMhSXFG_RbXF-rnYwraJK1P1tQSb6R+Dkw@mail.gmail.com>
Date: Mon, 2 Jun 2014 10:15:36 -0700
X-Google-Sender-Auth: LiQfL81NmQgB-DSffi4SDDRtD7Y
Message-ID: <CAODwPW9Qkem9OGjVn+EkxvWa5SKWBn=9oG+rvLv9tZVJ=UWx4A@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
From: Julius Werner <jwerner@chromium.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Julius Werner <jwerner@chromium.org>, Tomasz Figa <t.figa@samsung.com>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Arun Kumar <arunkk.samsung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok, there was already a patch posted by you for this[1], which had
> quite a much discussion
> on it.
> Would you like to give some pointers based on that ?
> One that Olof had suggested was to use gpio-reset driver which is yet
> to make to mainline.
> But i think with that too we need to take care of the timing for
> resetting the hub before PHY
> gets reset.

Oh, right, I remember now. Seems like there wasn't much consensus on
how to solve the problem there, and I think I didn't really have time
to work on it any more either.

I think coupling in another driver to reset the device isn't a bad
idea... this could even be usb3503 if you modified it a little, and it
could also address Tomasz' concerns from that thread that the solution
should be extensible to other HSIC devices that need a different reset
sequence. But you need some mechanism to hook the two drivers together
and make sure phy-samsung-usb2 synchronously calls the reset function
at exactly the right point to ensure the timing works right.
