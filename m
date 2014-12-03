Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaLCTPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:15:06 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56567 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaLCTPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:15:04 -0500
Date: Wed, 3 Dec 2014 11:14:46 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <jdelvare@suse.de>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH] i8k: Add support for temperature sensor labels
Message-ID: <20141203191446.GD9845@roeck-us.net>
References: <1417277047-15489-1-git-send-email-pali.rohar@gmail.com>
 <201411291849.44032@pali>
 <20141129175152.GA32510@kroah.com>
 <201411291904.07644@pali>
 <1417526599.15239.7.camel@chaos.site>
 <547DCC15.70300@roeck-us.net>
 <20141203100928.14d23c9f@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141203100928.14d23c9f@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.547F6136.01EC,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 6
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

On Wed, Dec 03, 2014 at 10:09:28AM +0100, Jean Delvare wrote:
> Hi Guenter,
> 
> On Tue, 02 Dec 2014 06:26:29 -0800, Guenter Roeck wrote:
> > On 12/02/2014 05:23 AM, Jean Delvare wrote:
> > > Ultimately /proc/i8k should be killed altogether and every function
> > > should use the appropriate standard interface. But I don't have any Dell
> > > laptop around so I won't go into that myself.
> >
> > The only function not covered by hwmon, as far as I can see, is reading
> > the "Fn key" status, whatever that is, and reporting the power status
> > (AC or battery).
> > 
> > The first seems to be covered by the already existing dell drivers in
> > platform/x86. The latter must be covered as well; Linux does
> > display the correct power status on all my Dell laptops.
> 
> How old are they? The i8k driver is ancestral, so I could imagine that
> i8k is the only way to report power status on very old Dell laptop
> models. Or maybe not, I just don't know.
> 
> > Changing the ABI is not supposed to happen, so I am not sure if we can
> > just drop the /proc interface.
> 
> Dropping deprecated interfaces after a transition period is not so
> uncommon. AFAIK the proc interface of i8k is only used by the i8kutils
> user-space package, which FWIW is no longer part of openSUSE. The

It is still in Ubuntu 14.04.

> dell-laptop and dell-wmi drivers are almost 6 years old, that looks
> like an already very comfortable transition period to me.
> 
Hi Jean,

Fine with me. My oldest laptop is about 10 years old.

> That being said, that's only my opinion and I'm not going to fight for
> this. If the hwmon interface is moved to dell-laptop and i8k is killed,
> I'm happy. If the i8k driver is moved to drivers/hwmon and stripped
> down, I'm happy. But if none of this happens, I don't really care, to
> be honest.
> 
I am all for getting rid of it, question is only how to do it,
and if it really can be done.

A quick glance into Lauchpad shows that i8kutils is still maintained
and used, including the sometimes dirty tricks it provides. 

Guenter
