Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbbAIR5m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:57:42 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:44005 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941AbbAIR5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:57:38 -0500
Date: Fri, 9 Jan 2015 09:57:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCHv2] hwmon: (ina2xx) implement update_interval attribute
 for ina226
Message-ID: <20150109175734.GA30337@roeck-us.net>
References: <1420804980-11637-1-git-send-email-bgolaszewski@baylibre.com>
 <54AFE6E3.4050603@roeck-us.net>
 <CAMpxmJV7O_DqTx66N5t2dWc8JqpqFmvQS+figEOVm9P4DYoZNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMpxmJV7O_DqTx66N5t2dWc8JqpqFmvQS+figEOVm9P4DYoZNg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.50F85ECC.00DE,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
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

On Fri, Jan 09, 2015 at 03:45:27PM +0100, Bartosz Golaszewski wrote:
> 2015-01-09 15:34 GMT+01:00 Guenter Roeck <linux@roeck-us.net>:
> > Unfortunately that only applies to INA226 and not INA219, where the time is
> > static
> > (at least so far).
> 
> Oops, I must have missed this one.
> 
> > I think we'll need to store the time in ina2xx_data and use the old
> > (constant)
> > value for ina219. Maybe add another variable into the configuration data
> > for the initial value and copy it from there during probe.
> 
> I tried to avoid adding another variable used by ina226 only, but
> well. It's kind of dull that these chips are supported by a single
> driver - their configuration register layout is completely different.
> 
On the other side the data registers are the same. There is always some
trade-off.

Guenter
