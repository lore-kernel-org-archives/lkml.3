Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaK3Tp7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:45:59 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:51560 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaK3Tp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:45:57 -0500
Message-ID: <547B73B7.7070806@roeck-us.net>
Date: Sun, 30 Nov 2014 11:44:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH v2 1/5] hwmon: ina2xx: bail-out from ina2xx_probe() in
 case of configuration errors
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com> <1417082350-23470-2-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417082350-23470-2-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.547B73F4.0144,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
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

On 11/27/2014 01:59 AM, Bartosz Golaszewski wrote:
> The return value of i2c_smbus_write_word_swapped() isn't checked in
> ina2xx_probe(). This leads to devices being registered even if they cannot
> be physically detected (e.g. device is not powered-up at boot-time).
>
> Even after restoring power to such device, it is left unconfigured as the
> configuration has never been actually written to the register.
>
> Error out in case of write errors in probe and notify the user.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Applied to -next.

Thanks,
Guenter


