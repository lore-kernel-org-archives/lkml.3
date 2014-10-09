Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbaJIAGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:06:16 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:38375 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJIAGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:06:04 -0400
Date: Wed, 8 Oct 2014 17:05:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
Message-ID: <20141009000555.GA27476@roeck-us.net>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008234541.GQ4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5435D16C.008D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 12:45:41AM +0100, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 03:59:12PM -0700, Guenter Roeck wrote:
> 
> > There is a log message "no parameters" for each regulator. This is printed
> > unconditionally from print_constraints().
> 
> > Looking through the code again, looks like this is on purpose. It is just a bit
> > annoying to get lots of those messages. One of the systems I am dealing with has
> > 17 LTC2978 chips in it, with 8 channels each. That results in 136 times "no
> > parameters" in the boot log. And that is not even a fully populated system;
> > if fully populated, there can be more than 60 of those chips. 500+ lines of 
> > similar log messages is really a bit on the high side.
> 
> > It might help if there was a way to silence the messages, ie to make
> > "print_constraints" optional. 
> 
> Ah, from the constraints rather than from the DT parsing.  I do like
> having it there since it's enormously helpful in debugging and that is
> a...  specialist number of regulators you have in your system.  We can

Yes, this is a pretty large backbone switch. Kind of amazing how many
sensors are in those systems.

> definitely at least add a boot argument or something to suppress them,
> let me have a think if we want to do that by default.

It is a nuisance, so I might just disable it in our tree if we don't
find some other solution.

Did you notice the problem with debugfs I had mentioned earlier ?
With all those regulators, not all of them being used, I end up with
many having the same name. This causes issues with debugfs, which is
trying to create the same file several times.

Any idea how we could solve this ? The constraints message is annoying,
but this one is a real issue.

Thanks,
Guenter
