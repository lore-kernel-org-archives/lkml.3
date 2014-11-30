Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaK3UCe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:02:34 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:53495 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbaK3UCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:02:33 -0500
Message-ID: <547B7791.8030108@roeck-us.net>
Date: Sun, 30 Nov 2014 12:01:21 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH v2 2/5] hwmon: ina2xx: make shunt resistance configurable
 at run-time
References: <1417082350-23470-1-git-send-email-bgolaszewski@baylibre.com> <1417082350-23470-3-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1417082350-23470-3-git-send-email-bgolaszewski@baylibre.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020203.547B77D8.01F9,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 11
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 5
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
> The shunt resistance can only be set via platform_data or device tree. This
> isn't suitable for devices in which the shunt resistance can change/isn't
> known at boot-time.
>
> Add a sysfs attribute that allows to read and set the shunt resistance.
>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
>   drivers/hwmon/ina2xx.c | 62 +++++++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 56 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
> index 0a6b60f..341da67 100644
> --- a/drivers/hwmon/ina2xx.c
> +++ b/drivers/hwmon/ina2xx.c
> @@ -51,6 +51,8 @@
>   #define INA226_ALERT_LIMIT		0x07
>   #define INA226_DIE_ID			0xFF
>
> +/* shunt resistor sysfs attribute index */
> +#define INA2XX_RSHUNT			0x8
>
After reading the datasheet again ... those defines were meant
to reflect registers, not to create 'dummy' index values for software.
Please rearrange your code to not require such constructs; it is just
confusing for others (including me).

Guenter

