Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3DWGOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 02:14:20 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:41057
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148Ab3DWGOT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 02:14:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(z616jzc89bh1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1155h)
Message-ID: <5176271C.7030304@freescale.com>
Date: Tue, 23 Apr 2013 14:15:56 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/8] mtd: get the ECC info from the Extended Parameter
 Page
References: <1366616878-29481-1-git-send-email-b32955@freescale.com>	<1366616878-29481-4-git-send-email-b32955@freescale.com> <CAN8TOE_xOBTv7weAqYinFMmTStXgY93KanV-jDAqFnY=CEfkdQ@mail.gmail.com>
In-Reply-To: <CAN8TOE_xOBTv7weAqYinFMmTStXgY93KanV-jDAqFnY=CEfkdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月23日 05:22, Brian Norris 写道:
> You never sent a command to the chip. How can you expect to read from it?
>
> It seems that you are writing this function with the assumption of a
> particular calling context (a context in which the last command was
> CMD_PARAM). IMO, it would make a lot more sense that this function
> actually send its own CMD_PARAM followed by either X bytes of skipped
> read_buf() or a change read column command. Then it doesn't need the
> "last" argument, and its usage makes much more sense.
>
I finally find why i can not use the CHANGE READ COLUMN command:

When we detect the ONFI nand, we actually use the nand_command() to 
issue the command which
does not works with CHANGE READ COLUMN command.

I use the nand_command_lp() to issue the CHANGE READ COLUMN command, it 
works fine.

I can remove the "last" argument now.

thanks Brian.

Huang Shijie

