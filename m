Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3BGP3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:29:18 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59366 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab3BGP3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:29:16 -0500
Message-ID: <5113C833.90706@ti.com>
Date: Thu, 7 Feb 2013 17:28:51 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <linux@arm.linux.org.uk>,
        <sameo@linux.intel.com>, <balbi@ti.com>, <stern@rowland.harvard.edu>,
        <eballetbo@gmail.com>, <javier@dowhile0.org>, <sshtylyov@mvista.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Subject: Re: [PATCH v2 00/30] USB: omap-ehci: Move PHY management to PHY driver
References: <1359372631-8180-1-git-send-email-rogerq@ti.com> <5110ECF3.7010908@ti.com> <20130205165851.GA1081@kroah.com> <20130205171743.GG25185@atomide.com> <51122730.5030801@ti.com> <20130206171153.GY25185@atomide.com>
In-Reply-To: <20130206171153.GY25185@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 07:11 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130206 01:53]:
>> On 02/05/2013 07:17 PM, Tony Lindgren wrote:
>>> * Greg KH <gregkh@linuxfoundation.org> [130205 09:00]:
>>>> On Tue, Feb 05, 2013 at 01:28:51PM +0200, Roger Quadros wrote:
>>>>> Hi Tony & Greg,
>>>>>
>>>>> What's the best way to get these patches in?
>>>>>
>>>>> All patches have been acked by respective maintainers.
>>>>>
>>>>> If Tony can Ack the arch/arm/mach-omap2 stuff then should I send a
>>>>> pull request directly to Greg? or the other way round?
>>>>>
>>>>> Tony, 
>>>>> fyi, these patches should not interfere with the dw3c/musb stuff
>>>>> sent by Felipe & Kishon.
>>>>
>>>> I'm fine with Tony just taking them all if he wants to.
>>>
>>> OK. Roger, can you please do me a pull request with these
>>> against v3.8-rc6?
>>>
>>
>> Tony,
>>
>> Since this depends on [1] and [2] which are both in linux-next, should
>> I base it on linux-next?
> 
> Maybe you can base it on some commit in Greg's USB tree?
> Just check with Greg that whatever you use as a base is an
> immutable commit and OK to use as a base.
>  
>> Another option is to defer this to 3.10 merge window, along with the
>> DT adaptation for OMAP USB Host.
> 
> Once you have a branch ready that builds and boots, let's see how
> badly that conflicts with other branches we have queued up. If it's
> trivial only, then maybe Greg can pick up the patches. If not, we
> can still try to merge it in later on during the merge window as
> it would be nice to get USB to usable point with DT.
> 

Great! The DT patches are still under review.

I've based the $subject patches on Greg's usb-next branch.

Since dependent patches [1] went into linux-next through Samuel's MFD tree
and are not in Greg's usb-next, I've added them as well in my branch.
Not sure how this goes :P.

The $subject patches are since commit a0c750bb8b023ab92e27c670a1c9378d52dd2053:

  mfd: omap-usb-host: get rid of build warning (2013-02-07 16:37:41 +0200)

are available in the git repository at:
  git://github.com/rogerq/linux.git usb-next-usbhost16


The patches [1] are since commit 9662ced3527f5994e83957cf40765ed126abe97f:

  usb: gadget: imx_udc: make it depend on BROKEN (2013-02-06 11:43:39 -0800)

are available in the git repository at:
  git://github.com/rogerq/linux.git usb-next-usbhost16-part

cheers,
-roger

[1] [PATCH v9 00/20] OMAP USB Host cleanup
https://lkml.org/lkml/2013/1/23/155

