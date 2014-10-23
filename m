Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaJWQlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:41:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:58601 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJWQlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:41:05 -0400
Date: Thu, 23 Oct 2014 09:40:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org,
        Chris Healy <chealy@imsco-us.com>
Subject: Re: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM access
 functions
Message-ID: <20141023164052.GB21343@roeck-us.net>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
 <1414037002-25528-11-git-send-email-linux@roeck-us.net>
 <20141023135412.GC25190@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141023135412.GC25190@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.54492FA1.00FD,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 5
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

On Thu, Oct 23, 2014 at 03:54:12PM +0200, Andrew Lunn wrote:
> On Wed, Oct 22, 2014 at 09:03:18PM -0700, Guenter Roeck wrote:
> > MV88E6352 supports read and write access to its configuration eeprom.
> 
> Hi Guenter
> 
> I don't have the datasheet for the MV88E6352. Is the EEPROM built in,
> or external on an i2c bus?
> 
External.

> > +static int mv88e6352_get_eeprom_len(struct dsa_switch *ds)
> > +{
> > +	return 0x200;
> > +}
> 
> How do you handle the case of it being external and not populated.
> Would it not be better to try to detect it here, and return 0 if it
> does not exist?
> 
Makes sense, if it is detectable that it the EEPROM not there. Browsing
through the datasheet, I don't see how I could detect it; there does not
seem to be a status bit indicating if the EEPROM is there or not. There
are sw_mode pins which determine if the eeprom should be loaded after
reset or not, but I don't see anything in the register set which would
tell me.

Chris, do you know if there is a means to detect if the EEPROM is present
on the MV88E6352 ?

Thanks,
Guenter
