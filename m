Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193Ab3HODRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:17:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49903 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab3HODRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:17:05 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520C482F.5090806@roeck-us.net>
Date: Wed, 14 Aug 2013 20:17:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Wan ZongShun <mcuos.com@gmail.com>, kernel-janitors@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/29] drivers/watchdog/nuc900_wdt.c: simplify use of
 devm_ioremap_resource
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr> <1376471493-22215-11-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376471493-22215-11-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:11 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
>
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>    ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>    ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>    e = devm_ioremap_resource(e1, res);
> // </smpl>
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>


