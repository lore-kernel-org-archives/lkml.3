Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762489Ab3ECCu6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:50:58 -0400
Received: from mail-db8lp0184.outbound.messaging.microsoft.com ([213.199.154.184]:36701
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762367Ab3ECCu5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:50:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 6
X-BigFish: VS6(z616jzc89bhzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1082kz8dhzz2dh2a8h668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1889i1155h)
Message-ID: <51832685.8030503@freescale.com>
Date: Fri, 3 May 2013 10:52:53 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Gupta, Pekon" <pekon@ti.com>
Subject: Re: [PATCH V4 4/9] mtd: get the ECC info from the Extended Parameter
 Page
References: <1366967337-5534-1-git-send-email-b32955@freescale.com>	<1366967337-5534-5-git-send-email-b32955@freescale.com> <CAN8TOE8NnbDTvLPyi5=dciLmLBP2EfSpvYN1GLscy+L0roP6jw@mail.gmail.com>
In-Reply-To: <CAN8TOE8NnbDTvLPyi5=dciLmLBP2EfSpvYN1GLscy+L0roP6jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月03日 07:39, Brian Norris 写道:
> only run the extended parameter page function after that point.
sorry, I prefer to run the extended parameter page function here just 
following the case
"p-> ecc_bits != 0xff". IMHO, the two cases should be put together as 
the onfi spec tells, rather be split out
far away. The extended parameter page function is just the case 
"p->ecc_bits == 0xff".

If we put the nand_flash_detect_ext_param_page() after the point we 
reassign the chip->cmdfunc,
It's a little discrete in logic which makes the code not compact enough.

btw: Could you check you email client? I failed several times for the 
HTML issue.

thanks
Huang Shijie


