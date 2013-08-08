Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab3HHIdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:33:15 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:9553 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756564Ab3HHIdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:33:12 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 2
X-BigFish: VS2(z3121kz98dI9371I1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz8dhz1de098h8275bh1de097hz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1155h)
Message-ID: <520357DF.3030403@freescale.com>
Date: Thu, 8 Aug 2013 16:33:35 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: <dwmw2@infradead.org>, <dedekind1@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <vikram186@gmail.com>
Subject: Re: [PATCH v6 00/10] mtd: add datasheet's ECC information to nand_chip{}
References: <1368760654-28754-1-git-send-email-b32955@freescale.com> <CAN8TOE-QvScbPUEPyrs-fYVQZmPu1h-wWX2hjz46KYtaWRckBw@mail.gmail.com>
In-Reply-To: <CAN8TOE-QvScbPUEPyrs-fYVQZmPu1h-wWX2hjz46KYtaWRckBw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem & Brian:
> Hi Huang and others,
>
> On Thu, May 16, 2013 at 8:17 PM, Huang Shijie<b32955@freescale.com>  wrote:
>> 1.) Why add the ECC information to the nand_chip{} ?
>>     Each nand chip has its requirement for the ECC correctability, such as
>>     "4bit ECC for each 512Byte" or "40bit ECC for each 1024Byte".
>>     This ECC info is very important to the nand controller, such as gpmi.
>>
>>     Take the Micron MT29F64G08CBABA for example, its geometry is
>>     8k page size, 744 bytes oob size and it requires 40bit ECC per 1K bytes.
>>     If we do not provide the ECC info to the gpmi nand driver, it has to
>>     calculate the ECC correctability itself. The gpmi driver will gets the 56bit
>>     ECC for per 1K bytes which is beyond its BCH's 40bit ecc capibility.
>>     The gpmi will quits in this case. But in actually, the gpmi can supports
>>     this nand chip if it can get the right ECC info.
>>
>> 2.) About the patch set:
>>     2.1) patch 1:
>>                The keynote patch.
>>
>>     2.2) patch 2 ~ patch 6:
>>                 These patches are for ONFI nand.
>>                 Parse out the ecc info from the parameter page if we can, else
>>                 parse out the ecc info from the extended parameter page.
>>
>>     2.2) patch 7 ~ patch 9:
>>                 Add the ECC info for full-id nand, and parse it out.
>>
>>     2.3) patch 10
>>                 The gpmi uses the ecc info to set the BCH module. and with this
>>                 patch set, the gpmi can supports the MT29F64G08CBABA now.
> What's the status on this patch set? Surely by v6 we have some
> reasonable stable state on things like naming. Does anyone have any
> other objections? Unfortunately, I've been awfully distracted, and on
> top of that, I'm running into some bugs with my NAND controller
> sending the ONFI parameter read/change column commands. But any time
> my controller actually outputs a correct parameter page + extended
> parameter page, this series has worked for me.
>
> I've put my 2 cents in on most of the issues I had, and I tested the
> whole series on my driver at around v5. The only issues I have with it
> are somewhat cosmetic and not worth bikeshedding. So for all the
> non-GPMI specific stuff I'll give my:
>
> Reviewed-by: Brian Norris<computersforpeace@gmail.com>
> Tested-by: Brian Norris<computersforpeace@gmail.com>
>
> Thanks for the work Huang.
>
> Brian
>
Could you please merge this patch set?


thanks

Huang Shijie


