Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927AbaGPSji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:39:38 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34052 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934834AbaGPSjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:39:37 -0400
X-Sasl-enc: jZI+ADXTcLqSE+alAIhTj4NkeWlSyUyimIRjD2BfGSnc 1405535975
Date: Wed, 16 Jul 2014 11:44:09 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
Message-ID: <20140716184409.GB10633@kroah.com>
References: <20140716032655.GB30412@kroah.com>
 <53C6C2C5.1050804@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C6C2C5.1050804@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 11:21:57AM -0700, Stephen Boyd wrote:
> On 07/15/14 20:26, Greg KH wrote:
> > Hi Stephen.
> >
> > I had some people ask me about a sdio userspace interface, and ran
> > across the chdio.c file as found in the MSM android kernel trees:
> 
> You mean csdio.c right?

Ick, yes, sorry about that.

> >
> > https://android.googlesource.com/kernel/msm/+/57b74303d6f033ab04be039379f6661337fb9279
> 
> As you can see in the commit text there, the commit I authored is
> actually a squash of three patches from some previous android kernel
> that we did (looks like it was android-msm-2.6.35) and it's been almost
> 4 years since those patches were written. The three original commits
> weren't authored by me so I really don't know the intimate details of
> this driver.

Yes, I know you didn't write this version, but you did the "mushing
together", which was nice of you, and presumably you did it for a good
reason :)

> > Any reason why this hasn't been submitted upstream?  Or has it, and was
> > it rejected?
> 
> I don't believe we ever submitted this upstream.

Why not?

> > Also, what userspace code uses this?  Is there some android-specific
> > code somewhere that does a weird mix of sysfs and char control of the
> > hardware?  And what type of SDIO devices are controlled with this?
> 
> If I recall correctly this driver is for communicating with an external
> modem (in this case it was the Gobi 9k). We used the sdio interface to
> do some IPC stuff with the modem over sdio, mainly because back then the
> SoC didn't have an LTE capable modem, but the Gobi modem was LTE
> capable. Slap the two chips together and you have an LTE phone while you
> wait for us to deliver the first SoC with an integrated LTE modem (msm8960).
> 
> The userspace component is the same proprietary software that's used to
> make phone calls on android phones. I'd have to go dig around to find
> that code and confirm if it's using sysfs and char control. I'd rather
> not spend the time digging so let's assume it's doing that unless you
> have a more specific question in mind?

My specific question is why 2 different interfaces?

Some people are looking at a way to do SDIO from userspace, if needed,
and I was pointed at this driver, and wanted to figure out why it never
was merged.  If it's useful, and people are using it in phones today,
that's a good reason to merge it in, right?

So, any objection for me taking it as-is, as long as my audit of the
code passes?

thanks,

greg k-h
