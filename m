Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346AbbAVXQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 18:16:09 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:41546 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbbAVXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 18:16:06 -0500
Message-ID: <54C184B0.7060606@roeck-us.net>
Date: Thu, 22 Jan 2015 15:16:00 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jean Delvare <jdelvare@suse.de>
CC: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] drivers/hwmon/ad7314.c: Do proper sign extension
References: <1421966655-16188-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1421966655-16188-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020204.54C184B3.011D,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 1
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

On 01/22/2015 02:44 PM, Rasmus Villemoes wrote:
> The comment above (data << 2) >> 2 explains what the intention is: To
> use bit 13 of the 14-bit value data as the sign bit. However, this
> doesn't work due to C's promotion rules. data has type s16, but data
> << 2 has type int. To get sign extension, that expression would have
> to be cast back to an s16 before being shifted (at which point C's
> promotion rules would then kick in again and promote the left operand
> to int). As it stands, both expressions are no-ops for any value of
> data.
>
> Avoid these subtleties by using the existing API for
> this. sign_extend32 works equally well for 8 and 16 bit types.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---

Good catch. Applied.

Thanks,
Guenter

