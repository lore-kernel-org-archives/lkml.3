Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936AbaGPSWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:22:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55107 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934769AbaGPSV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:21:58 -0400
Message-ID: <53C6C2C5.1050804@codeaurora.org>
Date: Wed, 16 Jul 2014 11:21:57 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
References: <20140716032655.GB30412@kroah.com>
In-Reply-To: <20140716032655.GB30412@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 20:26, Greg KH wrote:
> Hi Stephen.
>
> I had some people ask me about a sdio userspace interface, and ran
> across the chdio.c file as found in the MSM android kernel trees:

You mean csdio.c right?

>
> https://android.googlesource.com/kernel/msm/+/57b74303d6f033ab04be039379f6661337fb9279

As you can see in the commit text there, the commit I authored is
actually a squash of three patches from some previous android kernel
that we did (looks like it was android-msm-2.6.35) and it's been almost
4 years since those patches were written. The three original commits
weren't authored by me so I really don't know the intimate details of
this driver.

>
> Any reason why this hasn't been submitted upstream?  Or has it, and was
> it rejected?

I don't believe we ever submitted this upstream.

>
> Also, what userspace code uses this?  Is there some android-specific
> code somewhere that does a weird mix of sysfs and char control of the
> hardware?  And what type of SDIO devices are controlled with this?

If I recall correctly this driver is for communicating with an external
modem (in this case it was the Gobi 9k). We used the sdio interface to
do some IPC stuff with the modem over sdio, mainly because back then the
SoC didn't have an LTE capable modem, but the Gobi modem was LTE
capable. Slap the two chips together and you have an LTE phone while you
wait for us to deliver the first SoC with an integrated LTE modem (msm8960).

The userspace component is the same proprietary software that's used to
make phone calls on android phones. I'd have to go dig around to find
that code and confirm if it's using sysfs and char control. I'd rather
not spend the time digging so let's assume it's doing that unless you
have a more specific question in mind?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

