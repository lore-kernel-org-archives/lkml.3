Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbaLDO2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:28:05 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:59006 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaLDO2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:28:02 -0500
Message-ID: <54806F2A.7070107@roeck-us.net>
Date: Thu, 04 Dec 2014 06:26:50 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Russell King <linux@arm.linux.org.uk>, Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>	<1408495538-27480-9-git-send-email-linux@roeck-us.net> <CAMuHMdVqCa+m1oMkuRHcTZKw2CWNHJVotWBwfTnfBNT11UPEjw@mail.gmail.com>
In-Reply-To: <CAMuHMdVqCa+m1oMkuRHcTZKw2CWNHJVotWBwfTnfBNT11UPEjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.54806F72.012B,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 8
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

On 12/04/2014 05:36 AM, Geert Uytterhoeven wrote:
> Hi Günther,
>
> On Wed, Aug 20, 2014 at 2:45 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>> Implementing a restart handler in a module don't make sense
>> as there would be no guarantee that the module is loaded when
>> a restart is needed. Unexport arm_pm_restart to ensure that
>> no one gets the idea to do it anyway.
>
> Why not? I was just going to do that, but I got greeted by:
>

Because you should register a restart handler instead, like the other
drivers in the same directory now do.

> ERROR: "arm_pm_restart" [drivers/power/reset/rmobile-reset.ko] undefined!
>
> So now we have to make sure all reset drivers for a zillion different
> hardware devices are builtin, and can't be modular?
>
No. All those drivers need to do is to register a restart handler using
the API provided in the patch series.

Ultimately all restart handlers should do that and arm_pm_restart should
go away entirely. That was the point of the patch series.

Guenter

