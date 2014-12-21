Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaLUTvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 14:51:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51393 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbaLUTvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 14:51:41 -0500
Message-ID: <549724B2.4050209@roeck-us.net>
Date: Sun, 21 Dec 2014 11:51:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>
Subject: Re: [PATCH v4] i8k: Autodetect maximal fan speed and fan RPM multiplier
References: <1419153618-6930-1-git-send-email-pali.rohar@gmail.com> <1419182630-20211-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1419182630-20211-1-git-send-email-pali.rohar@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.549724D7.010C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On 12/21/2014 09:23 AM, Pali Rohár wrote:
> This patch adds new function i8k_get_fan_nominal_speed() for doing SMM call
> which will return nominal fan RPM for specified fan speed. It returns nominal
> RPM value at which fan operate when speed (0, 1, 2, 3) is set. It looks like
> RPM value is not accurate, but still provides very useful information.
>
> First it can be used to validate if certain fan speed could be accepted by SMM
> for setting fan speed and we can use this routine to detect maximal fan speed.
>
> Second it returns RPM value, so we can check if value looks correct with
> multiplier 30 or multiplier 1 (until now only these two multiplier were used).
> If RPM value with multiplier 30 is too high, then multiplier 1 is used.
>
> In case when SMM reports that new function is not supported we will fallback
> to old hardcoded values. Maximal fan speed would be 2 and RPM multiplier 30.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> Tested-by: Pali Rohár <pali.rohar@gmail.com>

Auto-detection of both multiplier and maximum speed tested working on M140
(after removing its configuration entry).

On Studio 1555, multiplier auto-detection works, but fan_max auto-detection fails.
A speed value of '3' is accepted, but it does not set the fan speed to its maximum.
Also, after setting the speed value to '3', reading it back returns to old value.
No idea what it does or is expected to do. Reading the nominal speed
does return a valid value.

Given that, I think we should not try to auto-detect fan_max, but keep the current
code (meaning either use 2 or 3 depending on the configuration data, with 2 as default
if nothing else is known).

Thanks,
Guenter

