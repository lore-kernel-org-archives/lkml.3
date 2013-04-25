Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3DYGhG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 02:37:06 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:35734
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab3DYGhE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 02:37:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z616jzc89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1155h)
Message-ID: <5178CF71.8010302@freescale.com>
Date: Thu, 25 Apr 2013 14:38:41 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 4/9] mtd: get the ECC info from the Extended Parameter
 Page
References: <1366707297-31309-1-git-send-email-b32955@freescale.com>	<1366707297-31309-5-git-send-email-b32955@freescale.com> <CAN8TOE-yrawXsZzUX-SfNq+COJsRfPNJZJiJBZ=e7uavBPis5g@mail.gmail.com>
In-Reply-To: <CAN8TOE-yrawXsZzUX-SfNq+COJsRfPNJZJiJBZ=e7uavBPis5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月25日 14:20, Brian Norris 写道:
> No, you cannot do this. Some drivers will provide their own cmdfunc,
> so nand_command_lp() is unexpected for those drivers.
ok. got it.
> Your problem seems, instead, that you are executing this function too
> early, before nand_flash_get_type() is able to assign
yes. This is just the case i meet.
> nand_command_lp() to be your cmdfunc. You might just want to call this
> function after the following lines in nand_flash_get_type():
>
>          /* Do not replace user supplied command function! */
>          if (mtd->writesize>  512&&  chip->cmdfunc == nand_command)
>                  chip->cmdfunc = nand_command_lp;
>
I will send a fix patch about this patch.

thanks
Huang Shijie


