Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3LSRk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:40:28 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:41878 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528Ab3LSRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:40:27 -0500
Date: Thu, 19 Dec 2013 18:40:24 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: arno@natisbad.org (Arnaud Ebalard)
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Huewe <peter.huewe@infineon.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Guenter Roeck <linux@roeck-us.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Can someone Ack and queue a patch for RTC subsytem?
Message-ID: <20131219184024.2a649328@linux.lan.towertech.it>
In-Reply-To: <87d2kslphr.fsf@natisbad.org>
References: <87siton6ke.fsf@natisbad.org>
	<20131219173857.0a546b99@linux.lan.towertech.it>
	<87d2kslphr.fsf@natisbad.org>
Organization: Tower Technologies
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 18:28:16 +0100
arno@natisbad.org (Arnaud Ebalard) wrote:

> >  Yes, Andrew usually pick those.   
>
> I guess he should be put in the MAINTAINERS file then. Otherwise,
> get_maintainer.pl script can not do its job correctly and people
> end up thinking you should be the one handling those.

 That makes sense, I'll leave the decision add his email to Andrew. 


> > I do not maintain a separate tree due to most RTCs being specifit to a
> > subsytem.   
> 
> I do not understand: the chip is generic, i.e. this is not a RTC chip
> specific to a given SoC (like rtc-mv.c is for instance). Can you be
> more specific?

 Yes, this chip is generic, but most aren't. Some of those who
 are generic, are strictly connected to a particular system/board, 
 and they end up in that system's tree. Most of the drivers
 are pretty small.
 

> >  Regarding your patch, please do not add entries to /proc.
> >  Use sysfs if you need.  
> 
> Well, this is what is currently described in the documentation
> (Documentation/rtc.txt), in drivers/rtc/rtc-test.c driver and what
> many drivers do (AFAICT, 22/125).

 This needs to be fixed as well. Documentation.txt does not suggest
 to add arbitrary values to the procfs. "many do" does not apply.


> Additionally, I only provide some additional info for an existing
> file: the /proc entry is created by the drivers/rtc/class.c as
> soon as someone selects CONFIG_RTC_INTF_PROC.

 I know, but that makes the procfs entry a mess. sysfs is the way,


> Do you want me to send a v7 w/ the .proc helper removed or leave
> things as they are and Ack the patch as is?

 Unless absolutely needed, I'd prefer if you can remove them
 or move to sysfs.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

