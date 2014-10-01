Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJAD3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 23:29:05 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:51021 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaJAD3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 23:29:02 -0400
Message-ID: <542B74F5.1080102@roeck-us.net>
Date: Tue, 30 Sep 2014 20:28:53 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH v7 00/11] kernel: Add support for restart handler call
 chain
References: <1408495538-27480-1-git-send-email-linux@roeck-us.net>	<20140930142002.e09ef32392a2b5a7c81e5e57@linux-foundation.org>	<20140930223000.GA20946@roeck-us.net> <20141001094001.2b85f54c@canb.auug.org.au>
In-Reply-To: <20141001094001.2b85f54c@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=0.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.542B74FD.00F3,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 09/30/2014 04:40 PM, Stephen Rothwell wrote:
> Hi Guenter,
>
> On Tue, 30 Sep 2014 15:30:00 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Tue, Sep 30, 2014 at 02:20:02PM -0700, Andrew Morton wrote:
>>> On Tue, 19 Aug 2014 17:45:27 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>>> Introduce a system restart handler call chain to solve the described problems.
>>>
>>> So someone has merged eight of these patches into linux-next but these
>>> three:
>>>
>>> watchdog-s3c2410-add-restart-handler.patch
>>> clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
>>> clk-rockchip-add-restart-handler.patch
>>>
>>> were omitted.  What's up?
>>
>> Most likely PBKC on my side; Looks like I forgot to add those when I created
>> the immutable branch for others to merge. Sorry for that :-(.
>>
>> Having said that, I somehow thought that the clock patches would go in through
>> the clock tree. Heiko, did I get that wrong ? Separately, I sent a pull request
>> that includes the watchdog patch to Wim.
>
> So far, that immutable branch has been merged into the battery tree
> (and thus into linux-next) by Sebastian in order to add (I assume):
>
> 18a702e0de98 power: reset: use restart_notifier mechanism for msm-poweroff
> 371bb20d6927 power: Add simple gpio-restart driver
>
> on top of it.
>
> So, I guess the watchdog and clk trees also need to merge that
> immutable branch and then add their respective patches from the mmotm
> series to their trees.
>
Yes, and now I remember why I did not include those patches: They are not
authored by myself. I thought it was not appropriate for me to include them
in the branch I created. Maybe flawed thinking, but that was my reasoning.

Guenter

