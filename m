Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbaLDQM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:12:57 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:45873 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaLDQMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:12:55 -0500
Date: Thu, 4 Dec 2014 08:11:08 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, Randy Dunlap <rdunlap@infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v7 08/11] arm/arm64: Unexport restart handlers
Message-ID: <20141204161108.GA7385@roeck-us.net>
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>
 <CAMuHMdX-WsVErpiZ_EbFSGxeJEfpu3cRaZzitupiSAA2hXEJ8g@mail.gmail.com>
 <54807505.2000406@roeck-us.net>
 <3875532.ABOh5kXkPb@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3875532.ABOh5kXkPb@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.54808807.016A,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 16
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

On Thu, Dec 04, 2014 at 04:06:22PM +0100, Arnd Bergmann wrote:
> On Thursday 04 December 2014 06:51:49 Guenter Roeck wrote:
> > On 12/04/2014 06:44 AM, Geert Uytterhoeven wrote:
> > > On Thu, Dec 4, 2014 at 3:26 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > >> On 12/04/2014 05:36 AM, Geert Uytterhoeven wrote:
> > >>> On Wed, Aug 20, 2014 at 2:45 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > >>>> Implementing a restart handler in a module don't make sense
> > >>>> as there would be no guarantee that the module is loaded when
> > >>>> a restart is needed. Unexport arm_pm_restart to ensure that
> > >>>> no one gets the idea to do it anyway.
> > >>>
> > >>> Why not? I was just going to do that, but I got greeted by:
> > >>
> > >> Because you should register a restart handler instead, like the other
> > >> drivers in the same directory now do.
> > >
> > > That's a different thing. "there would be no guarantee that the module is
> > > loaded when a restart is needed" is also valid for restart handlers...
> > >
> > 
> > Not really, because you are supposed to unregister the restart handler
> > on unload. Sure, you can instead clear arm_pm_reastart and leave the system
> > with no means to restart ...
> 
> I agree with Geert that your commit message was confusing, it sounds like
> you were referring to drivers that are not yet loaded, while the problem
> that you are really address is drivers that have been unloaded later.
> 
Yes, I realize that now. I should probably have added the rationale
for the entire series to this commit. I'll try to do better next time.

Guenter
