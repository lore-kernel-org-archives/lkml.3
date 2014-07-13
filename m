Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbaGMO23 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 10:28:29 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:48300 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaGMO2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 10:28:21 -0400
Message-ID: <53C29774.9000208@gmail.com>
Date: Sun, 13 Jul 2014 22:28:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, benh@kernel.crashing.org, kys@microsoft.com,
        schwidefsky@de.ibm.com, teg@jklm.no, Mischa.Jonker@synopsys.com,
        msalter@redhat.com, lars@metafoo.de, richard@nod.at, knaack.h@gmx.de,
        marex@denx.de, rdunlap@infradead.org, linux-input@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-watchdog@vger.kernel.org,
        Liqin Chen <liqin.linux@gmail.com>, Lennox Wu <lennox.wu@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C1F7DE.3060102@gmail.com> <53C1F98D.9030603@gmail.com>
In-Reply-To: <53C1F98D.9030603@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 11:14 AM, Chen Gang wrote:
[...]
> And also find a compiler issue, I will try to fix it, but shall not notify
> kernel mailing list, again. The related issue is below (it seems a kernel
> issue, but in fact, it is a compiler's issue):
> 
>     CC [M]  drivers/staging/lustre/lustre/ptlrpc/sec.o
>   drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'sptlrpc_cli_ctx_expire':
>   drivers/staging/lustre/lustre/ptlrpc/sec.c:309:13: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
>     ctx->cc_ops->die(ctx, 0);
>                ^
>   drivers/staging/lustre/lustre/ptlrpc/sec.c: In function 'ctx_refresh_timeout':
>   drivers/staging/lustre/lustre/ptlrpc/sec.c:594:26: error: 'struct ptlrpc_ctx_ops' has no member named '__die'
>      req->rq_cli_ctx->cc_ops->die(req->rq_cli_ctx, 0);
>                             ^
>   make[5]: *** [drivers/staging/lustre/lustre/ptlrpc/sec.o] Error 1
>   make[4]: *** [drivers/staging/lustre/lustre/ptlrpc] Error 2
>   make[3]: *** [drivers/staging/lustre/lustre] Error 2
>   make[2]: *** [drivers/staging/lustre] Error 2
>   make[1]: *** [drivers/staging] Error 2
>   make: *** [drivers] Error 2
> 

Oh, sorry, after check related details, this is still a kernel issue,
'die' is a macro which defined by most of architectures, so can not
use this common name as a declaration in any other area.

I shall send related patch for it.

Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
