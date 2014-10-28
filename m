Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaJ1UEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:04:32 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:32835 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbaJ1UEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:04:30 -0400
Date: Tue, 28 Oct 2014 13:04:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Alan Cox <gnomes@lxorguk.ukuu.org.uk>, Alexander Graf <agraf@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Stuebner <heiko@sntech.de>, Lee Jones <lee.jones@linaro.org>,
        Len Brown <len.brown@intel.com>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= 
	<philippe.retornaz@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v4] kernel: Add support for power-off handler call chain
Message-ID: <20141028200424.GA20617@roeck-us.net>
References: <1414516266-4965-1-git-send-email-linux@roeck-us.net>
 <20141028182312.GA13636@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028182312.GA13636@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.544FF6CE.00AF,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
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

On Tue, Oct 28, 2014 at 07:23:12PM +0100, Pavel Machek wrote:
> On Tue 2014-10-28 10:11:06, Guenter Roeck wrote:
> > Various drivers implement architecture and/or device specific means to
> > power off the system.  For the most part, those drivers set the global
> > variable pm_power_off to point to a function within the driver.
> > 
> > This mechanism has a number of drawbacks.  Typically only one scheme
> > to remove power is supported (at least if pm_power_off is used).
> > At least in theory there can be multiple means remove power, some of
> > which may be less desirable. For example, some mechanisms may only
> > power off the CPU or the CPU card, while another may power off the
> > entire system.  Others may really just execute a restart sequence
> > or drop into the ROM monitor. Using pm_power_off can also be racy
> > if the function pointer is set from a driver built as module, as the
> > driver may be in the process of being unloaded when pm_power_off is
> > called. If there are multiple power-off handlers in the system, removing
> > a module with such a handler may inadvertently reset the pointer to
> > pm_power_off to NULL, leaving the system with no means to remove power.
> > 
> > Introduce a system power-off handler call chain to solve the described
> > problems.  This call chain is expected to be executed from the architecture
> > specific machine_power_off() function.  Drivers and architeceture code
> > providing system power-off functionality are expected to register with
> > this call chain.  When registering a power-off handler, callers can
> > provide a priority to control power-off handler execution sequence
> > and thus ensure that the power-off handler with the optimal capabilities
> > to remove power for a given system is called first.
> > 
> > Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
> > Cc: Alexander Graf <agraf@suse.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > cc: Heiko Stuebner <heiko@sntech.de>
> > Cc: Lee Jones <lee.jones@linaro.org>
> > Cc: Len Brown <len.brown@intel.com>
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
Thanks!

Guenter
