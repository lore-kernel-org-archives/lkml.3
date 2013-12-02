Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3LBB5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 20:57:31 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:43211 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab3LBB5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 20:57:30 -0500
Message-ID: <529BE903.1020408@gtsys.com.hk>
Date: Mon, 02 Dec 2013 09:57:23 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11 ThunderBrowse/3.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 v3] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
References: <1385783513-22502-1-git-send-email-chris.ruehl@gtsys.com.hk> <529A2026.4050605@cogentembedded.com>
In-Reply-To: <529A2026.4050605@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sunday, December 01, 2013 01:28 AM, Sergei Shtylyov wrote:
> Hello.
>
> On 30-11-2013 7:51, Chris Ruehl wrote:
>
>> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
>
>> * init the sts flag to 0 (missed)
>> * Set PORTCS_STS only if VUSB_HS_PHY_TYPE > 1
>> otherwise the register is ReadOnly
>> * Set/Reset correct BIT(28)/BIT(29) for STS
>
>> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
>
> The coding style is still wrong at places...
>
..
>> - hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>> + if ( sts )
>
> Remove spaces around 'sts', please.
...
>> + portsc = (ioread32(ci->hw_bank.regmap[OP_PORTSC])
>> + & PORTSC_STS);
>
> No need for outer (). And it's preferred that an operator is left at the
> end of a first line, not starts the continuation line.
>
> WBR, Sergei
>

Sergei,
Thanks, I will take care of and have a question about style

	 portsc = ioread32(ci->hw_bank.regmap[OP_PORTSC] & PORTSC_STS;

the line in the if/else alignment extent the 80char barrier and should be 
splitted in this case '&' is at 81 .. how serious I should follow this one?

  	 portsc = ioread32(ci->hw_bank.regmap[OP_PORTSC] &
                     PORTSC_STS;

I keep this mail private don't want make too much noise on the list.

regards
Chris
