Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbbAUDvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:51:13 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:47438 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbbAUDvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:51:12 -0500
Message-ID: <54BF221E.8000409@roeck-us.net>
Date: Tue, 20 Jan 2015 19:50:54 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        netdev@vger.kernel.org
CC: "David S . Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: Re: [PATCH] net: dsa: set parent of hwmon device
References: <1421799212-2028-1-git-send-email-vivien.didelot@savoirfairelinux.com>
In-Reply-To: <1421799212-2028-1-git-send-email-vivien.didelot@savoirfairelinux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Suspect
X-CTCH-VOD: Unknown
X-CTCH-Flags: 512
X-CTCH-RefID: str=0001.0A020206.54BF222F.00CF,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=512,sb=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 2
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

On 01/20/2015 04:13 PM, Vivien Didelot wrote:
> Set the dsa device as the parent of the hwmon device, in order to link
> the hwmon subsystem under the corresponding /sys/devices/platform/dsa.X/
> sysfs directory.
>
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> ---
>   net/dsa/dsa.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 3731714..363102a 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -347,7 +347,7 @@ dsa_switch_setup(struct dsa_switch_tree *dst, int index,
>   		hname[j] = '\0';
>   		scnprintf(ds->hwmon_name, sizeof(ds->hwmon_name), "%s_dsa%d",
>   			  hname, index);
> -		ds->hwmon_dev = hwmon_device_register_with_groups(NULL,
> +		ds->hwmon_dev = hwmon_device_register_with_groups(parent,
>   					ds->hwmon_name, ds, dsa_hwmon_groups);
>   		if (IS_ERR(ds->hwmon_dev))
>   			ds->hwmon_dev = NULL;
>

Looking into my old e-mail, turns out we did not add the parent device because
it affected the output of the "sensors" command, and we wanted the device
to be handled as 'virtual device' (which implies no parent). That was an explicit
part of the patch set (v2 of 'net: dsa: Add support for reporting switch chip
temperatures'), compared to v1, which did set the parent device.

I would suggest to keep the code as is.

Thanks,
Guenter

