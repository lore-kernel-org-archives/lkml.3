Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab3CDDGU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:06:20 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:17742 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754503Ab3CDDGT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:06:19 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z3121kz98dIc89bh936eId772h1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ah1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1155h)
Message-ID: <51340FBF.9090000@freescale.com>
Date: Mon, 4 Mar 2013 11:06:39 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/3] mtd: add new fields to nand_flash_dev{}
References: <1359349039-11510-1-git-send-email-b32955@freescale.com>	 <1359349039-11510-2-git-send-email-b32955@freescale.com> <1362233972.2745.7.camel@sauron>
In-Reply-To: <1362233972.2745.7.camel@sauron>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月02日 22:19, Artem Bityutskiy 写道:
> On Mon, 2013-01-28 at 12:57 +0800, Huang Shijie wrote:
>> As time goes on, we begin to meet the situation that we can not get enough
>> information from some nand chips's id data. Take some Toshiba's nand chips
>> for example. I have 4 Toshiba's nand chips in my hand:
>> 	TC58NVG2S0F, TC58NVG3S0F, TC58NVG5D2, TC58NVG6D2
>>
>> When we read these chips' datasheets, we will get the geometry of these chips:
>> 	TC58NVG2S0F : 4096 + 224
>> 	TC58NVG3S0F : 4096 + 232
>> 	TC58NVG5D2  : 8192 + 640
>> 	TC58NVG6D2  : 8192 + 640
>>
>> But we can not parse out the correct oob size for these chips from the id data.
> Very good start of the commit message - you clearly defined the problem.
>
>> So it is time to add some new fields to the nand_flash_dev{}, and update the
>> detection mechanisms.
> But continued with very poor description of how you address the problem.
> Please, provide a better description.

sorry. It's my fault.

I will add more description in the next version.
>> This patch just adds some new fields to the nand_flash_dev{}:
>>    @id[8] : the 8 bytes id data.
> id[8] = 8 bytes id data, just like password[5] = 5 bytes of password
> data. Please, provide a better commentary.
>
okay.

>>    @id_len: the valid length of the id data.
> What does "valid" mean? Are "invalid" parts?
yes.

  some nand chips may only have 5 valid bytes in the 8 bytes id data 
which is read
  out by the READ ID(0x90) command. for example, the 8 bytes id data may 
like this:
     A1, A2, A3, A4, A5, A1, A2, A3

  The last three bytes are just the repeat of the first three bytes.

Of course, we can remove this field, in other word, treat the last three 
bytes as the
valid bytes too.
>>    @oobsize: the oob size.
> Try to invent a better comment.
>
> Huang, it is not that I am trying to be difficult, but I truly do not
not at all, it's my fault.
> understand how you are solving the issue.
>
My method is:
   Use the 8 bytes id data (which is read out by READ ID command) as the 
keyword.
The 8bytes id data is unique for each nand chip. Do we meet two 
different nand chips
have the same 8 bytes id data? I afraid not.

   Since we can not parse out the oob size for these Toshiba nand chips, 
we can add a
new field oob_size to store the right oob size for the nand chips. 
that's why i add
the @oobsize field.

Are you clear now?

thanks
Huang Shijie






