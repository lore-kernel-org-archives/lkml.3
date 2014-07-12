Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaGLXvu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 19:51:50 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37560 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbaGLXvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 19:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <1404999558.16296.31.camel@iivanov-dev>
References: <1404745893-6379-1-git-send-email-iivanov@mm-sol.com>
	<CACRpkdYcoA-nifxojO5tZUy6dL6P2PTSGW0mVLUfqG20rOg-Nw@mail.gmail.com>
	<1404904380.16296.17.camel@iivanov-dev>
	<CACRpkdb25foEcNroqLyZbX93FxqAZ7=2pGo6GPWP8YdrjUS8gg@mail.gmail.com>
	<CAJAp7Og0Cr3oY=XpT4NzKUWykxkRTq1ZRDyamW6tgohfBs3dmg@mail.gmail.com>
	<1404999558.16296.31.camel@iivanov-dev>
Date: Sat, 12 Jul 2014 16:51:47 -0700
Message-ID: <CAJAp7OgR7xc=LSf9tj+XQY1Nk=dQxCxTZ6HBEdf0NsriDZF85g@mail.gmail.com>
Subject: Re: [PATCH 0/4] New Qualcomm PMIC pin controller drivers
From: Bjorn Andersson <bjorn@kryo.se>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 6:39 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> On Wed, 2014-07-09 at 07:02 -0700, Bjorn Andersson wrote:
[..]
>> Correct Ivan; we do however share the same issues related to how to do
>> interrupt handling,
>
> Yep, but do we actually need to do interrupt handling in driver?
> Interrupts are handled by parent device. GPIO client drivers could
> use interrupt-controller registered by core driver?
>

Among other things we have the volume and camera keys hooked to these
pins, using the gpio-keys driver; so that needs to be able to convert
a gpio to an irq.
But I don't believe we should turn this driver into an
interrupt-controller; as that wouldn't add any value...

Regards,
Bjorn
