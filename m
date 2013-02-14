Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3BNEmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 23:42:42 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:59822 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3BNEml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 23:42:41 -0500
Message-ID: <511C6B3F.3030206@wwwdotorg.org>
Date: Wed, 13 Feb 2013 21:42:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Simon Glass <sjg@chromium.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Yuvaraj Kumar <yuvaraj.cd@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, u.kleine-koenig@pengutronix.de,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Girish Shivananjappa <girish.shivananjappa@linaro.org>,
        "bhushan.r" <bhushan.r@samsung.com>,
        "sreekumar.c" <sreekumar.c@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>, Olof Johansson <olof@lixom.net>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Grant Grundler <grundler@chromium.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <wolfram@the-dreams.de>
Subject: Re: [PATCH v1 2/4] ARM: dts: Add i2c-arbitrator bus for exynos5250-snow
References: <1360778532-7480-1-git-send-email-dianders@chromium.org> <1360778532-7480-2-git-send-email-dianders@chromium.org> <511BFFD2.8090102@wwwdotorg.org> <CAD=FV=XLMYAyW7W3PtoUmROOgttuypHKNWtrcALw3t6jdyEDPw@mail.gmail.com>
In-Reply-To: <CAD=FV=XLMYAyW7W3PtoUmROOgttuypHKNWtrcALw3t6jdyEDPw@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 05:38 PM, Doug Anderson wrote:
> Stephen,
> 
> 
> On Wed, Feb 13, 2013 at 1:04 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 02/13/2013 11:02 AM, Doug Anderson wrote:
>>> We need to use the i2c-arbitrator to talk to any of the devices on i2c
>>> bus 4 on exynos5250-snow so that we don't confuse the embedded
>>> controller (EC).  Add the i2c-arbitrator to the device tree.  As we
>>> add future devices (keyboard, sbs, tps65090) we'll add them on top of
>>> this.
>>>
>>> The arbitrated bus is numbered 104 simply as a convenience to make it
>>> easier for people poking around to guess that it might have something
>>> to do with the physical bus 4.
>>>
>>> The addition is split between the cros5250-common and the snow device
>>> tree file since not all cros5250-class devices use arbitration.

>>> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
>>
>>> +     i2c-arbitrator {
>>> +             compatible = "i2c-arbitrator";
>>> +             #address-cells = <1>;
>>> +             #size-cells = <0>;
>>
>>> +             /* Use ID 104 as a hint that we're on physical bus 4 */
>>> +             i2c_104: i2c@0 {
>>
>> Does something use that hint? It sounds a little odd.
> 
> The i2c bus numbering patches will end up creating "/dev/i2c-104".

Oh sorry, I see this is just the alias doing it's job. I'd misread that
as the reg value being 104 and driving the bus ID.
