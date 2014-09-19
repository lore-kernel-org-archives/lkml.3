Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaISFAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 01:00:09 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:42113 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaISFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 01:00:07 -0400
Message-ID: <541BB84E.5030705@roeck-us.net>
Date: Thu, 18 Sep 2014 21:59:58 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] asm/uapi: Add definition of TIOC[SG]RS485
References: <1411022745-6198-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1411022745-6198-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020206.541BB857.0054,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 09/17/2014 11:45 PM, Ricardo Ribalda Delgado wrote:
> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
> support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
> all the archs. Unfortunaltely the definition of TIOCSRS485 and

s/Unfortunaltely/Unfortunately/

> TIOCGRS485 was missing on the ioctls.h file
>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Otherwise

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
>   arch/alpha/include/uapi/asm/ioctls.h | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/alpha/include/uapi/asm/ioctls.h b/arch/alpha/include/uapi/asm/ioctls.h
> index 92c557b..f30c94a 100644
> --- a/arch/alpha/include/uapi/asm/ioctls.h
> +++ b/arch/alpha/include/uapi/asm/ioctls.h
> @@ -90,6 +90,8 @@
>   #define TIOCSBRK	0x5427  /* BSD compatibility */
>   #define TIOCCBRK	0x5428  /* BSD compatibility */
>   #define TIOCGSID	0x5429  /* Return the session ID of FD */
> +#define TIOCGRS485	_IOR('T', 0x2E, struct serial_rs485)
> +#define TIOCSRS485	_IOWR('T', 0x2F, struct serial_rs485)
>   #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
>   #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
>   #define TIOCGDEV	_IOR('T',0x32, unsigned int) /* Get primary device node of /dev/console */
>

