Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKKSVD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:21:03 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49291 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaKKSUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:20:51 -0500
Date: Tue, 11 Nov 2014 10:20:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, LeeJon@roeck-us.net
Subject: Re: [PATCH v6 00/48] kernel: Add support for power-off handler call
 chain
Message-ID: <20141111182023.GA21970@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
 <20141110083347.GA29543@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110083347.GA29543@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5462536D.0044,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Mon, Nov 10, 2014 at 09:33:48AM +0100, Pavel Machek wrote:
> Hi!
> 
> > Introduce a system power-off handler call chain to solve the described
> > problems.  This call chain is expected to be executed from the architecture
> > specific machine_power_off() function.  Drivers providing system power-off
> > functionality are expected to register with this call chain.  By using the
> > priority field in the notifier block, callers can control power-off
> > handler
> 
> Linus rather disliked the idea of notifier chains for this... And I
> don't see how it got addressed.
> 
Hi all,

After more thought, I concluded that it is technically impossible to support
multiple power-off handlers without some kind of list or call chain, no matter
how it is called. Given the opposition from Linus and the power maintainers
to the series, I decided to shelf it.

Thanks,
Guenter
