Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaGPTif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:38:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60974 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbaGPTic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:38:32 -0400
Message-ID: <53C6D4B6.3030506@codeaurora.org>
Date: Wed, 16 Jul 2014 12:38:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
References: <20140716032655.GB30412@kroah.com> <53C6C2C5.1050804@codeaurora.org> <20140716184409.GB10633@kroah.com>
In-Reply-To: <20140716184409.GB10633@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/14 11:44, Greg KH wrote:
> On Wed, Jul 16, 2014 at 11:21:57AM -0700, Stephen Boyd wrote:
>> On 07/15/14 20:26, Greg KH wrote:
>>
>>> Any reason why this hasn't been submitted upstream?  Or has it, and was
>>> it rejected?
>> I don't believe we ever submitted this upstream.
> Why not?

Sorry, I don't know. It's not upstreamed by me because there aren't any
use cases on the devices I have. I only mushed the changes together
because we were taking a look at the code we accumulated over the years.
Soon after I did that we swept through and deleted this driver from our
tree because it wasn't used by the platforms we're still supporting.

>
>>> Also, what userspace code uses this?  Is there some android-specific
>>> code somewhere that does a weird mix of sysfs and char control of the
>>> hardware?  And what type of SDIO devices are controlled with this?
>> If I recall correctly this driver is for communicating with an external
>> modem (in this case it was the Gobi 9k). We used the sdio interface to
>> do some IPC stuff with the modem over sdio, mainly because back then the
>> SoC didn't have an LTE capable modem, but the Gobi modem was LTE
>> capable. Slap the two chips together and you have an LTE phone while you
>> wait for us to deliver the first SoC with an integrated LTE modem (msm8960).
>>
>> The userspace component is the same proprietary software that's used to
>> make phone calls on android phones. I'd have to go dig around to find
>> that code and confirm if it's using sysfs and char control. I'd rather
>> not spend the time digging so let's assume it's doing that unless you
>> have a more specific question in mind?
> My specific question is why 2 different interfaces?

Ok. It definitely looks odd to support set/get of the VDD with sysfs and
ioctl interfaces. I'm just guessing, but I suspect it's a permissions
thing given that the patch that introduces the VDD stuff also updates
the permissions of the device node. Of course, the commit text only
mentions an ioctl, nothing about sysfs. The only other sysfs stuff seems
to be module parameters to change the vendor ids.

I'll have to go repo diving to figure out if the sysfs interface was
ever used. Maybe Alex or Konstantin can respond before I have to do that.

>
> Some people are looking at a way to do SDIO from userspace, if needed,
> and I was pointed at this driver, and wanted to figure out why it never
> was merged.  If it's useful, and people are using it in phones today,
> that's a good reason to merge it in, right?

Sure I imagine some phone somewhere is using it. Unfortunately I don't
have one and I don't know of anyone working on getting support for those
phones in the mainline kernel.

>
> So, any objection for me taking it as-is, as long as my audit of the
> code passes?

No objections here.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

