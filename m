Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbaLTDYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 22:24:47 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:52505 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaLTDYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 22:24:45 -0500
Message-ID: <5494EBAB.5080205@roeck-us.net>
Date: Fri, 19 Dec 2014 19:23:23 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v7 0/5] hwmon: ina2xx: implement chip reinitialization
 and add new attributes
References: <1418488041-7433-1-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1418488041-7433-1-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.5494EBFC.0053,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
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

On 12/13/2014 08:27 AM, Bartosz Golaszewski wrote:
> This series implements a mechanism to detect if the chip is in its POR state
> and reinitialize it if needed. It also extends the sysfs interface to make the
> driver configurable at run-time.
>
> The shunt_resistor attribute allows to change the shunt resistance value
> at run-time in cases where ina2xx used to do the measurement isn't integrated
> with the shunt.
>
> The avg_rate attribute allows to increase/decrease noise reduction.
>
> v7:
> - implemented a retry counter for the reinitialization procedure
> - using msleep() (since the sleep is > 20ms) instead of mdelay()
>    when waiting for the chip update
>
> v6:
> https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg787390.html
>
> Bartosz Golaszewski (5):
>    hwmon: ina2xx: reinitialize the chip in case it's been reset
>    hwmon: ina2xx: remove a stray new line
>    hwmon: ina2xx: don't accept shunt values greater than the calibration factor
>    hwmon: ina2xx: make shunt resistance configurable at run-time
>    hwmon: ina2xx: allow to change the averaging rate at run-time
>
>   Documentation/hwmon/ina2xx |   8 +-
>   drivers/hwmon/ina2xx.c     | 304 +++++++++++++++++++++++++++++++++++++++------
>   2 files changed, 269 insertions(+), 43 deletions(-)
>

I didn't forget those patches; I have been busy in the last couple of weeks.
Also, I'll be out for the next two weeks. I'll look into the patches after
I am back.

Guenter

