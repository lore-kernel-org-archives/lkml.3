Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab3HOD3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:29:41 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:53395 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab3HOD3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <520C482F.5090806@roeck-us.net>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-11-git-send-email-Julia.Lawall@lip6.fr> <520C482F.5090806@roeck-us.net>
From: Wan ZongShun <mcuos.com@gmail.com>
Date: Thu, 15 Aug 2013 11:29:19 +0800
Message-ID: <CAKT61h9DCnJZkgi4O6jq41tfd1mS2bZm9vEu=RfvXk_0EWfObQ@mail.gmail.com>
Subject: Re: [PATCH 10/29] drivers/watchdog/nuc900_wdt.c: simplify use of devm_ioremap_resource
To: Guenter Roeck <linux@roeck-us.net>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, kernel-janitors@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-watchdog@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/15 Guenter Roeck <linux@roeck-us.net>:
> On 08/14/2013 02:11 AM, Julia Lawall wrote:
>>
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Remove unneeded error handling on the result of a call to
>> platform_get_resource when the value is passed to devm_ioremap_resource.
>>
>> A simplified version of the semantic patch that makes this change is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @@
>> expression pdev,res,n,e,e1;
>> expression ret != 0;
>> identifier l;
>> @@
>>
>> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>>    ... when != res
>> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>>    ... when != res
>> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>>    e = devm_ioremap_resource(e1, res);
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Acked-by: Wan Zongshun <mcuos.com@gmail.com>

Thanks for your patch.

>
>



-- 
Wan ZongShun.
www.mcuos.com
