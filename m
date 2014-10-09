Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbaJIAZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 20:25:48 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:39720 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaJIAZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 20:25:39 -0400
Date: Wed, 8 Oct 2014 17:25:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, atull@opensource.altera.com
Subject: Re: [PATCH] regulator: of: Lower the severity of the error with no
 container
Message-ID: <20141009002531.GA27920@roeck-us.net>
References: <1412806199-5363-1-git-send-email-broonie@kernel.org>
 <20141008223403.GA24828@roeck-us.net>
 <20141008223601.GP4609@sirena.org.uk>
 <20141008225912.GA25134@roeck-us.net>
 <20141008234541.GQ4609@sirena.org.uk>
 <20141009000555.GA27476@roeck-us.net>
 <20141009001213.GS4609@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009001213.GS4609@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.5435D602.00CC,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Oct 09, 2014 at 01:12:13AM +0100, Mark Brown wrote:
> On Wed, Oct 08, 2014 at 05:05:55PM -0700, Guenter Roeck wrote:
> > On Thu, Oct 09, 2014 at 12:45:41AM +0100, Mark Brown wrote:
> 
> > > definitely at least add a boot argument or something to suppress them,
> > > let me have a think if we want to do that by default.
> 
> > It is a nuisance, so I might just disable it in our tree if we don't
> > find some other solution.
> 
> We'll do something, just a question of what and what the default is.
> 
Ok. Note that a boot parameter would not work well for our use case,
so it would be great if we can find something else.

> > Did you notice the problem with debugfs I had mentioned earlier ?
> > With all those regulators, not all of them being used, I end up with
> > many having the same name. This causes issues with debugfs, which is
> > trying to create the same file several times.
> 
> > Any idea how we could solve this ? The constraints message is annoying,
> > but this one is a real issue.
> 
> Shove a dev_name() on the front if we get a collision?  I have to say
> I've never cared, the debugfs isn't that important so it doesn't matter
> too much if it fails.

Sure, but, again, I am getting lots and lots of those error messages.
I probably would not care either (and probably not even have noticed)
if not for those messages.

Want me to submit a patch with the dev_name solution ?

Thanks,
Guenter
