Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbbARWTs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 17:19:48 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:49509 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbbARWTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 17:19:47 -0500
Message-ID: <54BC3130.4010401@roeck-us.net>
Date: Sun, 18 Jan 2015 14:18:24 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Nishanth Menon <nm@ti.com>, Grazvydas Ignotas <notasas@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        dt list <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lm-sensors@lm-sensors.org, Rob Herring <robh+dt@kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Pali Rohar <pali.rohar@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] hwmon: Driver for OMAP3 temperature sensor
References: <20141226102933.GA28778@amd> <1419597294-21487-1-git-send-email-sre@kernel.org> <1419597294-21487-3-git-send-email-sre@kernel.org> <CANOLnON6rAQ2+jJEFDKseH2Htu6bqRkURDioGt7zp1Ze73f8Pw@mail.gmail.com> <CAGo_u6qO0ok+GBnm7SQtw6dJuwGN2OuP7CpKDEWawS3V2go4KA@mail.gmail.com> <20141229181556.GA26926@amd> <20141229190448.GA27124@roeck-us.net> <20150103091858.GA30538@amd> <20150107161944.GB9012@roeck-us.net> <20150118203346.GA29863@amd>
In-Reply-To: <20150118203346.GA29863@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54BC3183.0018,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 01/18/2015 12:33 PM, Pavel Machek wrote:

>>>> Pavel,
>>>>
>>>> can you look into the omap4 thermal driver to see if it can be used ?
>>>
>>> After some fixes... yes, it seems to be same hardware.
>>>
>> So this should be the way to go, but then we have others claim that
>> it should not be done because the OMAP3 sensors are too unreliable
>> to use for thermal decisions. Not really sure where that leaves us.
>> I am kind of opposed to have similar drivers for similar chips
>> in two different subsystems.
>>
>> Is it possible to add the patch below to the omap thermal driver
>> and not use it for thermal decisions ?
>
> Well... noone forces you to enable the driver, and I don't think it
> will do any thermal decisions on N900 as it is ... so we should be ok.
>
> Plus, it seems to work reasonably well (say +- 5 C), so situation does
> not seem to be as bad as TI claims.
>
> Nokia was actually using it in production.
>
Ok, I'll assume that omap3 support will be added to the omap thermal driver.

Thanks,
Guenter

