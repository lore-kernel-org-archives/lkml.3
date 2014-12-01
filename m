Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425AbaLAURJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:17:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45969 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaLAURF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:17:05 -0500
Date: Mon, 1 Dec 2014 12:15:36 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i8k: Rework error retries
Message-ID: <20141201201536.GA28914@roeck-us.net>
References: <1417381240-7641-1-git-send-email-linux@roeck-us.net>
 <1417381240-7641-2-git-send-email-linux@roeck-us.net>
 <201412012045.59404@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201412012045.59404@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.547CCCC0.0238,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
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

On Mon, Dec 01, 2014 at 08:45:59PM +0100, Pali Rohár wrote:
> On Sunday 30 November 2014 22:00:39 Guenter Roeck wrote:
> > Instead of returning a previous value if the SMM code returns
> > an error when trying to read a temperature, retry once.
> > If that fails again, return -ENODATA. Also return -ENODATA if
> > an attempt is made to read the GPU temperature but the GPU is
> > currently turned off.
> > 
> > Drop the I8K_TEMPERATURE_BUG definition and handle the related
> > bug unconditionally.
> > 
> > Cc: Pali Rohár <pali.rohar@gmail.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > Applies on top of Pali's patch series.
> > 
> >  drivers/char/i8k.c | 47
> > ++++++++++++++++++++++++----------------------- 1 file
> > changed, 24 insertions(+), 23 deletions(-)
> > 
> 
> Working fine GPU temp (turned on or off).
> 
> Tested-by: Pali Rohár <pali.rohar@gmail.com>
> 
Thanks a lot for testing!

Guenter
