Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3CNSkV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:40:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:36689 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab3CNSkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:40:19 -0400
Message-ID: <514219A5.9080305@windriver.com>
Date: Thu, 14 Mar 2013 14:40:37 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] usb: limit OMAP related USB options to OMAP2PLUS platforms
References: <1361992119-2465-1-git-send-email-paul.gortmaker@windriver.com> <20130227195046.GA2300@arwen.pp.htv.fi> <512E653F.1090706@windriver.com> <5141EA01.3060905@windriver.com> <20130314161204.GE3001@arwen.pp.htv.fi>
In-Reply-To: <20130314161204.GE3001@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-03-14 12:12 PM, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Mar 14, 2013 at 11:17:21AM -0400, Paul Gortmaker wrote:
>>>>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>>>>> index 65217a5..40b8463 100644
>>>>> --- a/drivers/usb/phy/Kconfig
>>>>> +++ b/drivers/usb/phy/Kconfig
>>>>> @@ -17,6 +17,7 @@ config OMAP_USB2
>>>>>  
>>>>>  config OMAP_USB3
>>>>>  	tristate "OMAP USB3 PHY Driver"
>>>>> +	depends on ARCH_OMAP2PLUS
>>>>>  	select USB_OTG_UTILS
>>>>>  	select OMAP_CONTROL_USB
>>>>>  	help
>>>>> @@ -27,6 +28,7 @@ config OMAP_USB3
>>>>>  
>>>>>  config OMAP_CONTROL_USB
>>>>>  	tristate "OMAP CONTROL USB Driver"
>>>>> +	depends on ARCH_OMAP2PLUS
>>>>
>>>> I rather not add dependencies here and fix the selections of
>>>> OMAP_CONTROL_USB.
>>>
>>> I am not sure I understand what you mean, or why you wouldn't
>>> want sane dependencies in place like those given above.  Perhaps
>>> you can send an alternate patch so there is no ambiguity?
>>
>> Hi Felipe,
>>
>> I'm still seeing the OMAP settings in x86 builds on mainline
>> from today, and since I'd not got a reply to the above, I'm
>> still wondering what alternative you have in mind vs. my
>> above patch.  We can't be having the arch specific settings
>> leaking out to the other arch where they make no sense[1].
> 
> why not ? It forces people to write portable drivers, it forces people
> to avoid including the wrong headers and allows maintainers and patch
> authors to easily compile test their drivers.

Why not?  That was covered in the link I'd referenced.  What you
list above is a very developer centric point of view.  To quote
Andrew Morton from that same link, in regards to dependencies
and how they should be used:

"...offering useless stuff to non-kernel-developers has downsides
with no balancing benefit, and we really should optimise things for
our users because there are so many more of them than there are of us."

Look at what you've written.  The key word above and below in your
text is "force people".  Showing no interest in simplifying things for
our users and taking that approach is a good way to alienate our user
base.

Paul.
--

> 
> On top of all that, it lets me better use linux-next as a big build
> testing before I send a pull request to Greg.
> 
> When you're going to build a product, you will come up with a proper
> .config anyway. Because of a bunch of these misused 'depends on' and
> 'select' statements that right now ARM multiplatform builds don't even
> compile cleanly if you enable all ARM-related drivers.
> 
> Until all of those are cleaned up, the best way is to force people to
> write drivers which compile in all architectures and make sure Kconfig
> doesn't add any ARCH dependency.
> 
