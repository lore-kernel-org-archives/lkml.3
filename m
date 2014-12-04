Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaLDTCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 14:02:43 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:35806 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLDTCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 14:02:42 -0500
Date: Thu, 4 Dec 2014 11:02:38 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH v3 0/3] hwmon: tmp401: support for TMP435 and fix for a
 probe issue
Message-ID: <20141204190238.GA16710@roeck-us.net>
References: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417711553-21311-1-git-send-email-bgolaszewski@baylibre.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5480AFD1.037C,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
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

On Thu, Dec 04, 2014 at 05:45:50PM +0100, Bartosz Golaszewski wrote:
> This series adds support for the TI TMP435 chip and fixes an issue similar
> to the one we observed for ina2xx - ignoring the write errors when probing the
> device.
> 
Series applied, with the tmp435 related patches merged into one.

Thanks,
Guenter

> v3:
> - remove the copyright notice from tmp401.c
> - preinitialize status and skip an 'if'
> 
> v2:
> - changed 'static const char *names' to 'static const char * const names'
>   as checkpatch.pl still complained about this one,
> - updated Documentation and Kconfig on TMP435,
> - added missing error check in tmp401_init_client(),
> - removed the redundant "Initialization failed" string since we'll get
>   'tmp401: probe of X-00XX failed with error -121' anyway in dmesg,
> 
> v1:
> https://www.mail-archive.com/linux-kernel%40vger.kernel.org/msg781930.html
> 
> Bartosz Golaszewski (2):
>   hwmon: tmp401: add TMP435 to the list of supported chips in docs and Kconfig
>   hwmon: tmp401: bail-out from tmp401_probe() in case of write errors
> 
> Patrick Titiano (1):
>   hwmon: tmp401: add support for TI TMP435
> 
>  Documentation/hwmon/tmp401 |  7 +++++--
>  drivers/hwmon/Kconfig      |  2 +-
>  drivers/hwmon/tmp401.c     | 45 ++++++++++++++++++++++++++++++++-------------
>  3 files changed, 38 insertions(+), 16 deletions(-)
> 
> -- 
> 2.1.3
> 
