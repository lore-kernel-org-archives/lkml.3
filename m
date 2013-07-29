Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396Ab3G2Rcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:32:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45155 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab3G2Rcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:32:52 -0400
Message-ID: <51F6A741.6070300@wwwdotorg.org>
Date: Mon, 29 Jul 2013 11:32:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Hanumant Singh <hanumant@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "Bird, Tim" <Tim.Bird@sonymobile.com>,
        ext Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
In-Reply-To: <CACRpkdZLFD-KAvZdUUvQKje3vAH1D0EJMW9PSK8VSp3Xs4eiGA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 10:37 AM, Linus Walleij wrote:
> On Wed, Jul 24, 2013 at 11:41 PM, Hanumant Singh
> <hanumant@codeaurora.org> wrote:
> 
>> Add a new device tree enabled pinctrl driver for
>> Qualcomm MSM SoC's. This driver provides an extensible
>> framework to interface all MSM's that use a TLMM pinmux,
>> with the pinctrl subsytem.
>>
>> This driver is split into two parts: the pinctrl interface
>> and the TLMM version specific implementation. The pinctrl
>> interface parses the device tree and registers with the pinctrl
>> subsytem. The TLMM version specific implementation supports
>> pin configuration/register programming for the different
>> pin types present on a given TLMM pinmux version.
>>
>> Add support only for TLMM version 3 pinmux right now,
>> as well as, only two of the different pin types present on the
>> TLMM v3 pinmux.
>> Pintype 1: General purpose pins.
>> Pintype 2: SDC pins.
> 
> I guess this is the v4 patch set?
> 
> Please include a small changelog so I can keep track of
> things...
> 
> 
>> Change-Id: I065d874cd2c6fd002d5b3cb4b355445bb6912bf4
> 
> This thing is not interesting to the kernel community.
> 
>> diff --git a/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
>> new file mode 100644
>> index 0000000..0f17a94
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/msm-pinctrl.txt
> 
> This needs to be broken out and sent for separate review on
> the devicetree@vger.kernel.org mailing list.

It certainly should be reviewed there, although I don't think the
binding .txt file needs to be a separate patch. At present, it's quite
typical to include the binding doc with the first driver that implements
it, although that may change in the future; we'll see.
